# G02-T3: Settings façade with WASM-safe persistence

- **Class:** standard
- **Status:** ready
- **Depends:** — (independent; pairs naturally with G03-T2
  `ApplicationInfo`)
- **Issues:**
  [I-0003](../../issues/open/I-0003-settings-location-breaks-wasm.md)
- **Anchors:**
  [findings-wasm-web.md §3](../../issues/audit-2026-07/findings-wasm-web.md),
  [architecture-target.md](../../design/architecture-target.md)

## Goal

Replace the 11 scattered `Settings { location: … }` blocks (each marked
`// Gives WASM error on run`) with **one** settings façade that persists
correctly on desktop **and** in the browser, so
theme/geometry/preferences survive a WASM page reload and no site
throws.

## Scope

- **In:** a single settings singleton with typed properties (`theme`,
  `loggingLevel`, `paramNameFormat`, window `x/y/width/height`, and the
  other persisted values); target-aware backend; migrate all 11 sites to
  bind to it; delete the WASM-error comments.
- **Out:** the `ApplicationInfo`/namespace injection (G03-T2 —
  coordinate on the settings key namespace); the actual value semantics
  (keep current defaults).

## Plan

1. Create `Gui/Globals/AppSettings.qml` (singleton) exposing the
   persisted values as typed properties.
2. **Target-aware storage inside the façade:**
   - Detect WASM with `Qt.platform.pluginName === "wasm"` (already used
     in `Sizes.qml:22`).
   - **Desktop:** a `Settings{}` (or QSettings via the backend) with the
     existing file location.
   - **WASM:** a `Settings{}` **without** a file `location:` —
     default-constructed settings persist through Qt's browser storage
     backend. Verify the exact mechanism (localStorage vs IndexedDB, any
     async-readiness caveat) on the pinned Qt as part of this task and
     note it in the PR. The key rule: never pass a file `location` on
     WASM.
   - Keep the settings _category/namespace_ consistent with G03-T2's
     injected app name.
3. Migrate every site (`ApplicationWindow.qml:116`, `Colors.qml:142`,
   `Vars.qml:95/101`, `PreferencesDialog.qml:361/368/374/380/386`,
   `ProjectDescriptionDialog.qml:127`) to bind to `AppSettings.<prop>`;
   remove the raw `Settings{}` blocks and the `// Gives WASM error`
   comments.
4. Verify persistence round-trips: set theme → reload → theme retained,
   on desktop and WASM.

## Deliverables

- `AppSettings` singleton; all 11 sites migrated; no raw
  `Settings{location}` in screens.

## Acceptance gates

- `grep -R "Gives WASM error on run" src/` → nothing;
  `grep -R "Settings {" src/` → only the façade.
- WASM build starts with no settings error; theme selection persists
  across a page reload (browser storage backend — mechanism verified and
  noted).
- Desktop persistence (theme, geometry, preferences) unchanged.

## Test brief

Round-trip test per target: change theme + a preference, reload, assert
retained. Assert no runtime error on WASM startup.

## Review focus

No file `location` on the WASM path; single source of the settings
namespace (coordinate with G03-T2); geometry aliases still bind two-way.

## Definition of done

I-0003 acceptance met; `status.yml` G02-T3 → done.
