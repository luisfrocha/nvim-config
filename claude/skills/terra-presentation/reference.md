# terra-presentation reference

Source of truth for the look: `template.html` `<style>` (original stylesheet, verbatim). Palette
(CSS vars): `--terra #C2704E`, `--terra-light`, `--terra-dark`, `--sand #F5EDE3`, `--sand-light #FAF7F2`
(page bg), `--clay #E8D5C4` (borders), `--charcoal #2D2926`, `--warm #6B5E57` (body text),
`--warm-light`, `--sage #6B7F5E`, `--amber`, `--coral`, `--blue-soft`, `--plum`. Headings are
`#1D1D1F`, SF Pro via the system stack.

## Slide helpers (each returns one slide; pass them to `build()` in order)

| Helper | Renders | Motion |
|---|---|---|
| `title(heading, tagline, author, org, date, logo=True)` | Left-aligned 64px heading, Apple logo, rule, bold tagline, author footer. `\n` in heading = line break | static |
| `agenda(items, heading="Agenda")` | Centered vertical timeline with numbered terra dots | items fadeInUp every 0.3s |
| `problem_solution(l_label, l_title, l_points, r_label, r_title, r_points)` | Two columns split by a rule; points are `[(bold, detail)]`; coral ✕ vs sage ✓ | left headings fadeInLeft, right fadeInRight, points fadeInUp 0.2s apart |
| `divider(heading, text)` | Dark charcoal gradient section break, terra-light heading | static |
| `content(label, heading, desc, body_html, packed=False)` | Standard slide: uppercase terra label, h2, intro paragraph, then body blocks. `packed=True` reduces padding for dense slides | label/h2/desc fadeInUp 0.1/0.2/0.3s |
| `cta(heading, sub, link_title, link_url, link_host)` | Big centered "Demo / Q&A" with play icon and optional glass link card | fadeInUp 0.2–0.5s |
| `closing()` | White slide with large Apple logo | static |

## Body blocks (strings to concatenate into `content(..., body_html)`)

| Helper | Renders |
|---|---|
| `pipeline(steps)` | `steps=[(name, subtitle, "code"\|"llm")]`, 1–10. Two snaking rows of 5 with animated connectors. Steps light up gray → pulsing terra border → settled, 0.55s apart, loop with a pause. sage = code, terra tint = LLM |
| `glass_cards(items, cols=2)` | Frosted cards: icon chip, title, text, tags. Item keys: `title, text, icon, color, tags, wide`. Rise in 0.15s apart |
| `plain_cards(items, cols=3)` | White `.card` boxes; `accent` ∈ `accent, sage-accent, blue-accent, plum-accent, amber-accent, filled, sage-filled, blue-filled` |
| `stats(items)` | Big terra numbers with small caps labels: `[(number, label)]` |
| `tiles(items, cols=5)` | Small glass tiles for `[(svg_html, label)]`, e.g. chart-type thumbnails |
| `feat_list(items)` | Check-marked list with hairline dividers |
| `callout(heading, text, terra=False)` | Amber (or terra) highlight box |
| `two_col(left_html, right_html)` | Two equal columns; left fadeInLeft, right fadeInRight |
| `chips(*names)` | Inline monospace chips (tool names, identifiers) |
| `seq(inner_html, at_ms)` | Fades/rises in `at_ms` after the slide opens (chat bubbles, staged reveals) |

Colors for `glass_cards`: `terra, blue, sage, amber, plum, coral`.
Icons (`icon(name, size, color)`): `check x chat retry clock link lock database help play external chevron search book doc`.

## Low-level

- `anim(kind="fadeInUp", delay=0.0, dur=0.5, style="", cls="")` → the `class`/`style` attributes for an
  animated element. Kinds: `fadeInUp`, `fadeInLeft`, `fadeInRight`. Use as `<div {anim("fadeInUp", 0.4)}>`.
- Other CSS from the original usable in raw HTML: `.step-label`, `.tag.t|s|g|b|p|a`, `.cards/.c2/.c3/.c4`,
  `.stats`, `.flow/.pill`, `.hl-box`, `.mockup*`, `.glass`, `.error-found/.insight-found/.beta-badge`,
  `.two-col`, `.feat-list`, `.pulse` (looping opacity). Flowing dots/dashes in the original are plain SVG
  `<animate>` elements (see `pipeline()` in `build_deck.py` for the exact markup).
- Text args are HTML-escaped; names ending `_html` are raw.

## Runtime behavior (engine)

Arrow keys / Space move between slides, `F` toggles fullscreen, dots are clickable, the current slide is
stored in `#slide=N` so a refresh stays put. Slides cross-fade (0.4s); outgoing slide is held as `.prev`
for 0.6s. Entering a slide replays every `.anim`, restarts `.seq` timers and, if the slide contains
`.pipe-step`, restarts the pipeline stepper.
