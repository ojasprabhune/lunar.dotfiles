// js/theme.js
// Reads window.themeConfig, merges global + page override + optional dark mode,
// then writes everything as CSS custom properties on <html>.
// Runs in <head> to prevent FOUC.
//
// THEME SYNC ACROSS DIRECTORIES (file:// compatible)
// localStorage is scoped per origin. On file://, each subdirectory is a
// different origin, so pages/ can't read index.html's localStorage.
// Fix: when navigating, all internal links receive a ?theme= param.
// On load, that param is read, written to localStorage, then stripped from
// the URL. This keeps all pages in sync even on file://.

(function () {
  function toKebab(str) {
    return str.replace(/([A-Z])/g, '-$1').toLowerCase();
  }

  function mergeDeep(base, override) {
    if (!override) return Object.assign({}, base);
    const result = Object.assign({}, base);
    for (const key of Object.keys(override)) {
      if (
        typeof override[key] === 'object' &&
        override[key] !== null &&
        !Array.isArray(override[key]) &&
        typeof base[key] === 'object' &&
        base[key] !== null
      ) {
        result[key] = mergeDeep(base[key], override[key]);
      } else {
        result[key] = override[key];
      }
    }
    return result;
  }

  function getPageName() {
    const param = new URLSearchParams(window.location.search).get('page');
    if (param) return param;
    return document.documentElement.dataset.page || 'home';
  }

  // --- Theme persistence ---

  // Read ?theme= from the URL, write to localStorage, then strip the param.
  // Must run before isDark() so localStorage is up-to-date.
  function syncThemeFromUrl() {
    try {
      var urlParam = new URLSearchParams(window.location.search).get('theme');
      if (urlParam === 'dark' || urlParam === 'light') {
        localStorage.setItem('theme-mode', urlParam);
        var clean = new URL(window.location.href);
        clean.searchParams.delete('theme');
        history.replaceState(null, '', clean.toString());
      }
    } catch (e) { /* file:// replaceState may throw — harmless */ }
  }

  function isDark() {
    // Default is always light; only an explicit localStorage value triggers dark.
    return localStorage.getItem('theme-mode') === 'dark';
  }

  // Stamp every same-site .html link with ?theme=<current> so the theme
  // survives navigation across directories on file://.
  // On a real server (same origin) localStorage already handles this,
  // but the param is harmless and gets stripped on arrival.
  function propagateThemeToLinks() {
    try {
      var dark = isDark();
      document.querySelectorAll('a[href]').forEach(function (link) {
        var href = link.getAttribute('href');
        if (!href || href[0] === '#' || href.startsWith('javascript:') || href.startsWith('mailto:')) return;
        var url = new URL(href, window.location.href);
        // Only touch local .html links, not external sites
        if (url.origin !== window.location.origin && !window.location.href.startsWith('file://')) return;
        if (!url.pathname.endsWith('.html')) return;
        if (dark) {
          url.searchParams.set('theme', 'dark');
        } else {
          url.searchParams.delete('theme');
        }
        link.href = url.toString();
      });
    } catch (e) {}
  }

  // --- Apply config ---

  function applyConfig(cfg, dark) {
    const root = document.documentElement;
    const colors = dark && cfg.darkMode
      ? mergeDeep(cfg.colors, cfg.darkMode)
      : cfg.colors;

    for (const [k, v] of Object.entries(colors)) {
      root.style.setProperty(`--color-${toKebab(k)}`, v);
    }

    root.style.setProperty('--font-heading', cfg.fonts.heading);
    root.style.setProperty('--font-body',    cfg.fonts.body);
    root.style.setProperty('--font-mono',    cfg.fonts.mono);

    for (const [tag, styles] of Object.entries(cfg.headingStyles)) {
      for (const [prop, val] of Object.entries(styles)) {
        root.style.setProperty(`--${tag}-${toKebab(prop)}`, val);
      }
    }

    root.style.setProperty('--body-size',        cfg.bodyStyle.size);
    root.style.setProperty('--body-weight',      String(cfg.bodyStyle.weight));
    root.style.setProperty('--body-line-height', String(cfg.bodyStyle.lineHeight));

    root.dataset.theme = dark ? 'dark' : 'light';
  }

  function init() {
    const config = window.themeConfig;
    const page   = getPageName();
    const pageOverride = config.pages[page] || {};
    const merged = mergeDeep(config.global, pageOverride);
    applyConfig(merged, isDark());
  }

  // Exposed globally for toggle buttons on any page.
  window.toggleThemeMode = function () {
    const next = isDark() ? 'light' : 'dark';
    localStorage.setItem('theme-mode', next);
    init();
    // Re-stamp links with the new theme immediately
    propagateThemeToLinks();
  };

  // --- Boot sequence ---

  // 1. Sync theme from URL param (must happen before init to avoid FOUC)
  syncThemeFromUrl();
  // 2. Apply theme (runs in <head>, before body renders)
  init();
  // 3. Stamp links once DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', propagateThemeToLinks);
  } else {
    propagateThemeToLinks();
  }
})();
