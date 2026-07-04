# I-0033: `qmldir` registration gaps — components on disk missing from their module

- **Status:** open
- **Priority:** Low
- **Area:** build
- **Targets:** both
- **Found:** 2026-07 GUI base audit (round 2)
- **Related:** I-0009, I-0004 (generated qmldir supersedes), I-0013;
  milestone G01

## Problem

Comparing each module's `qmldir` against the files on disk:

- `Gui/Elements/qmldir` does **not** list `RadioIndicator` (the file
  `Gui/Elements/RadioIndicator.qml` exists and is the project's radio
  indicator, cf. the listed `CheckIndicator`). Consumers cannot
  `import EasyApplication.Gui.Elements` and use `RadioIndicator`;
  anything reaching it relies on same-directory implicit resolution.
- `Gui/Charts/qmldir` does **not** list `ChartViewSimple1dPlotly` or
  `ChartViewHeatmap2dPlotly` (both files exist) — they are unreachable
  through the module import and only loadable by direct URL (which is
  how the old app used them, via the `.qrc` aliases).

So the module manifests under-describe the modules: some shipped
components are invisible to the import system, to `qmllint`, and to any
future generated documentation.

## Impact

- Silent inconsistency between "what ships" and "what the module
  declares"; tooling and consumers see different component sets. It also
  hides the two `ChartView*Plotly` files from the I-0002 WebEngine
  inventory if one only reads `qmldir`.

## Suggested fix

**Preferred:** this class of gap disappears with I-0004
(`qt_add_qml_module` generates `qmldir` from the declared file list —
one source of truth). During that migration, make an explicit
include/exclude decision for each currently-unlisted file:

1. `RadioIndicator.qml` → include in the Elements module (it is a live
   dependency of `RadioButton`).
2. `ChartViewSimple1dPlotly.qml` / `ChartViewHeatmap2dPlotly.qml` → do
   **not** carry into the new Charts module; they are WebEngine-based
   and are deleted by G02-T2 (I-0002). Until then, note them as
   legacy-URL-only.

**Stop-gap (only if the hand-written qmldir outlives G01-T1):** add the
`RadioIndicator 1.0 RadioIndicator.qml` line to `Gui/Elements/qmldir`.

## Acceptance criteria

- Every `.qml` file under a module directory is either declared by that
  module or explicitly listed as excluded (with a reason) in the
  module's CMake target — verified by a small CI script comparing disk
  vs declared sets.
- `RadioIndicator` is importable from `EasyApplication.Gui.Elements`.
