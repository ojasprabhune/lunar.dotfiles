// js/markdown.js
// Loads a Markdown file and renders it into a container using marked.js.
//
// Usage:
//   MarkdownLoader.render('../posts/my-post.md', '#container', '#titleEl')
//
// ── Local development note ──────────────────────────────────────────────────
// Firefox blocks cross-directory file:// requests (fetch AND XHR), so posts
// won't load when you open HTML files directly. The fix is a one-liner:
//
//   cd /path/to/dotfolders
//   python3 -m http.server 8080
//
// Then open http://localhost:8080 instead of file://...
// Chrome is more permissive — XHR from file:// often works there.
// On GitHub Pages everything works without any server.
// ────────────────────────────────────────────────────────────────────────────

window.MarkdownLoader = (function () {

  function render(url, containerSelector, titleSelector) {
    var container = document.querySelector(containerSelector);
    if (!container) return;
    container.innerHTML = '<p class="loading">Loading…</p>';

    // XHR works for file:// in Chrome (status === 0 means local-file success).
    // Falls back to a helpful error in Firefox where file:// is blocked.
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);

    xhr.onreadystatechange = function () {
      if (xhr.readyState !== 4) return;
      var ok = xhr.status === 200 || (xhr.status === 0 && xhr.responseText.length > 0);
      if (ok) {
        renderMarkdown(xhr.responseText, container, titleSelector);
      } else {
        showServerNeededError(container, xhr.status);
      }
    };

    xhr.onerror = function () { showServerNeededError(container, 0); };

    try {
      xhr.send();
    } catch (e) {
      showServerNeededError(container, 0);
    }
  }

  function renderMarkdown(text, container, titleSelector) {
    container.innerHTML = window.marked.parse(text);
    container.classList.add('prose');

    if (titleSelector) {
      var h1 = container.querySelector('h1');
      var titleEl = document.querySelector(titleSelector);
      if (h1 && titleEl) {
        titleEl.textContent = h1.textContent;
        document.title = h1.textContent + ' — ojasprabhune';
      }
    }

    // Syntax-highlight every fenced code block (requires highlight.js in the page).
    if (window.hljs) {
      container.querySelectorAll('pre code').forEach(function (el) {
        window.hljs.highlightElement(el);
      });
    }

    // Wire up scroll-reveal on rendered elements.
    container.querySelectorAll('h2, h3, p, ul, ol, blockquote, pre, table').forEach(function (el) {
      el.classList.add('reveal');
    });
    if (window.ScrollReveal) window.ScrollReveal.init();
  }

  function showServerNeededError(container, status) {
    container.innerHTML =
      '<div class="error" style="max-width:56ch;line-height:1.7">' +
        '<strong>Posts need a local server to load.</strong><br><br>' +
        'Firefox (and some Chrome settings) block cross-directory file:// requests. ' +
        'Fix it with one command — open a terminal, <code>cd</code> to your ' +
        '<strong>dotfolders</strong> folder, and run:<br><br>' +
        '<code style="display:block;padding:.6em .9em;border-radius:6px;' +
             'background:var(--color-accent-soft);font-family:var(--font-mono);' +
             'font-size:.85rem;margin:.5rem 0 1rem">python3 -m http.server 8080</code>' +
        'Then open <strong>http://localhost:8080</strong> in your browser ' +
        'instead of opening the HTML files directly. ' +
        'Everything works normally once deployed to GitHub Pages.' +
      '</div>';
  }

  return { render: render };
})();
