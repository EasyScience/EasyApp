# I-0002: Charts & reports render via `QtWebEngine`/`WebEngineView`, which does not exist for WASM

- **Status:** open
- **Priority:** Highest
- **Area:** wasm-web
- **Targets:** web
- **Found:** 2026-07 GUI base audit
- **Related:** I-0016 (the same charts are slow even on desktop),
  I-0003; milestone G02;
  [decisions-to-confirm.md §charts](../../design/decisions-to-confirm.md);
  evidence [findings-wasm-web.md](../audit-2026-07/findings-wasm-web.md)

## Problem

The primary charting stack (Plotly-in-a-webview) and the report renderer
depend on **QtWebEngine**, which is a Chromium embedding **not available
on the WebAssembly platform** (Qt ships no `QtWebEngine` for
`wasm-emscripten`; it is desktop/mobile only).

Ten shipped QML files import it:

```
Gui/Charts/ChartViewSimple1dPlotly.qml     Gui/Charts/ChartViewHeatmap2dPlotly.qml
Gui/Charts/Plotly1dLine.qml                Gui/Charts/Plotly1dBarPlot.qml
Gui/Charts/Plotly1dMeasVsCalc.qml          Gui/Charts/Plotly2dHeatmap.qml
Gui/Charts/Plotly2dPolarHeatmap.qml        Gui/Charts/Plotly3dScatter.qml
Gui/Charts/Plotly3dSurface.qml             Gui/Components/BasicReport.qml
```

e.g. `Gui/Charts/ChartViewSimple1dPlotly.qml:3` →
`import QtWebEngine 1.10`, then a
`WebEngineView { url: 'ChartTemplateSimple1dPlotly.html' }` driven by
`runJavaScript(...)`.

A **native** alternative already exists in the repo
(`Gui/Charts/QtCharts1dBase.qml`, `QtCharts1dMeasVsCalc.qml`, based on
Qt Charts) — so there are two parallel 1-D chart stacks, and the
richer/default one is the WebEngine one.

## Impact

- **The web app cannot show any plot or report.** For a
  _diffraction-analysis_ GUI, the plot (measured vs. calculated pattern,
  residuals) is the central surface — a web app without it is not
  viable. This alone blocks the WASM promise even after I-0001 is fixed.
- Two chart stacks double the maintenance surface and guarantee visual
  drift between targets.
- On desktop, QtWebEngine is a very heavy dependency (hundreds of MB,
  separate process, sandbox) for what is ultimately an XY line plot.

## Suggested fix

This is a design fork — record the choice in
[decisions-to-confirm.md](../../design/decisions-to-confirm.md) before
coding. Recommended direction:

1. **Adopt a single native charting layer that works on desktop _and_
   WASM.** Options, best first:
   - **QtGraphs** (Qt ≥ 6.7, GPU-accelerated, the successor to Qt
     Charts/Data Visualization, WASM-capable) — best long-term; covers
     1-D line/scatter and 2-D/3-D surfaces the Plotly stack currently
     does.
   - **Qt Charts** (`QtCharts`) — already partly used here;
     WASM-capable; simplest migration for the 1-D measured-vs-calculated
     view.
   - Custom `QQuickItem`/`ShaderEffect` or `Canvas` for the hot 1-D
     pattern view if profiling demands it (diffraction patterns can be
     10⁴–10⁵ points).
2. **Define a chart façade** — a small set of QML types (`Chart1D`,
   `Chart2DHeatmap`, `Chart3DSurface`) with a stable property API
   (`xValues`, `yValues`, `measuredData`, `calculatedData`, axis titles,
   theme colors). The app codes against the façade; the backend
   (QtGraphs/QtCharts) is swappable and identical across targets.
3. **Reimplement the report** (`BasicReport.qml`) without WebEngine:
   render to a `Text` (`TextEdit` with `Text.MarkdownText`/`RichText`)
   or generate a PDF via `QPdfWriter`/print support rather than an
   embedded browser.
4. Delete the Plotly HTML templates, `plotly-2.18.0.min.js`, and the
   WebEngine chart files once the façade reaches parity. Keep them only
   behind a desktop-only feature flag if a specific 3-D interaction
   cannot yet be matched — and document that gap.

## Acceptance criteria

- The 1-D measured-vs-calculated plot and the residual view render **in
  the WASM build** and on desktop, from the same QML source, with theme
  colors applied.
- `grep -R "QtWebEngine\|WebEngineView" src/` returns nothing (or only
  files behind an explicit, documented desktop-only flag).
- A charting façade exists with a documented property API and at least
  one example wiring real arrays through it (not `JSON.stringify` over a
  JS bridge — see I-0016).
- The chosen chart library is recorded and ratified in
  `decisions-to-confirm.md`.
