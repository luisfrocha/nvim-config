---
name: tabbed-doc-page
description: >-
  Build a single-file, tabbed HTML documentation page in the iReporter "Access Approval Flow"
  house style — dark hero, sticky tab bar, card/overview-grid/timeline/flow-diagram sections,
  and prev/next footer nav. Use when the user asks for a "doc page", "flow page", "feature
  overview page", a presentation-style HTML writeup of a feature/architecture/process, or says
  "make that into a page like the access approval flow". Produces one self-contained .html in
  ~/Downloads with no external requests.
---

# tabbed-doc-page

Generates one self-contained HTML page matching the house style of
`~/Downloads/AccessRequestDocs/iReporter_Access_Approval_Flow.html`: a dark gradient hero, a
sticky tab bar that swaps `.section` panels, Apple-flavoured light cards, and a prev/next footer.

## When to use

Trigger when the user wants a polished, navigable HTML writeup of a feature, architecture,
process, or investigation — not a terse report. Phrases: "doc page", "flow page", "make a page
like the access approval flow", "feature overview page", "presentation-style writeup".

For a dense data/metrics dashboard with KPI tiles and charts, `radar-report`'s stylesheet is a
better fit. This skill is for narrative documentation organised into tabbed sections.

## How to build one

1. **Copy the template.** `template.html` in this skill dir is the Access Approval Flow page with
   its content replaced by 7 placeholders. Its `<style>` block is the original's CSS **verbatim**
   — never edit it. Read `reference.md` for every class the stylesheet already defines, and the
   HTML pattern for each section type.

2. **Decide the sections** from the user's content. Each becomes one tab and one `<div
   class="section" id="...">`. The first section must also carry `active`, and its matching
   `.nav-tab` must carry `active`.

3. **Fill the 7 placeholders:**
   - `{{TITLE}}` — the `<title>`.
   - `{{BADGE}}` — short label in the hero pill (e.g. the product name).
   - `{{H1}}` / `{{SUBTITLE}}` — hero heading and one-sentence summary.
   - `{{NAV_TABS}}` — one `<button class="nav-tab" data-section="ID">Label</button>` per section;
     add ` active` to the first. Optional status dot: `<span class="tab-dot live"></span>` (green)
     or `tab-dot pending` (orange).
   - `{{SECTIONS}}` — the section panels, built from the patterns in `reference.md`.
   - `{{FOOTER}}` — one line, e.g. `Product — Doc Title · Last updated: Month YYYY`.

4. **Wire navigation.** `data-section` on a tab must equal the section's `id`. Overview cards can
   deep-link with `data-navigate="ID"`. Prev/next links use `<a class="prev|next" data-nav="ID">`.
   The script at the bottom (also verbatim) handles all three; don't rewrite it.

5. **Write to `~/Downloads/<slug>.html`** and tell the user the path. Do not open it yourself.

## Rules

- **Never edit the template's `<style>` or `<script>`.** Only replace placeholders and compose
  section HTML from existing classes. Getting new CSS wrong against this stylesheet wastes rounds
  — grep `reference.md` for a class before inventing one. The additions block (clearly marked in
  `template.html`: code/table/`.tag.red`/`.banner.danger`) is the only CSS this skill adds, and it
  is already there — reuse it, don't duplicate it.
- **Self-contained.** No external CSS/JS/font URLs. The one exception the template already makes is
  `<img src="...">` for screenshots; if the user supplies images, reference them by relative path
  and tell the user they must sit beside the HTML, or omit them.
- **Verify before delivering:** every `data-section` has a matching section `id` and vice versa;
  exactly one `.nav-tab.active` and one `.section.active`; no leftover `{{PLACEHOLDER}}`; the file
  contains no `http(s)://` resource links in `<link>`/`<script src>`.
- **No secrets.** If the content came from logs/configs, scan the output for tokens, keys, and
  internal hostnames you were not asked to include.

## Files

| File | Purpose |
|---|---|
| `template.html` | the page shell: original CSS/JS verbatim + marked additions + 7 placeholders |
| `reference.md` | every stylesheet class, and the HTML pattern for each section/block type |
