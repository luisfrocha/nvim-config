# reference.md — class and block catalogue for tabbed-doc-page

Every class below is defined in `template.html`'s `<style>` block. Grep here before inventing CSS.
The design tokens (`--accent`, `--green`, `--surface`, `--radius`, …) live in `:root` at the top
of the template; colour accents reuse the named set: `blue green purple orange red teal`.

## Design tokens (read-only)

`--bg --surface --surface-2 --surface-3 --border --border-light --text --text-secondary
--text-muted --accent/-light/-dark --green/-light/-dark --orange/-light --red/-light
--purple/-light --teal/-light --yellow/-light --radius --radius-sm --radius-xs
--shadow-sm/-md/-lg`

## Layout skeleton (already in the template)

`.hero` (dark gradient) › `.nav-bar` > `.nav-inner` (sticky tabs) › `.container` > the
`{{SECTIONS}}` › `footer`. Each section:

```html
<div id="catalog" class="section">        <!-- add " active" on the FIRST section only -->
  <div class="section-header">
    <h2>Asset Catalog</h2>
    <p>One or two sentences introducing the section.</p>
  </div>
  <!-- blocks go here -->
  <div class="section-nav">
    <a class="prev" data-nav="overview"><span class="nav-arrow">{{chevron-left}}</span>
      <span class="nav-text"><span class="nav-label">Previous</span><span class="nav-title">Overview</span></span></a>
    <a class="next" data-nav="approval"><span class="nav-arrow">{{chevron-right}}</span>
      <span class="nav-text"><span class="nav-label">Next</span><span class="nav-title">Approval Flow</span></span></a>
  </div>
</div>
```

A section may have only a `prev` or only a `next`. Chevron SVGs: left is
`<polyline points="15 18 9 12 15 6"/>`, right is `<polyline points="9 18 15 12 9 6"/>`, each in
`<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">`.

## Nav tab

```html
<button class="nav-tab active" data-section="overview">Overview</button>
<button class="nav-tab" data-section="anomalous">Anomalous <span class="tab-dot pending"></span></button>
```
`tab-dot live` = green (shipped), `tab-dot pending` = orange (planned).

## Blocks

**Overview grid** (clickable cards that jump to a tab):
```html
<div class="overview-grid">
  <div class="ov-card" data-navigate="catalog" style="cursor:pointer;">
    <div class="stripe blue"></div>
    <div class="ov-header"><div class="ov-icon blue">{{20px svg}}</div><h4>Asset Catalog</h4></div>
    <p>Short description.</p>
  </div>
</div>
```
`.stripe` and `.ov-icon` take the same accent name: `blue green purple orange red teal`.

**Card** — the workhorse container: `<div class="card"><h3>Title</h3><p>…</p></div>`.
`.card.pad` is unused here; just `.card`. `.two-col` wraps two cards side by side (stacks on mobile).

**Feature list** (checkmark rows inside a card):
```html
<ul class="feature-list">
  <li><span class="icon green">&#x2713;</span><span><strong>Label</strong> — detail</span></li>
</ul>
```
`.icon` accents: `blue green purple orange`.

**Timeline steps:**
```html
<div class="steps">
  <div class="step done"><h4>1. Submit <span class="tag blue">Tag</span></h4><p>…</p></div>
  <div class="step"><h4>2. Pending step</h4><p>…</p></div>
</div>
```
`.step.done` = filled dot; `.step` alone = hollow dot.

**Tags / badges:** `<span class="tag green">Instant</span>` — `blue green purple orange teal
neutral red`. Rows: `<div class="tag-row">…</div>`.

**Mode cards** (two-state cards): `.mode-card` with `.mode-badge auto` (green) or `.mode-badge
manual` (orange) in the `<h4>`.

**Banner / callout:** `<div class="banner info">{{svg}} text</div>` — `info warn success note
danger`.

**Pending block** (a "coming soon" tab):
```html
<div class="pending-block"><div class="pending-circle">⏳</div><h3>In Development</h3>
  <p>…</p><ul class="planned-items"><li>Item</li></ul></div>
```

**Category grid:** `.cat-grid` > `.cat-card` (h4 + p), for compact labelled tiles.

**Flow diagram** — hand-authored dark SVG inside:
```html
<div class="flow-container"><div class="flow-label">DIAGRAM TITLE</div>
  <svg class="flowchart-svg" viewBox="0 0 960 370">…</svg></div>
```
Boxes: `<rect rx="8" fill="#1c1c1e" stroke="#444">` + centered `<text fill="#f5f5f7">`. Decision
diamonds: `<polygon ... stroke="#ff9f0a">`. Terminal states: green `#34c759` / red `#ff3b30`
circles. Arrows need a `<marker id="ah">` in `<defs>` and `marker-end="url(#ah)"`; give each
diagram a unique marker id. Author the diagram at a fixed viewBox and position elements by hand.

**Screenshots:** `.screenshot-wrap > img` (+ `.screenshot-caption`), or `.card.asset-section` with
a trailing `.asset-screenshot > img`, or `.annotated-img` with absolutely-positioned
`.annotation` labels. All need real image files beside the HTML.

## Additions this skill makes (already in template.html, below the "additions" marker)

- `pre.code` — dark code block; `code` inline chip (works inside card/step/td/li/banner).
- `table.doc-table` — th/td table in the card palette.
- `.tag.red`, `.banner.danger`, `.card h4`, `.card ul.plain` / `ol.plain` — gaps the original
  lacked. Reuse these; don't redefine them.
- `.tag { white-space: nowrap; }` — chips never wrap mid-label.
- `.two-col { margin-bottom: 20px; }` — the original added this inline on every `.two-col`; made a
  default so a two-col row isn't flush against the next block.
- `table.doc-table.keyed` — add `keyed` to a `doc-table` whose first column is a short label, to keep
  that column on one line. Don't use it when the first column holds long text/`<code>` (it'd overflow).
- `<strong>Label</strong><span class="sub">detail</span>` inside a `doc-table` cell — puts secondary
  text on its own muted line below the label. The `.sub` line wraps even in a `keyed` first column.
