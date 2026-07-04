# Findings — Web / WASM readiness

Backs **I-0001, I-0002, I-0003, I-0005, I-0016**. Verdict: **the
web/WASM target is broken today and architecturally blocked even once
unbroken.**

## 1. The WASM resource manifest is stale (I-0001)

`examples/BasicC++/src/BasicC++/resources.qrc` — every library alias is
rooted at the **pre-rename** path:

```xml
<file alias="EasyApp/Gui/Elements/Button.qml">../../../../src/EasyApp/Gui/Elements/Button.qml</file>
```

The tree is now `src/EasyApplication/` (git
`19f6937 Rename EasyApp to EasyApplication`). ~180 aliases all point at
`src/EasyApp/…` → none resolve. `BasicC++.pro` has the same:
`QML_IMPORT_PATH += ../../../src/EasyApp`. `main.qml`/`main.cpp` still
carry `EasyApp` SPDX/URLs.

The manifest also lists files **absent from the current tree** (→
I-0020): `Elements/BoxShadow.qml`, `ElevationEffect.qml`,
`RectangularGlow.qml`, `Popup.qml`, `ToolBar.qml`;
`Html/Plotly3dMesh.html`, `Html/PTSans-*.ttf`; extra font weights
(`EncodeSans-Black/-Medium/-Thin`, FA6); and the duplicate
`Charts/QtCharts1dBase 2.qml` (→ I-0013). It even embeds the Python
files (`Logic/*.py`) into the C++ resource — pointless for WASM.

Consequence: the WASM build cannot find the components; it has been
broken since the rename with no signal (because of §4).

## 2. Charts and reports require QtWebEngine — unavailable on WASM (I-0002)

`grep -Rl "QtWebEngine\|WebEngineView" src/` → **10 files**:

```
Gui/Charts/{ChartViewSimple1dPlotly, ChartViewHeatmap2dPlotly, Plotly1dLine, Plotly1dBarPlot,
            Plotly1dMeasVsCalc, Plotly2dHeatmap, Plotly2dPolarHeatmap, Plotly3dScatter,
            Plotly3dSurface}.qml
Gui/Components/BasicReport.qml
```

`ChartViewSimple1dPlotly.qml:3` → `import QtWebEngine 1.10`; renders a
`WebEngineView { url: 'ChartTemplateSimple1dPlotly.html' }` and drives
Plotly via `runJavaScript`. **Qt ships no QtWebEngine for
`wasm-emscripten`** (Chromium embedding, desktop/mobile only). So the
central plot (measured-vs-calculated + residuals) and the report cannot
render in the browser.

A native path exists (`Gui/Charts/QtCharts1dBase.qml`,
`QtCharts1dMeasVsCalc.qml` — Qt Charts, WASM-capable) → two parallel 1-D
chart stacks; the default/rich one is the WebEngine one.

## 3. `Settings { location: … }` throws on WASM — 11 sites (I-0003)

`grep -Rn "Gives WASM error on run" src/` → 11 live sites
(self-documented):

```
Gui/Components/ApplicationWindow.qml:116
Gui/Style/Colors.qml:142
Gui/Globals/Vars.qml:95, :101   (+ :89 commented)
Gui/Components/PreferencesDialog.qml:361,368,374,380,386
Gui/Components/ProjectDescriptionDialog.qml:127
```

Each is a `Settings { location: EaGlobals.Vars.settingsFile }` storing
theme / window geometry / logging level / param-name format /
preferences. On WASM, passing a file `location` errors; the comment is
shipped instead of a fix. Pattern is copy-pasted → no single fix site.

`Vars.qml:26` also builds `settingsFile` from
`Qt.resolvedUrl('settings.ini')` fallback. Note the platform is already
detected elsewhere: `Sizes.qml:22-26` branches on
`Qt.platform.pluginName === "wasm"` — the same guard should route
settings storage. The fix direction: default-constructed settings (no
file `location:`) persist through Qt's browser storage backend on WASM —
the exact mechanism (localStorage vs IndexedDB, readiness caveats) must
be verified on the pinned Qt during G02-T3, not assumed.

## 4. WASM CI is dispatch-only → nothing catches §1–3 (I-0005)

`.github/workflows/wasm.yml`:

```yaml
on:
  workflow_dispatch:
  #push:
  #schedule:
```

Never runs on push/PR. Also: builds only on `macos-14`; installs Qt via
the **online installer + account secrets**
(`QT_ACCOUNT_EMAIL/PASSWORD`); uses `qmake -spec wasm-emscripten` with
`wasm_singlethread`; and installs the **`addons.qt5compat`** module even
though nothing in `src`/`examples` imports `Qt5Compat` (verified round 2
— vestigial, drop it). So a web regression stays green forever — which
is exactly what happened.

## 5. Chart performance (I-0016)

`ChartViewSimple1dPlotly.qml`: `onWidthChanged: reload()` /
`onHeightChanged: reload()` → **full page reload** on every resize. Data
pushed via `runJavaScript(\`setYArrayValues(${JSON.stringify(
yArrayValues)})\`)`— large JSON marshalled across the JS bridge each redraw; diffraction patterns are 10⁴–10⁵ points, updated live during a fit.`setXArrayValues(newValues)`
ignores its argument.

## Net

Fixing §1 alone (rename paths) does **not** deliver a web app; §2
(WebEngine) and §3 (settings) are structural. The recommended order
(roadmap G01→G02): unbreak the build + move to CMake so the manifest
can't drift (§1), gate it in CI (§4), then replace WebEngine charts with
a native WASM-capable façade and add a settings façade (§2, §3, §5).
