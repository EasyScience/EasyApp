# I-0015: Font bloat and ambiguity — FontAwesome 5/6/7 all shipped, unused weights, spaces in filenames

- **Status:** open
- **Priority:** Medium
- **Area:** build
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0004; milestone M06

## Problem

`Gui/Resources/Fonts/` ships far more than is used:

- **Three FontAwesome versions** are present —
  `Font Awesome 5 Free-Solid-900.otf`,
  `Font Awesome 6 Free-Solid-900.otf`,
  `Font Awesome 7 Free-Solid-900.otf` — but only **FA5** is loaded
  (`Gui/Style/Fonts.qml:26` → `"Font Awesome 5 Free-Solid-900.otf"`).
  FA6/FA7 are dead weight, and their glyph code-points differ, so it is
  ambiguous which the icons target.
- Font filenames **contain spaces**
  (`Font Awesome 5 Free-Solid-900.otf`). Spaces in resource paths are a
  known hazard for `.qrc` aliases, URLs, and some WASM/emscripten
  packaging steps.
- `Fonts.qml` eagerly constructs `FontLoader`s for PT Sans (×2), PT
  Mono, Encode Sans (×2), Encode Sans Condensed (×2), Encode Sans
  Expanded (×2), Nunito (×3), and FontAwesome — **~13 fonts loaded at
  startup** whether or not a screen uses them. On WASM each is a
  fetched/embedded blob, inflating startup size and time.

## Impact

- Larger wheels and larger WASM bundles (slower first paint in the
  browser) for fonts that are never displayed.
- Icon rendering depends on whichever FA version's code-points the QML
  uses; shipping three invites a silent mismatch.

## Suggested fix

1. **Pick one icon font version** (recommend FA6 or FA7 — current,
   better glyph coverage — and update the `iconsFamily` glyph references
   if migrating from FA5). Delete the other two `.otf` files.
2. **Rename the icon font file to remove spaces** (e.g.
   `FontAwesome-Solid.otf`) and update `Fonts.qml` + any `.qrc`.
3. **Ship only the weights actually used.** Audit which families/weights
   the UI references; drop the unused `.ttf`s. Keep the
   `OFL.txt`/`LICENSE.txt` for the ones you keep.
4. Consider lazy-loading rarely used families (construct the
   `FontLoader` on first use) to cut startup cost, especially for WASM.

## Acceptance criteria

- Exactly one FontAwesome `.otf` remains; icons still render on the
  example app.
- No font (or resource) filename contains a space.
- The set of shipped font files equals the set referenced by `Fonts.qml`
  (no orphans); verified by a small script/grep in CI.
