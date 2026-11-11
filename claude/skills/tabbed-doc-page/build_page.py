"""Assemble a tabbed-doc-page from a list of sections, and verify it before writing.

Usage (from a throwaway script that holds the page's own content):

    import sys, os
    sys.path.insert(0, os.path.expanduser('~/.claude/skills/tabbed-doc-page'))
    from build_page import build_page, code, table, chips, banner, INFO_ICON

    sections = [
        dict(id='overview', label='Overview', title='Overview', intro='One sentence.', body='<div class="card">…</div>'),
        dict(id='details', label='Details', dot='live', title='Details', intro='…', body=table(['A', 'B'], [['1', '2']])),
    ]
    build_page(sections, title='Page title', badge='Product', h1='Heading', subtitle='Summary.',
               footer='Product — Page · Generated: Month YYYY', out_path='~/Downloads/slug.html')

Each section dict: `id`, `label` (tab text), `title` (h2, also used in prev/next links), `intro`
(section-header paragraph, may contain HTML), `body` (HTML built from the classes in reference.md),
and optional `dot` ('live' green / 'pending' orange). Order matters: the first section is active,
and the prev/next links follow the list. The template's <style> and <script> are never touched.
"""

import html
import os
import re

TEMPLATE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'template.html')

_SVG = ('<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
        'stroke-linecap="round" stroke-linejoin="round">{}</svg>')
CHEVRON_LEFT = _SVG.format('<polyline points="15 18 9 12 15 6"/>')
CHEVRON_RIGHT = _SVG.format('<polyline points="9 18 15 12 9 6"/>')
INFO_ICON = ('<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" '
             'stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/>'
             '<line x1="12" y1="8" x2="12.01" y2="8"/></svg>')


def code(text):
    """Inline <code> chip with the text escaped."""
    return f'<code>{html.escape(text)}</code>'


def table(head, rows, keyed=True):
    """table.doc-table; cells are raw HTML. `keyed` keeps a short first column on one line."""
    header = ''.join(f'<th>{cell}</th>' for cell in head)
    body = ''.join('<tr>' + ''.join(f'<td>{cell}</td>' for cell in row) + '</tr>' for row in rows)
    return (f'<table class="doc-table{" keyed" if keyed else ""}"><thead><tr>{header}</tr></thead>'
            f'<tbody>{body}</tbody></table>')


def chips(names, accent='neutral'):
    """A .tag-row of escaped .tag chips."""
    return ('<div class="tag-row">'
            + ''.join(f'<span class="tag {accent}">{html.escape(name)}</span>' for name in names)
            + '</div>')


def banner(text, kind='info'):
    """.banner callout (info warn success note danger); text is raw HTML."""
    return f'<div class="banner {kind}">{INFO_ICON} {text}</div>'


def _section_nav(sections, index):
    nav = '<div class="section-nav">'
    if index > 0:
        prev = sections[index - 1]
        nav += (f'<a class="prev" data-nav="{prev["id"]}"><span class="nav-arrow">{CHEVRON_LEFT}</span>'
                f'<span class="nav-text"><span class="nav-label">Previous</span>'
                f'<span class="nav-title">{prev["title"]}</span></span></a>')
    if index < len(sections) - 1:
        following = sections[index + 1]
        nav += (f'<a class="next" data-nav="{following["id"]}"><span class="nav-arrow">{CHEVRON_RIGHT}</span>'
                f'<span class="nav-text"><span class="nav-label">Next</span>'
                f'<span class="nav-title">{following["title"]}</span></span></a>')
    return nav + '</div>'


def verify(page):
    """The SKILL.md delivery checks. Raises AssertionError naming the first failure."""
    tab_ids = re.findall(r'class="nav-tab[^"]*" data-section="([^"]+)"', page)
    section_ids = re.findall(r'<div id="([^"]+)" class="section', page)
    nav_targets = set(re.findall(r'data-nav(?:igate)?="([^"]+)"', page))
    assert tab_ids == section_ids, f'tabs {tab_ids} != sections {section_ids}'
    assert len(set(section_ids)) == len(section_ids), f'duplicate section ids: {section_ids}'
    assert nav_targets <= set(section_ids), f'links to missing sections: {nav_targets - set(section_ids)}'
    assert page.count('class="nav-tab active"') == 1, 'expected exactly one active tab'
    assert page.count('class="section active"') == 1, 'expected exactly one active section'
    assert '{{' not in page, 'leftover {{PLACEHOLDER}}'
    assert not re.search(r'<(link|script)[^>]+(href|src)="https?://', page), 'external resource link'


def build_page(sections, *, title, badge, h1, subtitle, footer, out_path):
    """Fill the template's 7 placeholders, verify, write to out_path, and return the path."""
    template = open(TEMPLATE, encoding='utf-8').read()
    tabs, panels = [], []
    for index, section in enumerate(sections):
        active = ' active' if index == 0 else ''
        dot = f' <span class="tab-dot {section["dot"]}"></span>' if section.get('dot') else ''
        tabs.append(f'<button class="nav-tab{active}" data-section="{section["id"]}">{section["label"]}{dot}</button>')
        panels.append(f'<div id="{section["id"]}" class="section{active}"><div class="section-header">'
                      f'<h2>{section["title"]}</h2><p>{section["intro"]}</p></div>{section["body"]}'
                      f'{_section_nav(sections, index)}</div>')

    page = (template.replace('{{TITLE}}', title)
            .replace('{{BADGE}}', badge)
            .replace('{{H1}}', h1)
            .replace('{{SUBTITLE}}', subtitle)
            .replace('{{NAV_TABS}}', '\n'.join(tabs))
            .replace('{{SECTIONS}}', '\n'.join(panels))
            .replace('{{FOOTER}}', footer))
    verify(page)

    path = os.path.expanduser(out_path)
    with open(path, 'w', encoding='utf-8') as out:
        out.write(page)
    return path
