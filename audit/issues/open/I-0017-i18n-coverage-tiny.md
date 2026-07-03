# I-0017: i18n coverage is tiny — only 8 of 92 QML files use `qsTr()`

- **Status:** open
- **Priority:** Medium
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0029 (translator wiring); milestone M07

## Problem

A translation system exists (`Logic/Translate.py`,
`Gui/Logic/Translate.js`, a `TranslationChange` animation, retranslate
wiring), but only **8 of 92** QML files wrap user-facing strings in
`qsTr()`. The large majority of labels, dialog text, tooltips, and
button captions are hard-coded literals that no `.ts`/`.qm` can
translate.

## Impact

- The app is effectively English-only despite paying the cost/complexity
  of a translation runtime.
- Retrofitting `qsTr()` later across a grown app (`edi`) is far more
  expensive than establishing the habit now in the base.

## Suggested fix

1. Sweep the library: wrap every user-visible string in `qsTr()`
   (buttons, labels, dialog titles/bodies, tooltips, menu items, status
   text). Leave non-user strings (ids, style tokens, internal keys)
   alone.
2. Add a lint/grep check that flags likely-visible string literals not
   wrapped in `qsTr()` in `Elements/`/`Components/` (heuristic,
   allowlistable).
3. Establish and document the convention in the QML style guide
   (I-0030): all display text uses `qsTr()`; use `%1` arg substitution,
   not string concatenation, for interpolation.
4. Generate a `.ts` and confirm strings are extracted with `lupdate`.

## Acceptance criteria

- `lupdate` extracts the library's user-facing strings into a `.ts` with
  a substantial count (not ~a dozen).
- New literals in `Elements`/`Components` that look user-facing fail the
  CI heuristic.
- The style guide documents the `qsTr()` + `%1` rule.
