#!/usr/bin/env node
/**
 * Build a self-contained open-radars HTML report on report-base.css.
 *
 * Usage: node build-radar-report.mjs "<Component | Version>" [YYYY-MM-DD] [account-email]
 *
 * Reads:  /tmp/radars.json     radar search -o json, dataPolicy block stripped
 *         /tmp/alltime.txt     unfiltered count, for the "of N all-time" caption
 *         ./report-base.css    ships beside this script (see SKILL.md for provenance)
 * Writes: ~/Downloads/<component-slug>-open-radars-<date>.html
 *
 * Uses report-base.css's own class contract rather than re-styling on top of it:
 *   .head + h1 + .crumb + <code>   page header and scope chips
 *   .kpis.lead-hero                first tile wider (1.4fr), .tile.hero .val at 46px
 *   .tile > .lab/.val/.sub         tile internals; .accent-* draws the inset stripe
 *   .callout + <b>                 <b> is what picks up the callout's accent colour
 *   .filters                       already a padded card; inputs styled by element
 *   .count + <b>                   right-aligned readout, <b> for the emphasised number
 *   .tabs/.tab/.tab.on + span.n    tabs with counts and the ::after ink bar
 *   .card (no .pad)                rounded bordered table container
 *   thead th + span.ar             sentence-case headers and the sort caret
 *   tr.s-*                         priority stripe on the row's first cell
 *   .chip + .c-*                   chip colours (NOT .s-*, which is the row stripe)
 *   .detail > .entry > .who2/.body description thread; .detail scrolls at 340px
 *
 * Only genuinely new things are added to <style>: chart tokens, the charts grid,
 * pane show/hide, and the collapsed-detail default.
 *
 * Colour: single data hue for magnitude, `danger` reserved for P1. Both pairs
 * validated with the dataviz skill's validate_palette.js against each mode's real
 * card surface (light #1d4ed8/#dc2626 on #fff; dark #3b82f6/#ef4444 on #1f2937 —
 * all checks pass). A 5-colour priority ramp was rejected first: danger vs warning
 * scored ΔE 9.9 for normal vision against a floor of 15.
 */
import { readFileSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';

// Usage: node build-radar-report.mjs "<Component | Version>" [YYYY-MM-DD] [account-email]
//        node build-radar-report.mjs --mine            [YYYY-MM-DD] [account-email]
//
// --mine reports every open radar assigned to the account, across all components. Rows are then
// grouped by component instead of classification, since classification is already the tab axis.
const MINE = process.argv[2] === '--mine';
const COMPONENT = MINE ? null : process.argv[2] || 'WPC Analytics | iReporter';
const REPORT_DATE = process.argv[3] || new Date().toISOString().slice(0, 10);
const ACCOUNT = process.argv[4] || '';

// Filename slug, e.g. "WPC Analytics | iReporter" -> "wpc-analytics-ireporter"
const SLUG = MINE ? 'my' : COMPONENT.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');

const rows = JSON.parse(readFileSync('/tmp/radars.json', 'utf8')).data || [];
const allTime = Number(readFileSync('/tmp/alltime.txt', 'utf8').trim()) || 0;
// Ships beside this script, so the skill keeps working after /tmp is cleared.
const css = readFileSync(new URL('./report-base.css', import.meta.url), 'utf8');

const PRIORITY_LABEL = {
  1: 'Show stopper', 2: 'Expected', 3: 'Important', 4: 'Nice to have', 5: 'Not Set', 6: 'Investigate',
};
// Row stripe by priority; P4/P5 deliberately unstriped so the accent means "needs attention".
const PRIORITY_STRIPE = { 1: 's-danger', 2: 's-warning', 3: 's-info' };
// State chip colour. Status colours always ship beside the state's text label.
const STATE_CHIP = {
  'New Problem': 'c-warning', Analyze: 'c-neutral', Integrate: 'c-info',
  Build: 'c-info', Verify: 'c-success', Closed: 'c-neutral',
};
const FAMILY = {
  'Crash/Hang/Data Loss': 'Bugs', Security: 'Bugs', Performance: 'Bugs', Power: 'Bugs',
  'Serious Bug': 'Bugs', 'Other Bug': 'Bugs', 'UI/Usability': 'Bugs',
  'Feature (New)': 'Features & Enhancements', Enhancement: 'Features & Enhancements',
  Task: 'Tasks',
};
// Order matches the reference report for the classifications that occur here
// (Serious Bug, Other Bug, UI/Usability, Performance, then features, then tasks).
// The unused ones are placed by severity so they slot in sensibly if they ever appear.
const CLASS_ORDER = [
  'Crash/Hang/Data Loss', 'Security', 'Serious Bug', 'Other Bug', 'UI/Usability', 'Performance', 'Power',
  'Feature (New)', 'Enhancement', 'Task',
];

const esc = value =>
  String(value ?? '').replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[ch]);

/**
 * Turn bare URLs in description text into anchors, matching the reference report's own
 * `linkify`. Escape first, then match on the escaped string; excluding `)` and `]` from
 * the URL charset is what makes "(https://example.com/x)" link without swallowing the
 * closing bracket. `.detail a { color: var(--nav) }` already styles the result.
 */
const linkify = text =>
  esc(text).replace(
    /(https?:\/\/[^\s<>"')\]]+)/g,
    url => `<a href="${url}" target="_blank" rel="noreferrer">${url}</a>`
  );

const personName = person => {
  if (!person) return 'Unassigned';
  const full = [person.firstName, person.lastName].filter(Boolean).join(' ').trim();
  return full || person.name || person.email || String(person.dsid ?? 'Unknown');
};

const daysOld = createdAt => {
  const then = new Date(createdAt);
  if (!createdAt || Number.isNaN(+then)) return null;
  return Math.max(0, Math.round((new Date(`${REPORT_DATE}T12:00:00Z`) - then) / 86400000));
};

const radars = rows.map(row => {
  const thread = (Array.isArray(row.description) ? row.description : []).map(entry => ({
    who: personName(entry.addedByPerson ?? entry.addedBy),
    when: (entry.addedAt ?? '').slice(0, 10),
    text: String(entry.text ?? ''),
  }));
  const priority = Number(row.priority ?? 5);
  const classification = row.classification ?? 'Other Bug';
  return {
    id: row.id,
    title: row.title ?? '(no title)',
    state: row.state ?? '—',
    substate: row.substate ?? '',
    priority,
    priorityLabel: `P${priority}`,
    priorityFull: `P${priority} ${PRIORITY_LABEL[priority] ?? ''}`.trim(),
    classification,
    family: FAMILY[classification] ?? 'Bugs',
    component: row.component ? `${row.component.name} | ${row.component.version}` : '—',
    assignee: personName(row.assignee),
    filedBy: personName(row.originator),
    filed: (row.createdAt ?? '').slice(0, 10),
    age: daysOld(row.createdAt),
    keywords: (Array.isArray(row.keywords) ? row.keywords : []).filter(Boolean),
    thread,
  };
});

const tally = (list, key) => {
  const counts = new Map();
  list.forEach(item => {
    const value = typeof key === 'function' ? key(item) : item[key];
    counts.set(value, (counts.get(value) ?? 0) + 1);
  });
  return [...counts.entries()].sort((left, right) => right[1] - left[1]);
};

const inFamily = family => radars.filter(radar => radar.family === family);
const bugs = inFamily('Bugs');
const feats = inFamily('Features & Enhancements');
const tasks = inFamily('Tasks');
const p1 = radars.filter(radar => radar.priority === 1);
const p2 = radars.filter(radar => radar.priority === 2);
const serious = radars.filter(radar => radar.classification === 'Serious Bug');
const biggestClass = tally(radars, 'classification')[0] ?? ['—', 0];
const componentCount = new Set(radars.map(radar => radar.component)).size;

const AGE_BUCKETS = [
  ['0–7 days', age => age <= 7], ['8–30 days', age => age > 7 && age <= 30],
  ['31–90 days', age => age > 30 && age <= 90], ['91–180 days', age => age > 90 && age <= 180],
  ['181–365 days', age => age > 180 && age <= 365], ['Over a year', age => age > 365],
];
const ages = radars.map(radar => radar.age).filter(age => age !== null).sort((left, right) => left - right);
const median = ages.length ? ages[Math.floor(ages.length / 2)] : 0;

// ── charts ───────────────────────────────────────────────────────────────────
const barChart = (data, { highlight = null, width = 560, rowHeight = 26 } = {}) => {
  const max = Math.max(...data.map(([, count]) => count), 1);
  const labelWidth = 138, valueWidth = 46;
  const plot = width - labelWidth - valueWidth;
  const height = Math.max(1, data.length) * rowHeight;
  const bars = data.map(([label, count], index) => {
    const y = index * rowHeight + 4;
    const barHeight = rowHeight - 10;
    const barWidth = Math.max(2, Math.round((count / max) * plot));
    const radius = Math.min(4, barWidth);
    const fill = highlight !== null && String(label).startsWith(highlight) ? 'var(--chart-hot)' : 'var(--chart-hue)';
    const x = labelWidth;
    const path = `M${x} ${y} H${x + barWidth - radius} a${radius} ${radius} 0 0 1 ${radius} ${radius} V${y + barHeight - radius} a${radius} ${radius} 0 0 1 -${radius} ${radius} H${x} Z`;
    return `<g><title>${esc(label)}: ${count} of ${radars.length} (${((count / radars.length) * 100).toFixed(1)}%)</title>
<text x="${labelWidth - 10}" y="${y + barHeight / 2 + 4}" text-anchor="end" class="cl">${esc(label)}</text>
<path d="${path}" fill="${fill}"/>
<text x="${x + barWidth + 8}" y="${y + barHeight / 2 + 4}" class="cv">${count}</text></g>`;
  }).join('\n');
  return `<svg viewBox="0 0 ${width} ${height}" width="100%" height="${height}" role="img" class="bars">${bars}</svg>`;
};

const chartCard = (title, svg, note = '') => `<div class="card pad">
  <h3 style="margin-top:0">${esc(title)}</h3>${svg}
  ${note ? `<div class="sub" style="margin-top:8px">${esc(note)}</div>` : ''}</div>`;

// ── rows ─────────────────────────────────────────────────────────────────────
const COLUMNS = [
  ['', 'tog'], ['rdar', 'id'], ['P', 'pri'], ['State', 'state'],
  ['Title', 'title'], ['Assignee', 'asg'], ['Filed by', 'by'], ['Filed', 'filed'],
];

const rowHtml = radar => {
  const stripe = PRIORITY_STRIPE[radar.priority] ?? '';
  const search = `${radar.id} ${radar.title} ${radar.assignee} ${radar.filedBy} ${radar.classification} ${radar.state} ${radar.thread.map(entry => entry.text).join(' ').slice(0, 600)}`.toLowerCase();
  const entries = radar.thread.length
    ? radar.thread.map(entry => `<div class="entry">
      <div class="who2">${esc(entry.who)} &middot; ${esc(entry.when)}</div>
      <div class="body">${linkify(entry.text)}</div>
    </div>`).join('\n')
    : '<div class="none">No description recorded.</div>';

  return `<tr class="r ${stripe}" data-id="${radar.id}" data-fam="${esc(radar.family)}"
  data-pri="${radar.priorityLabel}" data-state="${esc(radar.state)}" data-asg="${esc(radar.assignee)}"
  data-cls="${esc(radar.classification)}" data-comp="${esc(radar.component)}" data-search="${esc(search)}">
  <td class="tog"><button class="tw${radar.thread.length ? '' : ' none'}" aria-label="${radar.thread.length ? 'Show description' : 'No description'}"><span>&#9654;</span></button></td>
  <td class="num"><a href="rdar://problem/${radar.id}">${radar.id}</a></td>
  <td><span class="chip ${radar.priority <= 2 ? (radar.priority === 1 ? 'c-danger' : 'c-warning') : 'c-neutral'}" title="${esc(radar.priorityFull)}">${radar.priorityLabel}</span></td>
  <td class="who"><span class="chip ${STATE_CHIP[radar.state] ?? 'c-neutral'}">${esc(radar.state)}</span>${radar.substate ? ` <span class="sub">${esc(radar.substate)}</span>` : ''}</td>
  <td>${esc(radar.title)}</td>
  <td class="who">${esc(radar.assignee)}</td>
  <td class="who">${esc(radar.filedBy)}</td>
  <td class="num">${esc(radar.filed || '—')}</td>
</tr>
<tr class="det" data-det="${radar.id}"><td colspan="8">
  <div class="detail">
${entries}
  </div>
</td></tr>`;
};

// Groups: classification for a single component, component for --mine. In --mine a component
// group spans several families, so tab filtering is done per row (see render) rather than by a
// group-level data-fam — which also keeps both modes on one code path.
const GROUP_BY = MINE ? 'component' : 'classification';
const GROUP_ORDER = MINE
  ? tally(radars, 'component').map(([name]) => name) // busiest component first
  : CLASS_ORDER.filter(cls => radars.some(radar => radar.classification === cls));

const allGroups = GROUP_ORDER.map(name => {
  const members = radars
    .filter(radar => radar[GROUP_BY] === name)
    .sort((left, right) => left.priority - right.priority || (right.age ?? 0) - (left.age ?? 0));
  return `<div class="sec grp" data-grp="${esc(name)}">
  <h2>${esc(name)}<span class="n">${members.length}</span></h2>
  <div class="card"><table class="tbl"><thead><tr>
${COLUMNS.map(([label, key]) => key === 'tog'
      ? '    <th class="tog"></th>'
      : `    <th data-k="${key}"${key === 'filed' || key === 'id' ? ' class="num"' : ''}>${esc(label)} <span class="ar"></span></th>`).join('\n')}
  </tr></thead><tbody>
${members.map(rowHtml).join('\n')}
  </tbody></table></div>
</div>`;
  })
  .join('\n');

// Filter options carry their own counts and follow a meaningful order — severity for
// classification, lifecycle for state, numeric for priority — rather than alphabetical.
// The count lives in the option's text only; `value` stays the bare key so filtering is
// unaffected.
const PRIORITY_ORDER = ['P1', 'P2', 'P3', 'P4', 'P5', 'P6'];
const STATE_ORDER = ['New Problem', 'Analyze', 'Integrate', 'Build', 'Verify'];

const options = (values, label, { order = null, counts = false } = {}) => {
  const tallies = new Map();
  values.forEach(value => tallies.set(value, (tallies.get(value) ?? 0) + 1));
  const rank = key => {
    const index = order ? order.indexOf(key) : -1;
    return index === -1 ? Number.MAX_SAFE_INTEGER : index;
  };
  const keys = [...tallies.keys()].sort(
    (left, right) => rank(left) - rank(right) || left.localeCompare(right)
  );
  return [
    `<option value="">${label}</option>`,
    ...keys.map(key => `<option value="${esc(key)}">${esc(key)}${counts ? ` (${tallies.get(key)})` : ''}</option>`),
  ].join('');
};

const tile = (label, value, caption, accent, lead = false) => `<div class="tile${lead ? ' hero' : ''} ${accent}">
  <div class="lab">${esc(label)}</div><div class="val">${value}</div><div class="sub">${esc(caption)}</div></div>`;

const html = `<!DOCTYPE html>
<html lang="en" class="dark">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${MINE ? "My Open Radars" : esc(COMPONENT)}</title>
<!--
  <dataSource:radar>
  Derived from Apple Radar data. Access to this file must be restricted to at least the
  level of access required to gather the input Radar data.
  Permitted: triage, understanding and resolving bugs, Radar automation.
  Prohibited: making decisions about people (e.g. performance review).
  </dataSource:radar>
-->
<style>
${css}

/* ── additions only; everything above is report-base.css verbatim ───────────── */
/* Chart hues, validated per mode against that mode's card surface. */
:root { --chart-hue: #1d4ed8; --chart-hot: #dc2626; }
html.dark { --chart-hue: #3b82f6; --chart-hot: #ef4444; }
.bars .cl { fill: var(--ink-2); font-size: 11.5px; }
.bars .cv { fill: var(--ink); font-size: 11.5px; font-variant-numeric: tabular-nums; }
.charts { display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 12px; }
.charts h3 { margin: 0 0 6px; }
/* Tab panes and collapsed description rows are behaviour, not styling. */
.pane { display: none } .pane.on { display: block }
tr.det { display: none } tr.det.show { display: table-row }
/* Hover uses the nav tint, matching the reference; --surface-2 read as a grey wash. */
tr.r { cursor: pointer } tr.r:hover td { background: var(--nav-bg) }
/* .tw, .tw span and tr.r.open .tw are fully specified in report-base.css — the disclosure
   is a <button> with a nested <span>, and the rotation belongs on the span. Do not re-style. */
/* Group wrappers are .sec and their headings are h2, so .sec h2 (margin 0 0 8px, flex with an
   8px gap for span.n) and .sec's own 22px bottom margin already set the rhythm. Nothing to add. */
table.tbl { width: 100%; border-collapse: collapse }
@media print { .pane { display: block !important } tr.det { display: table-row !important } }
</style>
</head>
<body class="body">
<div class="root cuboid-root">

  <div class="head">
    <div>
      <h1>${MINE ? "My Open Radars" : `${esc(COMPONENT)} &middot; Open Radars`}</h1>
      <div class="crumb">${MINE ? `Assignee <code>${esc(ACCOUNT || "me")}</code>` : `Component <code>${esc(COMPONENT)}</code>`} &nbsp;&middot;&nbsp;
        Scope <code>state != Closed</code> &nbsp;&middot;&nbsp; ${esc(REPORT_DATE)}
        &nbsp;&middot;&nbsp; Source <code>radar search ${MINE ? "-a me" : "-c <component>"} --open-only</code></div>
    </div>
    <button id="theme" class="icon-btn no-print" title="Toggle light / dark" aria-label="Toggle light or dark mode">
      <svg class="moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/></svg>
      <svg class="sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M2 12h2M20 12h2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>
    </button>
  </div>

  <div class="kpis lead-hero">
    ${tile('Open radars', radars.length, MINE ? `across ${componentCount} component${componentCount === 1 ? '' : 's'}` : `of ${allTime.toLocaleString('en-US')} all-time in this component`, 'accent-neutral', true)}
    ${tile('Bugs', bugs.length, `${serious.length} classed Serious`, 'accent-danger')}
    ${tile('Features', feats.length, 'Feature (New) plus Enhancement', 'accent-info')}
    ${tile('Tasks', tasks.length, biggestClass[0] === 'Task' ? 'largest single bucket' : `${biggestClass[0]} is larger`, 'accent-warning')}
    ${tile('P1', p1.length, `${p2.length} at P2`, 'accent-danger')}
  </div>

  <div class="callout">
    <b>Coverage note.</b> Covers the ${radars.length} open radars readable by <code>${esc(ACCOUNT)}</code>.
    Radars restricted from this account are absent from the result set rather than reported as withheld,
    so these are readable-by totals, not absolute counts for the component.
  </div>

  <div class="filters no-print">
    <input id="q" type="search" placeholder="Search title, description, rdar ID, assignee">
    <select id="fpri">${options(radars.map(radar => radar.priorityLabel), 'All priorities', { order: PRIORITY_ORDER })}</select>
    <select id="fstate">${options(radars.map(radar => radar.state), 'All states', { order: STATE_ORDER })}</select>
    <select id="fasg">${options(radars.map(radar => radar.assignee), 'All assignees')}</select>
    <select id="fcls">${options(radars.map(radar => radar.classification), 'All classifications', { order: CLASS_ORDER, counts: true })}</select>
    ${MINE ? `<select id="fcomp">${options(radars.map(radar => radar.component), 'All components', { counts: true })}</select>` : ''}
    <button id="expand" class="btn">Expand all</button>
    <button id="reset" class="btn">Reset filters</button>
    <span id="count" class="count"></span>
  </div>

  <div class="tabs" id="tabs">
    <button class="tab" data-tab="Overview">Overview</button>
    <button class="tab on" data-tab="Bugs">Bugs <span class="n">${bugs.length}</span></button>
    <button class="tab" data-tab="Features &amp; Enhancements">Features &amp; Enhancements <span class="n">${feats.length}</span></button>
    <button class="tab" data-tab="Tasks">Tasks <span class="n">${tasks.length}</span></button>
    <button class="tab" data-tab="All">All <span class="n">${radars.length}</span></button>
  </div>

  <div class="pane" data-pane="Overview">
    <div class="charts">
      ${chartCard('By state', barChart(tally(radars, 'state')))}
      ${chartCard('By priority', barChart(tally(radars, 'priorityLabel').sort((left, right) => left[0].localeCompare(right[0])), { highlight: 'P1' }), 'P1 is marked in red; every other bar shares one hue, so colour never carries identity alone.')}
      ${chartCard('By classification', barChart(tally(radars, 'classification')))}
      ${chartCard('Age of open radars', barChart(AGE_BUCKETS.map(([label, test]) => [label, radars.filter(radar => radar.age !== null && test(radar.age)).length])), `Median ${median} days.`)}
      ${chartCard('Analyze substate', barChart(tally(radars.filter(radar => radar.state === 'Analyze'), radar => radar.substate || '(none)')))}
      ${chartCard('By assignee — top 12 by queue depth', barChart(tally(radars, 'assignee').slice(0, 12)), 'Queue depth, for triage and load balancing. Radar policy prohibits using this data to make decisions about people.')}
    </div>
  </div>

  <div class="pane on" data-pane="table">
${allGroups}
    <div id="empty" class="empty" style="display:none">No radars match these filters.</div>
  </div>

  <div class="callout info">
    <b>Source and handling.</b> Generated ${esc(REPORT_DATE)} from Apple Radar via
    <code>radar search ${MINE ? "-a me" : `-c "${esc(COMPONENT)}"`} --open-only</code>. Radar data is tagged
    <code>&lt;dataSource:radar&gt;</code>: permitted for triage, understanding and resolving bugs, and
    Radar automation; it must not be used to make decisions about people. Restrict access to this file to
    at least the level required to read the source radars.
  </div>

</div>

<script>
const $ = id => document.getElementById(id);
const allRows = [...document.querySelectorAll('tr.r')];
const detailOf = new WeakMap();
allRows.forEach(row => detailOf.set(row, row.nextElementSibling));
const openIds = new Set();
let expandAll = false;
let activeTab = 'Bugs';

const matches = row => {
  const q = $('q').value.trim().toLowerCase();
  if (q && !row.dataset.search.includes(q)) return false;
  if ($('fpri').value && row.dataset.pri !== $('fpri').value) return false;
  if ($('fstate').value && row.dataset.state !== $('fstate').value) return false;
  if ($('fasg').value && row.dataset.asg !== $('fasg').value) return false;
  if ($('fcls').value && row.dataset.cls !== $('fcls').value) return false;
  // Only rendered in --mine mode, so guard on existence rather than assuming it.
  const comp = $('fcomp');
  if (comp && comp.value && row.dataset.comp !== comp.value) return false;
  return true;
};

function render() {
  document.querySelectorAll('.tab').forEach(tab => tab.classList.toggle('on', tab.dataset.tab === activeTab));
  const charts = activeTab === 'Overview';
  document.querySelector('.pane[data-pane="Overview"]').classList.toggle('on', charts);
  document.querySelector('.pane[data-pane="table"]').classList.toggle('on', !charts);

  let shown = 0;
  let total = 0;

  document.querySelectorAll('.grp').forEach(group => {
    let any = false;
    let visibleHere = 0;
    group.querySelectorAll('tr.r').forEach(row => {
      // Per row, not per group: a --mine component group spans several families.
      const inTab = !charts && (activeTab === 'All' || row.dataset.fam === activeTab);
      const ok = inTab && matches(row);
      row.style.display = ok ? '' : 'none';
      const detail = detailOf.get(row);
      const open = ok && (expandAll || openIds.has(row.dataset.id));
      detail.classList.toggle('show', open);
      detail.style.display = open ? '' : 'none';
      row.classList.toggle('open', open);
      if (inTab) { total++; if (ok) { shown++; any = true; visibleHere++; } }
    });
    group.style.display = any ? '' : 'none';
    // The heading count tracks what's actually shown, so it stays honest under a filter.
    const badge = group.querySelector('h2 .n');
    if (badge) badge.textContent = visibleHere;
  });

  $('count').innerHTML = charts
    ? \`<b>\${allRows.length}</b> open radars\`
    : \`Showing <b>\${shown}</b> of \${total} in this tab &middot; \${allRows.length} open overall\`;
  $('empty').style.display = !charts && shown === 0 ? '' : 'none';
}

// Sort carets: only the active column of each table shows one.
function paintCarets(table, key, dir) {
  table.querySelectorAll('thead th .ar').forEach(caret => { caret.textContent = ''; });
  const th = table.querySelector(\`thead th[data-k="\${key}"] .ar\`);
  if (th) th.textContent = dir === 1 ? '\\u25B2' : '\\u25BC';
}

function sortTable(table, key) {
  const body = table.querySelector('tbody');
  const dir = table.dataset.sortKey === key && table.dataset.sortDir === '1' ? -1 : 1;
  table.dataset.sortKey = key;
  table.dataset.sortDir = String(dir);
  const valueOf = row => {
    switch (key) {
      case 'id': return Number(row.dataset.id);
      case 'pri': return Number(row.dataset.pri.slice(1));
      case 'filed': return row.cells[7].textContent.trim();
      case 'state': return row.dataset.state;
      case 'asg': return row.dataset.asg;
      case 'by': return row.cells[6].textContent.trim();
      default: return row.cells[4].textContent.trim().toLowerCase();
    }
  };
  const pairs = [...body.querySelectorAll('tr.r')].map(row => [row, detailOf.get(row)]);
  pairs.sort(([a], [b]) => {
    const x = valueOf(a), y = valueOf(b);
    return (x < y ? -1 : x > y ? 1 : 0) * dir;
  });
  pairs.forEach(([row, detail]) => body.append(row, detail));
  paintCarets(table, key, dir);
}

// Rows arrive sorted by priority, so show that caret from the start.
document.querySelectorAll('table.tbl').forEach(table => {
  table.dataset.sortKey = 'pri';
  table.dataset.sortDir = '1';
  paintCarets(table, 'pri', 1);
});

$('tabs').addEventListener('click', event => {
  const tab = event.target.closest('.tab');
  if (!tab) return;
  activeTab = tab.dataset.tab;
  render();
});

document.addEventListener('click', event => {
  if (event.target.closest('a')) return;
  const th = event.target.closest('th[data-k]');
  if (th) { sortTable(th.closest('table'), th.dataset.k); return; }
  const row = event.target.closest('tr.r');
  if (!row) return;
  const id = row.dataset.id;
  if (openIds.has(id)) openIds.delete(id); else openIds.add(id);
  expandAll = false;
  $('expand').textContent = 'Expand all';
  render();
});

for (const id of ['q', 'fpri', 'fstate', 'fasg', 'fcls', 'fcomp']) $(id)?.addEventListener('input', render);

$('expand').addEventListener('click', () => {
  expandAll = !expandAll;
  openIds.clear();
  $('expand').textContent = expandAll ? 'Collapse all' : 'Expand all';
  render();
});

$('reset').addEventListener('click', () => {
  $('q').value = '';
  for (const id of ['fpri', 'fstate', 'fasg', 'fcls', 'fcomp']) { const el = $(id); if (el) el.value = ''; }
  expandAll = false; openIds.clear();
  $('expand').textContent = 'Expand all';
  render();
});

$('theme').addEventListener('click', () => document.documentElement.classList.toggle('dark'));
if (window.matchMedia && !window.matchMedia('(prefers-color-scheme: dark)').matches) {
  document.documentElement.classList.remove('dark');
}

render();
</script>
</body>
</html>
`;

const out = join(homedir(), 'Downloads', `${SLUG}-open-radars-${REPORT_DATE}.html`);
writeFileSync(out, html);
console.log(`wrote ${out}`);
console.log(`  open radars ............. ${radars.length}  (all-time ${allTime})`);
console.log(`  Bugs / Features / Tasks . ${bugs.length} / ${feats.length} / ${tasks.length}`);
console.log(`  P1 / P2 ................. ${p1.length} / ${p2.length}`);
console.log(`  thread entries rendered . ${radars.reduce((sum, radar) => sum + radar.thread.length, 0)}`);
console.log(`  median age .............. ${median} days`);
console.log(`  size .................... ${(html.length / 1024).toFixed(0)} KB`);
