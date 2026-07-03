# M02-T1: Charting façade + native 1-D backend (replace the WebEngine 1-D plot)

- **Class:** design → standard (the governing Decision A was ratified
  2026-07-03: QtGraphs; the design step that remains is the façade API +
  the validating prototype)
- **Status:** blocked (needs M01 so modules build + WASM excludes
  WebEngine)
- **Depends:** M01-T2
- **Issues:**
  [I-0002](../../issues/open/I-0002-charts-reports-require-qtwebengine.md),
  [I-0016](../../issues/open/I-0016-charts-reload-on-resize.md)
- **Anchors:**
  [decisions-to-confirm.md §charts](../../design/decisions-to-confirm.md),
  [architecture-target.md](../../design/architecture-target.md)

## Goal

Deliver the app's most important view — the 1-D measured-vs-calculated
diffraction pattern with residuals — as a **native, WASM-capable** chart
behind a stable façade, replacing the `QtWebEngine`/Plotly
implementation. The façade lets the app code stay identical while the
backend (QtGraphs or Qt Charts) is chosen once and swapped centrally.

## Scope

- **In:** a `Chart1D` façade QML type with a documented property API
  (`xValues`, `yValues`, `measuredData`, `calculatedData`,
  `residualData`, axis titles, theme colors) backed by a native library;
  wire it into the measured-vs-calc view; in-place data updates (no
  reload, no `JSON.stringify` bridge); theme integration via
  `Style.Colors`.
- **Out:** 2-D/3-D charts and the report (M02-T2); removing every Plotly
  file (do the 1-D first, prove parity, then M02-T2 finishes the
  removal).

## Plan

1. **Decision A is ratified (2026-07-03): QtGraphs.** Do not re-decide.
   Start with a **measured 1-D prototype** on the live-fit workload
   (10⁴–10⁵ points, in-place updates, desktop + WASM) to validate it;
   append the measurements to Decision A in `decisions-to-confirm.md`.
   Only if the prototype misses the frame budget: stop and escalate to
   the owner with the numbers (fallbacks: Qt Charts for 1-D, or a custom
   `QQuickItem` — options A2/A3).
2. Define `Gui/Charts/Chart1D.qml` (or `EaCharts.Chart1D`) with the
   property API above and no knowledge of the app, backed by QtGraphs.
   Series for measured (scatter/line), calculated (line), residual
   (line, secondary axis). Colors from
   `EaStyle.Colors.chartForegrounds`.
3. Bind data to the series and update **in place** on change (no page
   reload; resize just relayouts). Remove the `newValues`-ignored-param
   bug pattern.
4. Replace `QtCharts1dMeasVsCalc`/`ChartViewSimple1dPlotly` usage in the
   measured-vs-calc view with `Chart1D`. Keep the old files until M02-T2
   removes them.
5. Verify on desktop **and** WASM; check large-array performance (a
   10⁵-pt pattern updates smoothly; resize does not flash).

## Deliverables

- `Chart1D` façade + QtGraphs backend; measured-vs-calc view using it;
  the prototype measurements appended to Decision A.

## Acceptance gates

- The 1-D measured/calculated/residual plot renders **in the WASM
  build** and on desktop from the same QML, with theme colors, and
  updates in place on new data.
- No `reload()`-on-resize and no `JSON.stringify` data bridge in the new
  path (I-0016).
- The façade property API is documented (feeds the catalog, I-0025).

## Test brief

Smoke: `Chart1D` instantiates on desktop + WASM. Behaviour: feeding
measured+calculated arrays draws both series; a resize does not rebuild
the chart; a 10⁵-pt update stays responsive.

## Review focus

WASM actually renders (not a blank canvas); no residual `QtWebEngine`
import on this path; colors come from `Style` tokens (light+dark);
performance on large arrays.

## Definition of done

I-0002 (1-D portion) + I-0016 met; M02-T2 unblocked; `status.yml`
updated. Full I-0002 closes when M02-T2 removes the remaining WebEngine
users.
