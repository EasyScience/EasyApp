# G05-T3: HiDPI/sizing cleanup — FontMetrics, named tokens, no manual double-scaling

- **Class:** standard
- **Status:** draft (promote to ready once G05-T1/T2 land; touches the
  same Style files)
- **Depends:** G05-T2
- **Issues:**
  [I-0024](../../issues/open/I-0024-manual-scaling-vs-hidpi.md)
- **Anchors:**
  [modern-qt-guidelines.md §4](../../design/modern-qt-guidelines.md);
  [findings-build-qml.md §Sizing](../../issues/audit-2026-07/findings-build-qml.md)

## Goal

`Sizes.qml` expresses the design scale in logical pixels relying on Qt 6
auto-HiDPI: no manual device scaling, font metrics via `FontMetrics`,
magic multipliers replaced by named tokens with a one-line rationale,
and the default-vs-minimum window sizing intent made explicit.

## Scope

- **In:** the four steps of
  [I-0024 §Suggested fix](../../issues/open/I-0024-manual-scaling-vs-hidpi.md);
  if a _user_ zoom feature is wanted, name it `uiScale` and document it
  (ask the owner — one question, don't assume).
- **Out:** changing any actual size value (the rendered UI must look the
  same at 1×); theming (`Colors`) untouched.

## Plan

Follow I-0024 steps 1–4. Verification setup: run the example on a 1× and
a 2× (or `QT_SCALE_FACTOR=2`) display and in the WASM build; compare
against before-screenshots.

## Deliverables

- Reworked `Sizes.qml` (FontMetrics, named em-multiplier tokens,
  documented `uiScale` or its removal); a short token table added to the
  style-guide/catalog docs.

## Acceptance gates

- I-0024 acceptance verbatim (correct proportions at 1×/2×/browser, no
  double-scaling; FontMetrics in use; tokens named + documented).
- Pixel-identical rendering at 1× vs the pre-change screenshots (within
  font-rounding).

## Review focus

Every `scalePx` call site accounted for; `Screen.width`-dependent
expressions still correct on multi-monitor; WASM DPR behaviour actually
checked, not assumed.

## Definition of done

I-0024 closed; `status.yml` updated.
