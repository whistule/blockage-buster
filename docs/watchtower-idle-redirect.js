/*
 * Watchtower idle redirect
 * ------------------------
 * After 30 seconds of no user interaction, return the view to the Blockage
 * Buster board — so the board stays front-of-mind across the Watchtower suite.
 *
 * This belongs in the OTHER Watchtower apps (RegOPS, etc.), not in Blockage
 * Buster itself — Blockage Buster is the destination. It is, however, safe to
 * include everywhere: it no-ops when the page is already the board.
 *
 * How to use:
 *   1. Set BLOCKAGE_BUSTER_URL below to the Blockage Buster app URL.
 *   2. Include it in each app, e.g. just before </body>:
 *        <script src="/path/to/watchtower-idle-redirect.js"></script>
 *      or paste the IIFE inline.
 *
 * Notes:
 *   - The Watchtower shell opens apps in an iframe, so this navigates the
 *     app's own frame (the shell chrome stays). To replace the whole window
 *     instead, swap `location` for `window.top.location` in go() (only works
 *     when the app and shell are same-origin).
 *   - The countdown pauses while the tab/app is hidden and restarts when it
 *     becomes visible again, so a backgrounded app doesn't redirect unseen.
 */
(function () {
  var BLOCKAGE_BUSTER_URL = 'https://REPLACE-ME';  // <-- set to the Blockage Buster app URL
  var IDLE_MS = 30000;                              // 30 seconds

  // Already on the board? Do nothing.
  if (location.href.indexOf(BLOCKAGE_BUSTER_URL) === 0) return;

  var timer;
  function go() { location.href = BLOCKAGE_BUSTER_URL; }
  function reset() { clearTimeout(timer); timer = setTimeout(go, IDLE_MS); }

  ['mousemove', 'mousedown', 'keydown', 'touchstart', 'scroll', 'click', 'wheel'].forEach(function (ev) {
    window.addEventListener(ev, reset, { passive: true });
  });
  document.addEventListener('visibilitychange', function () {
    if (document.visibilityState === 'visible') reset(); else clearTimeout(timer);
  });
  reset();
})();
