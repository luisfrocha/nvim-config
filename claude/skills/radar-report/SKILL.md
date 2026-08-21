---
name: radar-report
description: >
  Generate a self-contained HTML report of open radars for an Apple Radar component —
  KPI tiles, classification tabs, per-classification groups, a sortable/filterable table,
  expandable description threads, and distribution charts. Use when the user asks for a
  radar report, an open-radars dashboard, a "report of open bugs" for a component, or
  wants to refresh an existing one. Trigger on: "open radars report", "radar dashboard",
  "generate the radars report", "report for <component>", "open bugs for my component".
---

# Radar Open-Radars Report

Produces one HTML file in `~/Downloads`, self-contained (no external requests), light/dark,
printable.

## Steps

### 1. Resolve the component

The component is a **name + version** pair, e.g. `WPC Analytics | iReporter` (id `1604118`).

```bash
radar component search "<name>"                     # may return nothing for the version name
radar show <a-known-radar-id> -o json               # more reliable: read .component off a radar
```

`radar component search` returned empty for "iReporter" because that is a *version*, not a
component name. Reading `.component` off any radar in the component is the dependable route.

### 2. Fetch the data

Strip the `<dataPolicy:radar>` block — it is appended after the JSON and is not valid JSON.

```bash
radar search -c "<Component | Version>" --open-only --no-limit \
  --fields-requested "id,title,state,substate,priority,classification,assignee,originator,createdAt,keywords,description" \
  -o json 2>/dev/null | sed '/<dataPolicy:radar>/,/<\/dataPolicy:radar>/d' > /tmp/radars.json

# all-time total, for the lead tile's caption
radar search -c "<Component | Version>" --no-limit --ids-only -o json 2>/dev/null \
  | sed '/<dataPolicy:radar>/,/<\/dataPolicy:radar>/d' \
  | node -e "let s='';process.stdin.on('data',d=>s+=d).on('end',()=>console.log((JSON.parse(s).data||[]).length))" \
  > /tmp/alltime.txt
```

**Field gotchas, all learned the hard way:**

- `priorityName` **breaks the query** — it returns non-JSON and the whole search yields nothing.
  Use numeric `priority` and map it yourself.
- An invalid field name returns **zero rows silently**, no error. If you get 0 rows, bisect the
  field list rather than assuming the filter was wrong.
- Valid fields are exactly what `radar show <id> -o json` returns: `assignee, classification,
  component, createdAt, description, id, keywords, originator, priority, state, substate, title`.
  There is no `modifiedAt`, `milestone` or `duplicateOfProblemID`.
- `description` is an **array** of `{addedAt, addedBy, addedByPerson, text}` thread entries, not
  a string. Entry 0 is the original description; the rest are later updates.
- `--open-only` is equivalent to `state != Closed` (verified against raw
  `POST /problems/find` — identical ID sets).

### 3. Build

```bash
node <skill-dir>/build-radar-report.mjs "<Component | Version>" [YYYY-MM-DD] [account-email]
```

Date defaults to today; account is optional and only appears in the coverage note.

### 4. Report honestly

`radar search` returns **only radars the querying account can read**, and gives no total, so
restricted radars are absent rather than reported as withheld. The coverage note says
"readable by <account>" for this reason — do not present the count as absolute. Someone with
broader access will legitimately see more.

## Radar data policy

Output is derived from `<dataSource:radar>` data. The generated file carries the tag and a
handling callout. Permitted: triage, understanding and resolving bugs, Radar automation.
**Prohibited: decisions about people** — the by-assignee chart is labelled as queue depth for
load balancing for exactly this reason. Restrict access to the file to at least the level
needed to read the source radars.

## Files

| File | Purpose |
|---|---|
| `build-radar-report.mjs` | the generator; all layout and chart logic |
| `report-base.css` | the house stylesheet, inlined verbatim into the output |

### About `report-base.css`

Not published in any marketplace and **not** in `~/Sites/data-consumption-platform` (that
checkout predates the tokens its header comment cites). This copy was extracted from the
`<style>` block of an existing report. Its own usage note says to inline the whole file in one
`<style>` block, which is what the generator does.

**Do not write CSS for anything the stylesheet already owns.** Getting this wrong cost four
review rounds. The full contract is in memory as
`report-base-css-template-contract`; the traps most likely to bite again:

- `.c-*` colours **chips**; `.s-*` draws the **row stripe**. They are not interchangeable.
- `.tile` wants `.lab`/`.val`/`.sub` — not `.num`. `.tile.hero .val` is the 46px lead number.
- `.icon-btn` expects two `<svg>` children classed `.moon`/`.sun`, not text glyphs.
- The disclosure is `<button class="tw"><span>▶</span></button>`; rotation is on `.tw span`.
- Group heading is `<div class="sec"><h2>Label<span class="n">N</span></h2>`; the gap comes from
  `.sec h2`'s flex `gap`, so there is **no whitespace** before the span.
- `.callout` accent colour applies to `<b>`, not `<strong>`.
- Crumb separator is `&nbsp;&middot;&nbsp;`.
- `.root` carries `zoom` at ≥1920/2400/3200px, so hardcoded font sizes fight it.

Before styling any element, grep `report-base.css` for the class first.

## Colour

Charts use one hue for magnitude, with `danger` reserved to mark P1 only — identity comes from
the axis label, never from colour. A 5-colour priority ramp was tried and **rejected** by the
`dataviz` skill's `validate_palette.js`: `#dc2626` vs `#b45309` scored ΔE 9.9 for normal vision
against a floor of 15. The shipped pairs pass every check in both modes:

| Mode | data hue | P1 | surface |
|---|---|---|---|
| light | `#1d4ed8` | `#dc2626` | `#fff` |
| dark | `#3b82f6` | `#ef4444` | `#1f2937` |

Re-run the validator if these ever change:

```bash
node <dataviz-skill>/scripts/validate_palette.js "#1d4ed8,#dc2626" --mode light
node <dataviz-skill>/scripts/validate_palette.js "#3b82f6,#ef4444" --mode dark --surface "#1f2937"
```

## Known gaps

- `rdar://` references inside description text are not linkified (only `http(s)://` are).
- Filter dropdowns carry counts on classifications only, matching the reference report.
