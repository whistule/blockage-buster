# Blockage Buster — working notes for Claude

Single-file HTML Kanban board (`blockage-buster.html`), backed by Supabase,
deployed via Docker to a Raspberry Pi. Pushing to `main` triggers a GitHub
Actions build; Watchtower auto-updates the Pi.

## Workflow: preview-first (default)

Before anything deploys, show the user a preview and wait for their approval —
**do not merge to `main` until they say go.**

- Render the change from mock data (Supabase is network-blocked locally) and
  present it so the user can view it, ideally in a separate window/tab.
- Commit + push to the feature branch freely (that does NOT deploy). Only the
  merge to `main` triggers the build + Pi update.
- Merge to `main` only after the user approves the preview.

## Preview harness

Playwright + a mock-injected copy of the app live in the session scratchpad
(`genws.js` builds `preview-ws2.html` by injecting an ASCII-only mock
`window.supabase`). Use it to screenshot real code before shipping.

## Versioning

`VERSION` file, scheme `v2.4.x` (2nd digit = session, patch = iteration).
Bump it every change.
