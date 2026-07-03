# I-0024: Manual `scalePx`/`defaultScale` scaling can fight Qt HiDPI; font metrics via a throwaway `Text{}`

- **Status:** open
- **Priority:** Medium
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0023; milestone M05

## Problem

`Gui/Style/Sizes.qml` computes all sizes from `fontPixelSize` times
magic multipliers and a manual scale:

- `scalePx(size) → Math.round(size * defaultScale/100)` with
  `defaultScale: 100`. Manual pixel scaling **on top of** Qt's automatic
  HiDPI device-pixel-ratio scaling can double-scale or conflict on
  high-DPI/retina and on WASM (where DPR handling differs).
- Font metrics are read from a **throwaway `Text{}` instance**:
  `property Text _text: Text { font.pixelSize: scalePx(14) }` then
  `fontPixelSize: _text.font.pixelSize`. The idiomatic tool is
  `FontMetrics`/`TextMetrics`.
- Dozens of magic multipliers (`fontPixelSize * 5.5`, `* 41.7`, `* 2.75`
  …) with no named rationale.
- `appWindowWidth: Math.min(appWindowMinimumWidth, Screen.width)` — the
  _default_ width is the _minimum_ of a minimum and the screen; the
  naming/intent is confusing (likely always opens at minimum width).

## Impact

- Inconsistent sizing across DPI scales and between desktop and WASM;
  hard to reason about because the numbers are unexplained.
- `edi` will copy these tokens; unclear scaling becomes a permanent
  foundation wart.

## Suggested fix

1. **Rely on Qt HiDPI** (Qt 6 enables high-DPI scaling by default) and
   express sizes in logical pixels; drop the manual `defaultScale`
   multiplier unless there is a _user_ zoom feature — if so, name it
   `uiScale` and document that it is intentional and multiplies logical
   px.
2. Replace the `_text: Text{}` metric hack with
   `FontMetrics { id: fm; font.pixelSize: … }` and derive
   `fontPixelSize` from it.
3. Replace magic multipliers with named tokens (e.g.
   `rowHeight = 2.75 * fontPixelSize` →
   `property real rowHeightEm: 2.75`) and a short comment on the design
   rationale, so the scale is legible.
4. Clarify the default-vs-minimum window size logic (`Math.min` vs
   `Math.max`) and comment intent.

## Acceptance criteria

- The example app renders at correct proportions on a 1× and a 2×
  (retina) display and in the browser, without double-scaling.
- `Sizes.qml` uses `FontMetrics`/`TextMetrics` (no throwaway `Text{}`),
  and size tokens are named with documented multipliers.
