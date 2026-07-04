# G02-T2: 2-D/3-D charts and the report without WebEngine

- **Class:** standard
- **Status:** blocked (needs G02-T1's façade + chosen library)
- **Depends:** G02-T1
- **Issues:**
  [I-0002](../../issues/open/I-0002-charts-reports-require-qtwebengine.md)
  (remaining users)
- **Anchors:** G02-T1 façade + Decision A (ratified: QtGraphs)

## Goal

Bring the 2-D heatmap, polar heatmap, 3-D scatter/surface, and the
report to the native, WASM-safe stack established in G02-T1, then delete
the Plotly/WebEngine files so **no** shipped code imports `QtWebEngine`.

## Scope

- **In:** `Chart2DHeatmap`, `Chart2DPolarHeatmap`,
  `Chart3DSurface`/`Chart3DScatter` façade types on the chosen native
  library; a non-WebEngine report (`BasicReport`) via `TextEdit`
  (Markdown/RichText) and/or `QPdfWriter` for export; delete
  `Gui/Charts/Plotly*.qml`, `Gui/Charts/ChartView*Plotly.qml`,
  `Gui/Html/Plotly*.html`, `plotly-2.18.0.min.js`, and the WebEngine
  `BasicReport`.
- **Out:** new visualisations beyond current parity; if one specific 3-D
  interaction cannot be matched natively, keep it behind an explicit
  desktop-only flag and **document the gap** (no silent loss).

## Plan

1. Implement the 2-D/3-D façade types on the G02-T1 library (QtGraphs
   covers surfaces/heatmaps natively).
2. Reimplement `BasicReport` without WebEngine (render
   Markdown/RichText; export via PDF writer).
3. Swap all remaining WebEngine users to the façade; delete the Plotly
   assets and WebEngine files.
4. Confirm the WASM target no longer links `QtWebEngine` at all.

## Acceptance gates

- `grep -R "QtWebEngine\|WebEngineView" src/` → nothing (or only an
  explicit, documented desktop-only flag with the gap noted).
- 2-D/3-D views and the report render on desktop **and** WASM from the
  façade.
- The Plotly HTML/JS assets are gone (smaller WASM bundle).

## Review focus

Feature parity vs the Plotly views (or documented gaps); WASM bundle
size drop; report export still works.

## Definition of done

I-0002 fully closed; `status.yml` G02-T2 → done.
