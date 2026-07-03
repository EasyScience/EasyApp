# Findings — Build system & QML quality

Backs **I-0004, I-0009, I-0011, I-0013, I-0015, I-0020, I-0023, I-0024,
I-0027, I-0028**.

## Build system (classic-only)

- **No CMake anywhere** (`find . -name CMakeLists.txt` → ∅). Consumption
  is: PySide adds `src/EasyApplication` to the QML import path and finds
  hand-written `qmldir`; C++/WASM uses a QMake `.pro` + a
  hand-maintained `resources.qrc` (kept in sync by
  `examples/BasicC++/scripts/add_aliases_to_qrc.py`). → **I-0004**
  (migrate to `qt_add_qml_module`, which auto-generates
  `qmldir`+resources, compiles QML with `qmlsc`, registers types, and is
  the supported WASM path).
- **Module URI mismatch (I-0009):** `qmldir` files declare bare names
  (`module Style`, `module Elements`, `module Globals`,
  `module Components`, `module Charts`, `module Logic`,
  `module Animations`) while every import is dotted
  (`import EasyApplication.Gui.Style`). Works via directory resolution
  but breaks `qmllint`/`qmlsc`/Designer and blocks `qt_add_qml_module`
  (requires URI == path). `Charts`/`Animations` also omit version tags
  that others carry.
- Import scheme confirmed in
  `examples/AdvancedPy/src/AdvancedPy/main.py`:
  `EA_DIR = files("EasyApplication") / '..'`;
  `engine.addImportPath(EA_DIR)` → resolves
  `EasyApplication/Gui/<Module>/qmldir`. Registration is imperative
  (`qmlRegisterSingletonType(Backend, 'Backends', 1, 0, 'PyBackend')`) —
  classic, not `QML_ELEMENT`.

## QML quality

- **Private Qt API (I-0011):** private `QtQuick.Controls.impl` in **21**
  files; `QtQuick.Templates` in **30** (union 33). `Templates`
  (`T.Button`, `T.ApplicationWindow`) is legitimate and stays; `.impl`
  (`IconLabel` in `Button.qml`, `PlaceholderText` in `Parameter.qml`,
  `CheckIndicator`, `CursorDelegate`) is private/unversioned Qt
  internals → breaks on Qt updates. _(Round-2 correction: round 1 quoted
  the 33-file union as if all `.impl`.)_
- **Mixed versioned imports:** `import QtQuick 2.15`,
  `import QtQuick.Controls 2.15`, `import QtWebEngine 1.10`,
  `import EasyApplication.Gui.Elements 1.0`,
  `import QtQuick.XmlListModel 2.15`, `import QtQuick.Layouts 1.12`
  coexist with the unversioned Qt6 style used elsewhere. Standardise on
  unversioned (Qt6).
- **Diverged working-copy variant (I-0013):**
  `Gui/Charts/QtCharts1dBase 2.qml` (space-named) is **not** an
  identical copy — the diff vs `QtCharts1dBase.qml` shows a
  Rectangle-wrapped `ChartView` with debug `color: 'red'` and extra
  `allowZoom`/`useOpenGL`/`plotArea` API (an abandoned refactor). Not in
  `qmldir`; unloadable as a type (space in name); referenced only by the
  stale C++ `.qrc`. The canonical base is what
  `QtCharts1dMeasVsCalc.qml:9` extends.
- **`qmldir` registration gaps (I-0033, round 2):** `RadioIndicator.qml`
  exists but is missing from `Elements/qmldir` (41 registered vs 42 on
  disk); `ChartViewSimple1dPlotly.qml` and
  `ChartViewHeatmap2dPlotly.qml` exist but are missing from
  `Charts/qmldir` — reachable only by direct URL (the old `.qrc`-alias
  route).
- **Vendored eval-based JSONPath (I-0031, round 2):**
  `Components/JsonListModel.qml` embeds Goessner's 2007 JSONPath with
  `eval()` at `:112/:114/:148` (blocks `qmlsc`; injection-ish surface);
  its `updateJson()` XHR (`:39-48`) has no error handling and the
  `Error` status enum value is never set.
- **Minor smells (I-0023):** `Colors.qml isDarkPalette` redundant
  `return false` branches; `Button.qml`
  `cursorShape: checked ? PointingHand : PointingHand` (no-op ternary) +
  `MouseArea`(reject-only) beside a `HoverHandler` + dead
  `//console.error`; `Parameter.qml` an unanchored
  `Label{ enabled:false; text: control.title }`.
- **Two same-named windows (I-0028):** `Elements/ApplicationWindow.qml`
  (base, `T.ApplicationWindow`) vs `Components/ApplicationWindow.qml`
  (composed) — layering fine, shared name confusing.

## Sizing / theming tokens

- **Manual scaling vs HiDPI (I-0024):** `Sizes.qml`
  `scalePx(s)=round(s*defaultScale/100)`, `defaultScale:100` — manual
  scaling atop Qt6 auto-HiDPI risks double-scaling (desktop retina, WASM
  DPR). Font metrics via throwaway
  `property Text _text: Text{ font.pixelSize: scalePx(14) }` (use
  `FontMetrics`). Magic multipliers (`*5.5`, `*41.7`, `*2.75`).
  `appWindowWidth: Math.min(minimumWidth, Screen.width)` (default ==
  minimum; confusing).
- `Colors.qml` is a coherent hand-tuned dark/light token set (worth
  preserving); note the WASM `Settings` block (I-0003) and per-change
  `console.debug` (I-0021) inside it.

## Fonts / packaging (I-0015, I-0027)

- FontAwesome **5, 6, 7** all shipped under
  `Gui/Resources/Fonts/FontAwesome/`; only FA5 loaded (`Fonts.qml:26`).
  Filenames contain spaces (`Font Awesome 5 Free-Solid-900.otf`).
  `Fonts.qml` eagerly constructs ~13 `FontLoader`s at startup (PT
  Sans×2, PT Mono, Encode Sans×2, Condensed×2, Expanded×2, Nunito×3, FA)
  → WASM bundle bloat.
- `pyproject.toml` `dependencies = ['numpy', 'PySide6']` — `numpy`
  unused by the library (`grep -R "import numpy" src` → ∅); template
  default. → I-0027.

## Examples drift (I-0020)

The `.qrc`/`.pro` reference deleted components (`BoxShadow`,
`ElevationEffect`, `Popup`, `ToolBar`, `Plotly3dMesh`) and extra font
weights; the examples' own `Gui/`/`Backends/` layout has drifted from
the library's `Elements/Components`. A CMake build (I-0004) makes the
manifest generated, so this class disappears.
