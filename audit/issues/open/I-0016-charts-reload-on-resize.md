# I-0016: Plotly charts full-page `reload()` on every resize and push data through the JS bridge

- **Status:** open
- **Priority:** Medium
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0002 (the WebEngine replacement removes this class of
  problem); milestone G02

## Problem

In `Gui/Charts/ChartViewSimple1dPlotly.qml` (and its siblings):

```qml
onWidthChanged: reload()
onHeightChanged: reload()
```

Every resize triggers a **full web-page reload** of the `WebEngineView`
(re-parse HTML, re-run Plotly, re-fetch the bundled JS), then re-pushes
the data. Data is delivered by serializing arrays to JSON and evaluating
JS:

```qml
chartView.runJavaScript(`setYArrayValues(${JSON.stringify(yArrayValues)})`)
```

For diffraction patterns (often 10⁴–10⁵ points, updated live during a
fit), this means large JSON strings marshalled across the QML↔JS
boundary and a full page reload on each layout change — janky resizing
and heavy per-frame cost during refinement.

Minor: `setXArrayValues(newValues)` / `setYArrayValues(newValues)`
accept a parameter that is ignored (they read the outer
`xArrayValues`/`yArrayValues`).

## Impact

- Visible stutter on window resize and during live-fit updates; poor
  perceived performance for the app's most important view.
- On WASM (once WebEngine is even possible — it isn't, see I-0002) this
  would be worse.

## Suggested fix

Fold into I-0002: when charts move to a native library
(QtGraphs/QtCharts), the model updates in-place — a resize just
relayouts, and data binds directly to a series (no JSON bridge, no
reload). Specifically:

1. Bind the series to the data model/`ListModel`/typed arrays; update
   points in place on new data, not by re-serializing the whole array.
2. Handle resize by letting the chart relayout (native charts do this
   automatically) — no reload.
3. Remove the dead `newValues` parameters.

If any Plotly view must survive on desktop in the interim, at minimum:
debounce `reload()` and update data via `Plotly.react`/`Plotly.restyle`
(in-place) instead of full reload.

## Acceptance criteria

- Resizing the chart does not reload/rebuild it (no flash, no re-fetch);
  measured by the absence of a reload log/counter on resize.
- Live data updates mutate an existing series rather than re-serializing
  the full array each frame; a 10⁵-point pattern updates smoothly.
