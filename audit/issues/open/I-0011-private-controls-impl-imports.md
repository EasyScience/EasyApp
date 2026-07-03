# I-0011: Private Qt API `QtQuick.Controls.impl` imported in 21 QML files

- **Status:** open
- **Priority:** Medium
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0004, I-0009 (needed to run qmllint that catches this),
  I-0028; milestone M04/M05

## Problem

**21** QML files import the private `QtQuick.Controls.impl` (a further 9
import only the supported `QtQuick.Templates`; the union is 33 files).
The `.impl` importers use **private** helper types such as `IconLabel`,
`PlaceholderText`, `CheckIndicator`, `CursorDelegate`. Example:
`Gui/Elements/Button.qml` and `Gui/Elements/Parameter.qml` both rely on
`.impl` types.

`QtQuick.Templates` is a legitimate, supported base for building custom
controls (`T.Button`, `T.ApplicationWindow` — keep those). But
`QtQuick.Controls.impl` is **private, unversioned Qt internals**: its
types can change or vanish between Qt minor releases with no
deprecation. A diffraction app that must track Qt LTS updates (and build
for WASM with a specific Qt) is exposed to silent breakage.

## Impact

- Qt upgrades (routine, and required to get WASM/QtGraphs improvements)
  risk breaking controls with cryptic errors.
- These files can't be statically checked cleanly; combined with I-0009
  it's why QML quality drifts.

## Suggested fix

1. First enable `qmllint` (needs I-0009/I-0004) and get the
   authoritative list: `grep -Rl "QtQuick.Controls.impl" src/`.
2. For each private type, replace with a supported equivalent:
   - `IconLabel` → compose `Image`/`Text` (or use the control's own
     `contentItem` with public properties) — a small shared
     `EaIconLabel.qml` in `Elements/` gives one place to own it.
   - `PlaceholderText` → a plain `Text` positioned by the control (as
     `Parameter.qml` already does manually).
   - `CheckIndicator`/`RadioIndicator`/`CursorDelegate` → the project
     already has its own `CheckIndicator.qml`, `RadioIndicator.qml`,
     `CursorDelegate.qml`; make the controls use the project types, not
     Qt's private ones.
3. Where a private type has no public equivalent, wrap it in a single
   project element so there is exactly one import site to fix on a
   future Qt bump.
4. Add a CI grep gate: no new `QtQuick.Controls.impl` imports outside
   the allowlisted wrappers.

## Acceptance criteria

- `grep -R "QtQuick.Controls.impl" src/` returns only an explicit,
  documented allowlist (ideally empty).
- Controls render identically before/after (visual check on the example
  app, light + dark).
- A Qt minor-version bump in CI does not break the controls (smoke test
  from I-0010 passes).
