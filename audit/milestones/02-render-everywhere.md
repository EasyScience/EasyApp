# Milestone 02 — Render everywhere (charts & settings that work on WASM)

- **Phase:** I · **Priority:** 5/5 · **Status:** planned · **Depends:**
  G01
- **Bundles:**
  [I-0002](../issues/open/I-0002-charts-reports-require-qtwebengine.md),
  [I-0016](../issues/open/I-0016-charts-reload-on-resize.md),
  [I-0003](../issues/open/I-0003-settings-location-breaks-wasm.md)
- **Tasks:** [G02-T1](../roadmap/tasks/G02-T1-charting-facade.md) ·
  [G02-T2](../roadmap/tasks/G02-T2-charts-2d-3d-report.md) ·
  [G02-T3](../roadmap/tasks/G02-T3-settings-facade.md)

## Why

Even once the WASM app _builds_ (G01), it cannot show a plot or a report
(they need `QtWebEngine`, absent on WASM) and cannot persist settings
(`Settings{location}` throws in the browser). For a diffraction-analysis
GUI the plot **is** the app, so this milestone is what makes the web
target actually usable.

## Definition of done

1. The 1-D measured-vs-calculated + residual plot, the 2-D/3-D views,
   and the report all render on desktop **and** WASM from the same QML,
   via a native charting façade (QtGraphs/Qt Charts).
2. No shipped code imports `QtWebEngine`/`WebEngineView` (or only behind
   an explicit, documented desktop-only flag with the gap noted).
3. Charts update **in place** (no full reload on resize; no
   `JSON.stringify` data bridge); a 10⁵-point pattern updates smoothly.
4. A single settings façade persists theme/geometry/preferences on
   desktop and across a WASM page reload (via `localStorage`); no
   `Settings{location}` in screens; no "Gives WASM error" comments.

## Sequence

`G02-T3` (settings façade) is independent and can start immediately
(even in parallel with G01). `G02-T1` (1-D façade + chosen library)
needs G01; `G02-T2` (2-D/3-D + report, delete Plotly) needs T1.

## Explicitly deferred

- New visualisations beyond current parity (keep to matching what Plotly
  did).
- Chart theming polish beyond wiring `Style.Colors` tokens.

## Success criteria

- A reviewer loads the WASM app and sees a themed measured-vs-calc plot
  with residuals, resizes it without a flash, and changes+reloads a
  preference that sticks.
- The WASM bundle shrinks (Plotly JS/HTML + WebEngine removed).
