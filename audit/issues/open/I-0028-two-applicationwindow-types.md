# I-0028: Two different `ApplicationWindow` types share a name → import ambiguity

- **Status:** open
- **Priority:** Low
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0030; milestone G05

## Problem

There are two `ApplicationWindow` types:

- `Gui/Elements/ApplicationWindow.qml` — the low-level base (extends
  `T.ApplicationWindow`, owns window flags, fonts, quit animation — and
  currently the updater, see I-0007).
- `Gui/Components/ApplicationWindow.qml` — the composed one (app bar +
  content area + status bar) that _derives from_ the Elements one.

The layering itself is reasonable (primitive vs composed), but sharing
the exact name `ApplicationWindow` across two modules is confusing: a
reader/importer must track which `EaElements.ApplicationWindow` vs
`EaComponents.ApplicationWindow` is meant, and it is easy to extend or
instantiate the wrong one.

## Impact

- Cognitive overhead and mis-import risk, especially for the junior
  agents building `edi`.

## Suggested fix

1. **Rename the base** to make the relationship explicit, e.g.
   `Elements/ApplicationWindowBase.qml` (or `BaseWindow`), keeping the
   composed `Components/ApplicationWindow.qml` as the one apps use.
2. Update `qmldir` and all imports; document the two in the style guide
   (I-0030): "apps use `EaComponents.ApplicationWindow`; the base is an
   implementation detail."
3. Do this alongside the I-0007 updater removal (both touch these
   files).

## Acceptance criteria

- The base and composed window have distinct names; imports are
  unambiguous.
- The style guide documents which one apps should use.
