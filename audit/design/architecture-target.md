# Target architecture — the hardened GUI base

Where the base should land after Phase I–II, so `edi` can build a
desktop and a WASM app on it. This is the "north star" the milestones
move toward; it is intentionally incremental from today's tree (the
visual design system is kept).

## Layering (keep, clarify, enforce)

```
EasyApplication.Gui
├── Style        singletons: Colors, Sizes, Fonts, Times        (design tokens — no logic)
├── Globals      Vars (app-agnostic runtime flags), AppSettings, ApplicationInfo   (NEW seams)
├── Animations   ThemeChange, TranslationChange, ColorReset
├── Elements     primitives: Button, Label, TextField, ComboBox, …   (one type/file, T.* based)
├── Components    composed: AppShell/ApplicationWindow, AppBar, ContentArea, SideBar, TableView, …
├── Charts        façade: Chart1D, Chart2DHeatmap, Chart3DSurface   (native backend, NO WebEngine)
└── Logic (js)   pure helpers: Translate, Utils, ProjectConfig
```

Rules (enforced by CI grep + qmllint, documented in
[modern-qt-guidelines.md](modern-qt-guidelines.md)):

- **Elements** are primitives (extend `QtQuick.Templates`), no app
  knowledge, no cross-Element composition beyond Style/Animations.
- **Components** compose Elements into reusable app furniture. The
  window apps use is `Components.ApplicationWindow` (the base primitive
  is renamed `ApplicationWindowBase`, I-0028).
- **No product literals, no named app pages** anywhere in `Gui`. App
  specifics enter only through the injected seams below.

## The three injection seams (this is what makes it generic)

Everything app-specific that is _currently baked in_ becomes
host-injected:

1. **`ApplicationInfo`** — organization, applicationName, version,
   settings namespace (optionally a changelog URL / update service). Set
   once in the host `main` (Python or C++). Logging and settings derive
   identity from it. Replaces the hard-coded `EasyDiffraction`
   (I-0006/I-0022).
2. **Page model** — the app supplies a list
   `[{ title, icon, source|component, enabled }]`; the app bar and
   content area render from it. Replaces `Vars.AppBarIndexEnum`
   (I-0006).
3. **Optional services** — `updateService` (I-0007), and any other
   platform/host capability the app opts into. The library ships none by
   default.

## Platform-divergent façades (write app code once)

For anything that differs between desktop and WASM, a small façade with
a fixed property API and a target-aware backend (detect
`Qt.platform.pluginName === "wasm"`):

| Façade                                | Desktop backend               | WASM backend                                     | Issue  |
| ------------------------------------- | ----------------------------- | ------------------------------------------------ | ------ |
| `AppSettings`                         | `QSettings`/`Settings` (file) | `Settings` → `localStorage` (no file `location`) | I-0003 |
| `Charts.Chart*`                       | QtGraphs/Qt Charts            | same (native, GPU) — **no WebEngine**            | I-0002 |
| `updateService` (opt-in)              | QtIFW / host                  | absent (web self-updates via redeploy)           | I-0007 |
| file open/save, clipboard (as needed) | native dialogs                | browser file API / no-op                         | future |

The point: platform `#ifdef`-style logic lives in **one** file per
capability, not scattered (today the `Settings` bug is copy-pasted 11×).

## Build & distribution (dual, one source tree)

```
        src/EasyApplication/Gui/**.qml   (ONE source of truth)
                 │
     ┌───────────┴────────────┐
     ▼                          ▼
 PySide6 path              CMake path (qt_add_qml_module)
 (interpreted QML,         (compiled QML via qmlsc,
  desktop-Python)           generated qmldir+resources)
     │                          │
     ▼                    ┌─────┴─────┐
 pip wheel               ▼            ▼
 (easydiffraction        desktop     WASM
  desktop app)           C++ app     web app
```

- **CMake `qt_add_qml_module` is the source of truth** for module
  identity (URI == import path, I-0009), resources (generated, so no
  I-0001 drift), and compiled QML.
- **PySide6 consumes the same raw `.qml`** for the desktop-Python app
  (kept working throughout).
- Distribution: a Python wheel for the PySide desktop path; a CMake
  package (`find_package` / `add_subdirectory`) for the C++/WASM path.
  (Ratify the exact split in
  [decisions-to-confirm.md](decisions-to-confirm.md) §B.)

## Quality gates (the product is gated, not just the shell)

- `qmllint` + `qmlformat --check` over every module (pre-commit + CI).
- Qt Quick Test **smoke-load** (every Element/Component instantiates
  cleanly) + interactive units, headless in CI on desktop and WASM.
- CI grep gates: no `easydiffraction`, no `QtQuick.Controls.impl`
  outside wrappers, no `Settings{location}` in screens, no dangling
  manifest paths, no spaces in `src/` filenames.
- A component **gallery** example that renders everything (light+dark) —
  living docs + visual smoke.

## edi consumption (the payoff)

`enhantica/edi` (product monorepo) builds:

- **`edi` desktop app** — QML/PySide, declares its pages +
  `ApplicationInfo`, styles via `Style` tokens, uses
  `Components`/`Elements`/`Charts` façades. Ready after M03
  (decoupled) + M04 (gated).
- **`edi` web app** — the same QML compiled for WASM via CMake. Ready
  after M01 + M02 (renders on WASM).
- **`edi` shared session layer** — theme/settings/page-model/undo state,
  injected through the seams above; a single place both surfaces share.
  Formalised in M09.
