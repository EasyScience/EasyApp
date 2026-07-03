# M05-T2: Modernisation batch — unversioned imports, base-window rename, smell fixes, JsonListModel de-eval

- **Class:** standard
- **Status:** blocked (wants the M04-T2 smoke test as the safety net)
- **Depends:** M04-T2
- **Issues:**
  [I-0023](../../issues/open/I-0023-minor-qml-code-smells.md),
  [I-0028](../../issues/open/I-0028-two-applicationwindow-types.md),
  [I-0031](../../issues/open/I-0031-jsonlistmodel-vendored-eval-jsonpath.md)
- **Anchors:**
  [modern-qt-guidelines.md §2, §10](../../design/modern-qt-guidelines.md);
  [findings-build-qml.md](../../issues/audit-2026-07/findings-build-qml.md)

## Goal

A batch of mechanical-ish modernisations: all imports unversioned (Qt 6
style); the ambiguous base window renamed (`Elements/ApplicationWindow`
→ `ApplicationWindowBase`); the named I-0023 smells fixed;
`JsonListModel` freed of its vendored `eval()`-based JSONPath.

## Scope

- **In:**
  1. Unversioned imports — the known versioned stragglers:
     `ChartViewSimple1dPlotly.qml`, `ChartViewHeatmap2dPlotly.qml`
     (`QtQuick 2.15`/`Controls 2.15`/`WebEngine 1.10` — these two files
     may already be deleted by M02-T2; skip if gone),
     `QtCharts1dValueAxis.qml` (`Globals 1.0`), `GuideWindow.qml`
     (`Layouts 1.12`); then a repo grep for any others.
  2. I-0028 rename per its §Suggested fix (base →
     `ApplicationWindowBase`, update `qmldir`/CMake + all imports; apps
     keep using `Components.ApplicationWindow`).
  3. I-0023 fixes per its §Suggested fix (isDarkPalette branches, Button
     no-op ternary + handler consolidation, Parameter title-Label
     positioning check).
  4. I-0031 per its §Suggested fix (usage survey → JSON.parse + explicit
     path-walk, XHR error handling, `Error` status, Qt Quick Test).
- **Out:** private-`.impl` work (M05-T1); sizing/HiDPI (M05-T3).

## Plan

Execute the four sub-batches in order, running the smoke test between
each; the issues carry the step-by-step. For I-0031 step 1, grep
`easydiffractionbeta` too before simplifying the JSONPath subset —
record the observed queries in the PR.

## Deliverables

- The four diffs; a note in the PR recording the JsonListModel query
  survey.

## Acceptance gates

- `grep -rnE "import [A-Za-z.]+ [0-9]+\.[0-9]+" src/` → nothing (no
  versioned imports).
- I-0023, I-0028, I-0031 acceptance criteria verbatim (incl.
  `grep "eval(" …/JsonListModel.qml` → nothing; imports unambiguous;
  smoke green).
- Example app renders/behaves identically (light + dark).

## Review focus

The rename's blast radius (every `EaElements.ApplicationWindow` import
site, docs, style guide); JsonListModel behavioural parity on the
surveyed queries.

## Definition of done

I-0023 + I-0028 + I-0031 closed; `status.yml` updated.
