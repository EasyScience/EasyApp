# I-0013: Diverged working-copy variant `QtCharts1dBase 2.qml` committed to `src`

- **Status:** open
- **Priority:** Low
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit (characterised in round 2: it is a
  _diverged_ variant, not a copy)
- **Related:** I-0001, I-0020; milestone G01

## Problem

`src/EasyApplication/Gui/Charts/QtCharts1dBase 2.qml` is a macOS
"copy-with-space-suffix" **working copy that has diverged** from
`QtCharts1dBase.qml`: the diff shows it wraps the `ChartView` in a
`Rectangle` with a debug `color: 'red'`, and adds an extended API
(`allowZoom`, `useOpenGL`, `plotArea`/`chartViewData` aliases) — i.e. an
abandoned (or in-progress) refactor saved beside the real file. It is
not declared in `Gui/Charts/qmldir`, **cannot be used as a QML type at
all** (type names cannot contain spaces — only a direct-URL load could
reach it), and yet is referenced by the C++ example's stale
`resources.qrc`
(`<file alias="EasyApp/Gui/Charts/QtCharts1dBase 2.qml">…`). The
canonical `QtCharts1dBase.qml` is the one `QtCharts1dMeasVsCalc.qml:9`
extends.

## Impact

- Dead, confusing near-duplicate; a reader cannot tell which base is
  intended. The space in the name is a resource-path hazard (see I-0015)
  and it pollutes the WASM resource set.

## Suggested fix

1. Review the diff against `QtCharts1dBase.qml`. If the
   Rectangle-wrapped/extended API was a _wanted_ direction, capture that
   intent as a note in the G02 chart-façade task — do **not** keep the
   file as the record. Either way:
2. `git rm "src/EasyApplication/Gui/Charts/QtCharts1dBase 2.qml"`.
3. Remove its line from any `.qrc` (folds into I-0001/I-0020).
4. Add a CI check that fails on filenames containing spaces or a
   ` 2.`-style suffix under `src/`.

## Acceptance criteria

- The file is gone; the example still builds; no manifest references it.
- A CI guard rejects space-containing / `\d`-suffixed duplicate
  filenames under `src/`.
