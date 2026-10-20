// Paste into the page (Chrome DevTools evaluate_script / browser console) with the deck open at ~16:9.
// Slide frames are overflow:hidden and vertically centered, so too-long content is CLIPPED SILENTLY on
// both top and bottom (scrollHeight can't see it). This compares every element's bounding box to its
// frame instead. Returns one row per slide; fix any with clipped:true (shorten text, fewer cards, or
// use content(..., packed=True)). `over` = pixels past the frame edge.
(() => [...document.querySelectorAll('.slide')].map(s => {
  const was = s.style.cssText;
  s.style.visibility = 'visible'; s.style.opacity = '1';
  const f = s.querySelector('.slide-frame').getBoundingClientRect();
  let top = Infinity, bottom = -Infinity, left = Infinity, right = -Infinity;
  s.querySelectorAll('.slide-frame *').forEach(e => {
    if (e.closest('svg') && e.tagName !== 'svg') return;
    const r = e.getBoundingClientRect();
    if (!r.width && !r.height) return;
    top = Math.min(top, r.top); bottom = Math.max(bottom, r.bottom);
    left = Math.min(left, r.left); right = Math.max(right, r.right);
  });
  s.style.cssText = was;
  const tol = 1;
  return {
    slide: s.dataset.slide,
    clipped: top < f.top - tol || bottom > f.bottom + tol || left < f.left - tol || right > f.right + tol,
    over: {top: Math.round(f.top - top), bottom: Math.round(bottom - f.bottom)},
  };
}))();
