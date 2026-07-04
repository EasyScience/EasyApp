# I-0003: `Settings { location: … }` throws on WASM at 11 sites → persistence broken in the browser

- **Status:** open
- **Priority:** Highest
- **Area:** wasm-web
- **Targets:** web
- **Found:** 2026-07 GUI base audit
- **Related:** I-0002; milestone G02; evidence
  [findings-wasm-web.md](../audit-2026-07/findings-wasm-web.md)

## Problem

Persistent settings use `QtCore`'s `Settings` type with an explicit
`location:` (a file path). On the WASM platform there is no writable
local filesystem in the usual sense, and setting `location` to a file
URL raises at runtime — the code itself says so, at every site, via the
copy-pasted comment `// Gives WASM error on run`:

```
Gui/Components/ApplicationWindow.qml:116     location: EaGlobals.Vars.settingsFile // Gives WASM error on run
Gui/Style/Colors.qml:142                     location: EaGlobals.Vars.settingsFile // Gives WASM error on run
Gui/Globals/Vars.qml:95, :101                location: settingsFile               // Gives WASM error on run
Gui/Components/PreferencesDialog.qml:361,368,374,380,386   … (5 sites)
Gui/Components/ProjectDescriptionDialog.qml:127            …
```

(11 live occurrences; one more is commented out in `Vars.qml:89`.) These
`Settings` blocks store the theme, the window geometry, the logging
level, the parameter-name format, and preferences.

## Impact

- On the web app, **either the app throws on startup** (if the
  `Settings` element is created eagerly) **or all persistence silently
  no-ops** — the theme resets every reload, window state is lost,
  preferences don't stick. A known-broken path shipped with a comment
  instead of a fix.
- The pattern is copy-pasted, so there is no single place to fix it —
  every consumer screen that wants to persist a value re-introduces the
  bug.

## Suggested fix

1. **Introduce one settings façade** instead of scattering `Settings{}`
   blocks. Add a singleton (e.g. `Gui/Globals/AppSettings.qml`, or a
   Python/C++-backed `QSettings` object exposed to QML) with typed
   properties (`theme`, `loggingLevel`, `paramNameFormat`, window
   geometry…). Screens bind to `AppSettings.theme`, never to a raw
   `Settings{}`.
2. **Make the storage backend target-aware inside the façade:**
   - Desktop: `QSettings`/`Settings` with the existing file location.
   - WASM: use a backend that works in the browser. With PySide the web
     path is not used, so the façade only needs a no-op/in-memory
     fallback there; for the **C++/WASM** build, use Qt's built-in WASM
     settings persistence by **omitting** the file `location:`
     (default-constructed settings persist through Qt's browser storage
     backend — verify the exact mechanism (localStorage vs IndexedDB,
     and any async-readiness caveat) against the pinned Qt version
     during implementation; this is an acceptance item, not an
     assumption).
   - The key rule either way: **never pass a file `location:` on WASM.**
     Detect `Qt.platform.pluginName === "wasm"` (already used in
     `Sizes.qml:22`) and either omit `location` or switch to the
     browser-backed store.
3. Replace all 11 `Settings{}` sites with bindings to the façade; delete
   the `// Gives WASM error on run` comments as they are fixed.

## Acceptance criteria

- The WASM build starts with no settings-related runtime error, and the
  theme selection persists across a page reload (through the browser
  storage backend — mechanism verified and noted on the pinned Qt).
- `grep -R "Gives WASM error on run" src/` returns nothing.
- There is exactly one settings storage definition (the façade); no
  screen instantiates a raw `Settings{}` with a file `location`.
- Desktop persistence (theme, geometry, preferences) still works
  unchanged.
