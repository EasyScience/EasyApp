# I-0023: Minor QML code smells (redundant branches, no-op ternary, workaround handlers)

- **Status:** open
- **Priority:** Low
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0011; milestone M05

## Problem

A handful of small correctness/readability smells found while reading
representative elements:

- `Gui/Style/Colors.qml` `isDarkPalette` has redundant branches that all
  `return false` (the `Qt.ColorScheme.Unknown` and trailing `else` arms
  are duplicated dead paths).
- `Gui/Elements/Button.qml`:
  `cursorShape: control.checked ? Qt.PointingHandCursor : Qt.PointingHandCursor`
  — both branches identical (pointless ternary); a `MouseArea` that only
  exists to reject events sits next to a `HoverHandler` (workaround-y);
  a `//console.error(...)` dead line.
- `Gui/Elements/Parameter.qml`: an
  `EaElements.Label { enabled: false; text: control.title }` with no
  anchoring/positioning — looks incomplete.

These are individually trivial but collectively signal the absence of a
lint gate (I-0026).

## Impact

- Readability and micro-maintenance cost; a couple (the unanchored
  Label) may be latent UI bugs.

## Suggested fix

1. Simplify `isDarkPalette` to the minimal branch set (dark → true;
   light → false; system → map `Qt.ColorScheme.Dark` to true else
   false).
2. In `Button.qml`, collapse the no-op ternary to a single value, remove
   the dead comment, and re-evaluate whether both the `MouseArea` and
   `HoverHandler` are needed (prefer a single
   `HoverHandler`/`TapHandler`).
3. Verify the `Parameter.qml` title `Label` is positioned as intended
   (or remove it).
4. Let `qmllint` (I-0026) catch the rest once enabled.

## Acceptance criteria

- The named smells are resolved; controls render and behave identically
  (smoke test I-0010).
- `qmllint` is clean on the touched files.
