"""Assemble a terra-presentation deck from a list of slides.

Usage (from a throwaway script outside this skill dir):

    import sys, os
    sys.path.insert(0, os.path.expanduser("~/.claude/skills/terra-presentation"))
    from build_deck import *

    build("My Deck", [
        title("Big Idea\\nSubtitle line", "Tagline", author="Jane Doe", org="Team", date="Oct 2026"),
        agenda(["Problem", "Solution", "Next steps"]),
        divider("Part One", "One-sentence framing."),
        content("Roadmap", "Next Steps", "Intro sentence.", glass_cards([...])),
        cta("Demo", "Q&A", "My App", "https://example.com", "example.com"),
        closing(),
    ], out="~/Downloads/my-deck.html")

Every helper returns an HTML string for one slide (wrapped by build() with its data-slide
number). Text arguments are HTML-escaped; "\\n" becomes <br>. Arguments ending in `_html`
are inserted raw. build() verifies the result and writes the file only if the checks pass.
"""
import html
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))

APPLE_D = "M273.81 52.973C313.806.257 369.41 0 369.41 0s8.271 49.562-31.463 97.306c-42.426 50.98-90.649 42.638-90.649 42.638s-9.055-40.094 26.512-86.971zM252.385 174.662c20.576 0 58.764-28.284 108.471-28.284 85.562 0 119.222 60.883 119.222 60.883s-65.833 33.659-65.833 115.331c0 92.133 82.01 123.885 82.01 123.885s-57.328 161.357-134.628 161.357c-35.553 0-63.245-23.984-100.737-23.984-38.189 0-73.676 24.896-100.81 24.896C86.6 608.728 0 455.848 0 332.658c0-121.688 76.079-185.315 147.236-185.315 46.404 0 82.427 26.316 105.149 27.319z"

# name -> (css color, translucent background used behind icons)
COLORS = {
    "terra": ("var(--terra)", "rgba(194,112,78,0.1)"),
    "blue": ("var(--blue-soft)", "rgba(91,127,165,0.1)"),
    "sage": ("var(--sage)", "rgba(107,127,94,0.1)"),
    "amber": ("var(--amber)", "rgba(184,134,11,0.1)"),
    "plum": ("var(--plum)", "rgba(139,107,123,0.1)"),
    "coral": ("var(--coral)", "rgba(232,131,107,0.1)"),
}

# Stroke icons (24x24 viewBox), taken from the original deck
ICONS = {
    "check": '<polyline points="20 6 9 17 4 12"></polyline>',
    "x": '<line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line>',
    "chat": '<path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"></path>',
    "retry": '<polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 105.64-12.36L1 10"></path>',
    "clock": '<circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline>',
    "link": '<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path>',
    "lock": '<path d="M14 9V5a3 3 0 0 0-6 0v4"></path><rect x="6" y="9" width="12" height="13" rx="2"></rect><circle cx="12" cy="16" r="1"></circle>',
    "database": '<ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>',
    "help": '<circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line>',
    "play": '<polygon points="5 3 19 12 5 21 5 3"></polygon>',
    "external": '<path d="M18 13v6a2 2 0 01-2 2H5a2 2 0 01-2-2V8a2 2 0 012-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line>',
    "chevron": '<polyline points="9 18 15 12 9 6"></polyline>',
    "search": '<circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>',
    "book": '<path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>',
    "doc": '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line>',
}


def esc(s):
    """Escape text; '\\n' -> <br>."""
    return html.escape(str(s), quote=False).replace("\n", "<br>")


def icon(name, size=20, color="var(--terra)", sw=1.5, style=""):
    return (f'<svg width="{size}" height="{size}" viewBox="0 0 24 24" fill="none" stroke="{color}" '
            f'stroke-width="{sw}" stroke-linecap="round" stroke-linejoin="round" style="{style}">{ICONS[name]}</svg>')


def anim(kind="fadeInUp", delay=0.0, dur=0.5, style="", cls=""):
    """Attributes for an entrance-animated element. kind: fadeInUp | fadeInLeft | fadeInRight."""
    cls_attr = f"anim {cls}".strip()
    return f'class="{cls_attr}" style="{style}{"; " if style and not style.rstrip().endswith(";") else ""}animation: {kind} {dur}s ease forwards {delay}s;"'


def _frame(inner, cls="", style=""):
    return f'<div class="slide-frame {cls}" style="{style}">{inner}</div>'


# ---------------------------------------------------------------- slide types

def title(heading, tagline, author="", org="", date="", logo=True):
    """Opening slide: logo, big left-aligned heading, rule, bold tagline, author footer."""
    parts = [x for x in (author, org, date) if x]
    meta = ""
    for i, p in enumerate(parts):
        if i == 0:
            meta += f'<span style="font-size:16px; font-weight:600; color:#1D1D1F;">{esc(p)}</span>'
        else:
            meta += ('<span style="font-size:16px; color:#86868B; margin-left:8px;">·</span>'
                     f'<span style="font-size:16px; color:#86868B; margin-left:8px;">{esc(p)}</span>')
    logo_svg = (f'<svg xmlns="http://www.w3.org/2000/svg" width="44" height="52" viewBox="0 0 496.255 608.728" '
                f'fill="#1D1D1F" style="margin-bottom:20px;"><path d="{APPLE_D}"></path></svg>') if logo else ""
    footer = (f'<div style="position:absolute; bottom:56px; left:72px; right:72px;"><div style="border-top:1px solid #D2D2D7; '
              f'padding-top:12px;">{meta}</div></div>') if meta else ""
    inner = f'''
      <div style="padding:60px 56px 36px; width:100%; margin-top:24px;">
        {logo_svg}
        <h1 style="font-family:-apple-system,'SF Pro Display','Helvetica Neue',sans-serif; font-size:64px; font-weight:700; color:#1D1D1F; line-height:1.1; letter-spacing:-1.5px; margin:0 0 20px;">{esc(heading)}</h1>
        <div style="width:100%; height:1px; background:#D2D2D7; margin-bottom:18px;"></div>
        <p style="font-family:-apple-system,'SF Pro Display','Helvetica Neue',sans-serif; font-size:26px; font-weight:700; color:#1D1D1F; margin:0; letter-spacing:-0.3px;">{esc(tagline)}</p>
      </div>
      {footer}'''
    return "slide-content", _frame(inner, style="position:relative; justify-content:center; align-items:flex-start;")


def agenda(items, heading="Agenda"):
    """Vertical timeline whose numbered items rise in one after another (0.3s apart)."""
    rows = ""
    for i, it in enumerate(items):
        last = i == len(items) - 1
        rows += f'''
        <div {anim("fadeInUp", round(0.3 * (i + 1), 2), style=f"position:relative; margin-bottom:{0 if last else 28}px;")}>
          <div style="position:absolute; left:-40px; top:4px; width:24px; height:24px; border-radius:50%; background:var(--terra); display:flex; align-items:center; justify-content:center;">
            <span style="color:white; font-size:11px; font-weight:700;">{i + 1}</span>
          </div>
          <span style="font-size:22px; font-weight:600; color:#1D1D1F;">{esc(it)}</span>
        </div>'''
    inner = f'''
      <h2 style="font-size:42px; font-weight:700; color:#1D1D1F; letter-spacing:-1px; margin:0 0 40px 0;">{esc(heading)}</h2>
      <div style="position:relative; padding-left:40px; max-width:500px; text-align:left;">
        <div style="position:absolute; left:11px; top:8px; bottom:8px; width:2px; background:var(--clay);"></div>{rows}
      </div>'''
    return "slide-content", _frame(inner, "centered")


def _points(points, kind, start):
    """points: [(bold, detail)]; kind 'bad' (coral x) or 'good' (sage check)."""
    color, name = ("var(--coral)", "x") if kind == "bad" else ("var(--sage)", "check")
    out = ""
    for i, (b, d) in enumerate(points):
        out += f'''
          <div {anim("fadeInUp", round(start + 0.2 * i, 2), 0.45, style="display:flex; align-items:flex-start; gap:12px;")}>
            {icon(name, 20, color, style="flex-shrink:0; margin-top:2px;")}
            <div><strong style="color:#1D1D1F; font-size:14px;">{esc(b)}</strong><br><span style="font-size:13px; color:var(--warm);">{esc(d)}</span></div>
          </div>'''
    return out


def problem_solution(left_label, left_title, left_points, right_label, right_title, right_points):
    """Split slide: coral 'problem' column slides in from the left, sage 'solution' from the right."""
    def head(label, color, ttl, side, d1, d2):
        return (f'<div {anim(side, d1, style=f"font-size:11px; font-weight:700; color:{color}; text-transform:uppercase; letter-spacing:2px; margin-bottom:8px;")}>{esc(label)}</div>'
                f'<h2 {anim(side, d2, style="font-size:32px; font-weight:700; color:#1D1D1F; letter-spacing:-0.5px; margin:0 0 20px 0; line-height:1.15;")}>{esc(ttl)}</h2>')
    inner = f'''
      <div style="flex:1; padding:60px 48px; display:flex; flex-direction:column; justify-content:center; align-items:flex-end;">
        <div style="max-width:380px;">
          {head(left_label, "var(--coral)", left_title, "fadeInLeft", 0.15, 0.3)}
          <div style="display:flex; flex-direction:column; gap:14px;">{_points(left_points, "bad", 1.0)}</div>
        </div>
      </div>
      <div style="width:1px; background:var(--clay); align-self:center; height:60%;"></div>
      <div style="flex:1; padding:60px 72px 60px 48px; display:flex; flex-direction:column; justify-content:center;">
        {head(right_label, "var(--sage)", right_title, "fadeInRight", 0.4, 0.55)}
        <div style="display:flex; flex-direction:column; gap:14px;">{_points(right_points, "good", 1.2)}</div>
      </div>'''
    return "slide-content", _frame(inner, "full", "flex-direction:row;")


def divider(heading, text):
    """Dark charcoal section break."""
    return "slide-divider", _frame(f"<h2>{esc(heading)}</h2><p>{esc(text)}</p>", "centered")


def content(label, heading, desc="", body_html="", packed=False):
    """Standard content slide: terra step-label, h2, optional intro paragraph, then body blocks."""
    p = f'<p {anim("fadeInUp", 0.3)}>{esc(desc)}</p>' if desc else ""
    inner = (f'<div class="step-label anim" style="animation:fadeInUp 0.5s ease 0.1s forwards;">{esc(label)}</div>'
             f'<h2 class="anim" style="animation:fadeInUp 0.5s ease 0.2s forwards;">{esc(heading)}</h2>{p}{body_html}')
    return "slide-content", _frame(inner, "packed" if packed else "")


def cta(heading, sub, link_title="", link_url="", link_host=""):
    """Centered call-to-action (e.g. Demo / Q&A) with optional glass link card."""
    link = ""
    if link_url:
        link = f'''
      <a href="{html.escape(link_url)}" target="_blank" {anim("fadeInUp", 0.5, cls="glass", style="display:inline-flex; align-items:center; gap:14px; padding:18px 28px; text-decoration:none; cursor:pointer; border:1px solid rgba(194,112,78,0.2); transition:all 0.2s;")}>
        <div style="width:40px; height:40px; border-radius:12px; background:rgba(194,112,78,0.08); display:flex; align-items:center; justify-content:center; flex-shrink:0;">{icon("external")}</div>
        <div style="text-align:left;">
          <div style="font-size:16px; font-weight:700; color:var(--charcoal);">{esc(link_title)}</div>
          <div style="font-size:12px; color:var(--warm-light);">{esc(link_host)}</div>
        </div>
        {icon("chevron", 18, style="margin-left:8px; flex-shrink:0;")}
      </a>'''
    inner = f'''
      <div {anim("fadeInUp", 0.2)}>{icon("play", 48, style="margin-bottom:20px;")}</div>
      <h1 {anim("fadeInUp", 0.3, style="font-size:56px; font-weight:700; color:var(--charcoal); letter-spacing:-1.5px; margin:0;")}>{esc(heading)}</h1>
      <p {anim("fadeInUp", 0.45, style="font-size:28px; font-weight:500; color:var(--warm); margin:4px 0 36px;")}>{esc(sub)}</p>{link}'''
    return "slide-content", _frame(inner, "centered", "justify-content:center; align-items:center; text-align:center;")


def closing():
    """Final slide: large Apple logo on white."""
    inner = (f'<svg xmlns="http://www.w3.org/2000/svg" width="180" height="222" viewBox="0 0 496.255 608.728" '
             f'fill="#1D1D1F"><path d="{APPLE_D}"></path></svg>')
    return "", _frame(inner, "centered", "justify-content:center; align-items:center;"), "background:white;"


# ------------------------------------------------------------- body blocks

def glass_cards(items, cols=2, start=0.45, step=0.15):
    """items: dict(title, text, icon, color, tags=[...], wide=False). Cards rise in sequentially."""
    out = ""
    for i, it in enumerate(items):
        color, bg = COLORS[it.get("color", "terra")]
        tags = "".join(f'<span style="font-size:9px; padding:3px 10px; border-radius:10px; background:{bg}; color:{color}; font-weight:600;">{esc(t)}</span>'
                       for t in it.get("tags", []))
        tags = f'<div style="display:flex; gap:6px; margin-top:8px;">{tags}</div>' if tags else ""
        wide = "grid-column: 1 / -1;" if it.get("wide") else ""
        out += f'''
      <div {anim("fadeInUp", round(start + step * i, 2), cls="glass", style=f"padding:20px 24px; display:flex; align-items:flex-start; gap:16px; {wide}")}>
        <div style="width:40px; height:40px; border-radius:12px; background:{bg}; display:flex; align-items:center; justify-content:center; flex-shrink:0;">{icon(it.get("icon", "check"), 20, color)}</div>
        <div style="flex:1; min-width:0;">
          <div style="font-size:14px; font-weight:700; color:var(--charcoal); margin-bottom:4px;">{esc(it["title"])}</div>
          <div style="font-size:12px; color:var(--warm); line-height:1.5;">{esc(it["text"])}</div>{tags}
        </div>
      </div>'''
    return f'<div style="display:grid; grid-template-columns:repeat({cols},1fr); gap:20px; width:100%; margin-top:8px;">{out}\n    </div>'


def stats(items, start=0.4):
    """items: [(number, label)]."""
    out = "".join(f'<div {anim("fadeInUp", round(start + 0.1 * i, 2))}><div class="stat-num">{esc(n)}</div><div class="stat-label">{esc(l)}</div></div>'
                  for i, (n, l) in enumerate(items))
    return f'<div class="stats">{out}</div>'


def tiles(items, cols=5, start=0.4, step=0.1):
    """items: [(svg_html, label)] small glass tiles (e.g. chart-type thumbnails), staggered."""
    out = "".join(f'<div {anim("fadeInUp", round(start + step * i, 2), 0.45, cls="glass", style="padding:16px; text-align:center;")}>{svg}'
                  f'<div style="font-size:10px; color:var(--warm); font-weight:500; margin-top:4px;">{esc(l)}</div></div>'
                  for i, (svg, l) in enumerate(items))
    return f'<div style="display:grid; grid-template-columns:repeat({cols},1fr); gap:14px; width:100%;">{out}</div>'


def plain_cards(items, cols=3, start=0.4):
    """items: dict(title, text, accent='' | accent | sage-accent | blue-accent | plum-accent | amber-accent | filled | sage-filled | blue-filled)."""
    out = "".join(f'<div {anim("fadeInUp", round(start + 0.12 * i, 2), cls="card " + it.get("accent", ""))}><h3>{esc(it["title"])}</h3><p>{esc(it["text"])}</p></div>'
                  for i, it in enumerate(items))
    return f'<div class="cards" style="grid-template-columns:repeat({cols},1fr);">{out}</div>'


def feat_list(items, start=0.4):
    out = "".join(f'<li {anim("fadeInUp", round(start + 0.1 * i, 2))}><span class="feat-check">✓</span><span>{esc(t)}</span></li>' for i, t in enumerate(items))
    return f'<ul class="feat-list" style="width:100%;">{out}</ul>'


def callout(heading, text, terra=False, delay=0.6):
    return f'<div {anim("fadeInUp", delay, cls="hl-box" + (" terra" if terra else ""))}><h4>{esc(heading)}</h4><p>{esc(text)}</p></div>'


def two_col(left_html, right_html, delay_l=0.3, delay_r=0.5):
    return (f'<div class="two-col" style="margin-top:12px;"><div {anim("fadeInLeft", delay_l)}>{left_html}</div>'
            f'<div {anim("fadeInRight", delay_r)}>{right_html}</div></div>')


def chips(*names):
    return "".join(f'<code class="chip">{esc(n)}</code> ' for n in names)


def seq(inner_html, at_ms, style=""):
    """Wrap content so it fades in `at_ms` after the slide opens (chat bubbles, staged reveals)."""
    return f'<div class="seq" data-at="{int(at_ms)}" style="{style}">{inner_html}</div>'


def pipeline(steps, legend=("Code", "LLM")):
    """Animated step diagram. steps: [(name, subtitle, kind)] with kind 'code' (sage) or 'llm' (terra).

    Up to 10 steps; 5 per row, the second row runs right-to-left via an animated U-turn. On entering
    the slide the steps light up one by one (gray -> pulsing -> settled) and the connectors flow.
    """
    if not 1 <= len(steps) <= 10:
        raise ValueError("pipeline supports 1-10 steps")
    style = {"code": ("var(--sage-light)", "#c5d4be", "var(--sage)", "#aaa"),
             "llm": ("#FFF0E8", "var(--terra-light)", "var(--terra)", "var(--terra-light)")}
    W, H, GAP = 160, 50, 40
    boxes, arrows = "", ""

    def pos(i):
        return (i * (W + GAP), 10) if i < 5 else ((9 - i) * (W + GAP), 105)

    def dots(cx, cy, n, dx, delay):
        return "".join(f'<circle cx="{cx + dx * k}" cy="{cy}" r="2.2" fill="var(--terra-light)"><animate attributeName="opacity" '
                       f'values="0.15;1;0.15" dur="1s" begin="{round(delay * k, 2)}s" repeatCount="indefinite"></animate></circle>' for k in range(n))

    for i, (name, sub, kind) in enumerate(steps):
        x, y = pos(i)
        fill, stroke, tcol, kcol = style[kind]
        cx = x + W / 2
        boxes += f'''
        <g class="pipe-step" data-step="{i}" opacity="1">
          <rect x="{x}" y="{y}" width="{W}" height="{H}" rx="10" fill="{fill}" stroke="{stroke}" stroke-width="1.5"></rect>
          <text x="{cx}" y="{y + 22}" text-anchor="middle" font-size="10" font-weight="600" fill="{tcol}">{i + 1}. {esc(name)}</text>
          <text x="{cx}" y="{y + 35}" text-anchor="middle" font-size="8" fill="{tcol}">{esc(sub)}</text>
          <text x="{cx}" y="{y + 45}" text-anchor="middle" font-size="7" fill="{kcol}">{"LLM" if kind == "llm" else "CODE"}</text>
        </g>'''
        if i == len(steps) - 1:
            continue
        a = f'<g class="pipe-arrow" data-after="{i + 1}" opacity="0">'
        if i == 4:  # U-turn from end of row 1 to start of row 2
            a += ('<path d="M960 35 Q985 35 985 60 L985 110 Q985 130 965 130" stroke="var(--terra-light)" stroke-width="2" fill="none" '
                  'stroke-dasharray="6 5" stroke-linecap="round"><animate attributeName="stroke-dashoffset" from="0" to="-22" dur="0.8s" repeatCount="indefinite"></animate></path>')
        elif i < 4:
            a += dots(x + W + 12, 35, 3, 10, 0.2)
        else:
            a += dots(x - 12, 130, 3, -10, 0.2)
        arrows += a + "</g>"

    rows_h = 190 if len(steps) > 5 else 80
    leg_y = rows_h - 18
    legend_svg = (f'<rect x="880" y="{leg_y}" width="10" height="10" rx="2" fill="var(--sage-light)" stroke="#c5d4be"></rect>'
                  f'<text x="896" y="{leg_y + 9}" font-size="9" fill="var(--warm)">{esc(legend[0])}</text>'
                  f'<rect x="940" y="{leg_y}" width="10" height="10" rx="2" fill="#FFF0E8" stroke="var(--terra-light)"></rect>'
                  f'<text x="956" y="{leg_y + 9}" font-size="9" fill="var(--warm)">{esc(legend[1])}</text>')
    return f'<div style="width:100%;"><svg width="100%" viewBox="-4 0 1000 {rows_h}" style="margin-bottom:10px;">{arrows}{boxes}{legend_svg}</svg></div>'


# ------------------------------------------------------------------- build

def _wrap(n, spec):
    cls, inner, *rest = spec
    classes = " ".join(c for c in ("slide", cls, "active" if n == 1 else "") if c)
    style = f' style="{rest[0]}"' if rest else ""
    return f'  <div class="{classes}" data-slide="{n}"{style}>\n    {inner}\n  </div>'


def verify(doc, n_slides):
    errs = []
    if re.search(r"\{\{[A-Z_]+\}\}", doc):
        errs.append("unreplaced {{PLACEHOLDER}}")
    if len(re.findall(r'<div class="slide[ "][^>]*data-slide=', doc)) != n_slides:
        errs.append("slide count mismatch")
    if len(re.findall(r'class="slide [^"]*\bactive\b', doc)) != 1:
        errs.append("need exactly one active slide")
    if re.search(r"<link\b|<script[^>]+src=|@import|url\(\s*['\"]?https?:", doc):
        errs.append("external resource reference (deck must be self-contained)")
    return errs


def build(title_text, slides, out):
    """Fill template.html with slides, verify, and write to `out`. Raises if verification fails."""
    with open(os.path.join(HERE, "template.html"), encoding="utf-8") as f:
        tpl = f.read()
    body = "\n\n".join(_wrap(i + 1, s) for i, s in enumerate(slides))
    doc = tpl.replace("{{TITLE}}", html.escape(title_text)).replace("{{SLIDES}}", body)
    errs = verify(doc, len(slides))
    if errs:
        raise ValueError("deck failed verification: " + "; ".join(errs))
    out = os.path.expanduser(out)
    os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
    with open(out, "w", encoding="utf-8") as f:
        f.write(doc)
    print(f"wrote {out} ({len(slides)} slides)")
    return out
