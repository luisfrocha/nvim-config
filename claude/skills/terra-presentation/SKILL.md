---
name: terra-presentation
description: >-
  Generate a single-file HTML slide presentation in the "SecureVault AI — Conversational Insights Beta"
  house style (warm sand/terracotta palette, 16:9 cross-fading slides, staggered fade-in-up/left/right
  entrance animations, animated pipeline diagram, glass cards, dark section dividers, dot navigation,
  keyboard + fullscreen). Use when the user asks for a presentation, deck, slides, showcase or demo
  deck in that look, or says "like the conversational insights beta deck" / "terra deck". Produces
  one self-contained .html in ~/Downloads.
---

# terra-presentation

Builds a self-contained HTML deck that reproduces the look and motion of
`https://pages.github.pie.apple.com/jbhamidipati/Presentations/conversational_insights_beta.html`.
The CSS in `template.html` is that page's stylesheet **copied byte-for-byte**; the script is its
slide/animation engine, with the pipeline stepper generalized. Do not hand-write CSS or JS.

## When to use

A presentation to be *shown* (arrow keys, fullscreen): product showcases, architecture overviews, beta
demos, roadmap decks. For a scrollable, tabbed documentation page use `tabbed-doc-page` instead.

## How to build a deck

1. **Plan the story first.** Typical arc, matching the original: title → agenda → problem/solution →
   divider → 1–3 content slides (pipeline, cards, stats) → next steps → demo/Q&A → closing logo.
   Aim for 8–15 slides. One idea per slide; keep text short (see "Fit" below).
2. **Write a throwaway script outside this skill dir** (e.g. `/tmp/deck_<slug>.py`) that imports the
   helpers and calls `build()`. Usage and every helper are in the `build_deck.py` docstring;
   `reference.md` lists each helper, what it renders, and its animation timing.
   ```python
   import sys, os
   sys.path.insert(0, os.path.expanduser("~/.claude/skills/terra-presentation"))
   from build_deck import *
   build("Deck Title", [title(...), agenda([...]), ..., closing()], out="~/Downloads/<slug>.html")
   ```
   Run it with `python3 /tmp/deck_<slug>.py`. `build()` refuses to write if verification fails
   (leftover placeholders, wrong slide count, not exactly one active slide, external resources).
3. **Check the fit** (below), then tell the user the path. Don't open it yourself.

## Fit — slides clip silently

Each slide is a fixed 16:9 frame with `overflow:hidden`, vertically centered. Too much content is cut
off at both top and bottom with no error. After building, open the deck in a ~1440×810 viewport and run
`check_overflow.js` (paste into evaluate_script); fix every slide with `clipped: true` (shorten text,
split the slide, or use `content(..., packed=True)`). Observed fitting at 1440×810: a 9-step
`pipeline` + one `callout` with `packed=True`; 3 `glass_cards` (one wide); 2 points per side in
`problem_solution`. Larger counts were not tested, so measure. If you cannot run a browser, say the
fit is unchecked rather than claiming the deck is verified.

## Rules

- **Never edit the `<style>` block or engine `<script>` in `template.html`.** Compose from helpers; if a
  layout is missing, write inline-styled HTML into `content(..., body_html)` using CSS variables
  (`var(--terra)`, `var(--sage)`, `var(--warm)`, …) and the `anim()` helper so it animates like the rest.
- **Animate with `anim()` / `.anim` only.** The engine replays `.anim` elements each time a slide opens
  by reading the `animation:` value from the inline style. An element given `.anim` without an
  `animation:` in its style stays invisible (`.anim` starts at opacity 0).
- **One `pipeline()` per slide.** The stepper restarts per slide, but two pipelines on the same slide
  would animate as one sequence (steps are numbered per pipeline).
- **Self-contained.** No external CSS/JS/fonts/images. Links (`cta`) are plain `<a href>` and are fine.
- **Content must come from the user or verified sources.** Never invent metrics, names, dates or
  quotes to fill a slide; ask or leave the slide out. Dates/authors on `title()` are the user's.
- **No secrets** (tokens, keys, internal hostnames the user didn't ask to include).
- The Apple logo (`title`, `closing`) comes from the original deck. Pass `logo=False` to `title()` and
  omit `closing()` if the user doesn't want it.

## Deliberate differences from the original page

- Nav dots are generated only by the script (the original hard-coded 14 dots in HTML *and* appended
  more, producing 28).
- The original's chat-UI demo and feedback-form animations were bespoke to that deck's content and are
  not reproduced; use `seq()` (timed fade-in) to stage chat bubbles or reveals instead.
- The original pipeline hard-coded step colors, slide numbers and a "retry" arc. `pipeline()` reads
  colors from the SVG, works on any slide, and has no retry arc (hand-write one as
  `<g class="pipe-arrow" data-after="N" data-opacity="0.8" opacity="0">…</g>` if needed).

## Files

| File | Purpose |
|---|---|
| `template.html` | page shell: original CSS verbatim + small marked additions + engine script; placeholders `{{TITLE}}`, `{{SLIDES}}` |
| `build_deck.py` | slide/block helpers + `build()` with verification |
| `reference.md` | every helper, CSS class and animation timing |
| `check_overflow.js` | browser snippet that finds silently clipped slides |
