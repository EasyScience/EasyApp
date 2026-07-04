# G06-T2: Prune fonts and dependencies

- **Class:** mechanical
- **Status:** ready
- **Depends:** — (independent; lands cleanly any time)
- **Issues:**
  [I-0015](../../issues/open/I-0015-font-bloat-and-spaces.md),
  [I-0027](../../issues/open/I-0027-numpy-runtime-dependency.md)
- **Anchors:**
  [findings-build-qml.md §Fonts](../../issues/audit-2026-07/findings-build-qml.md)

## Goal

The shipped resource set contains exactly what the UI uses: one
FontAwesome version, only the referenced font weights, no filename
spaces; `numpy` is gone from the runtime dependencies.

## Scope

- **In:** the four steps of
  [I-0015 §Suggested fix](../../issues/open/I-0015-font-bloat-and-spaces.md)
  (FA version choice needs a one-question owner confirm if migrating off
  FA5 — glyph code-points differ) +
  [I-0027 §Suggested fix](../../issues/open/I-0027-numpy-runtime-dependency.md);
  a CI check that shipped fonts == fonts referenced by `Fonts.qml`.
- **Out:** lazy-loading rarely-used families (note as follow-up if
  startup profiling wants it); changing the _visible_ typography.

## Plan

Follow the two issues' fix steps. For the FA choice: inventory the icon
glyphs actually used (grep for `\uf`-style codepoints and `iconsFamily`
usages), check them against FA6/FA7 maps, and present the owner the
"stay FA5" vs "migrate FA6/7 (these N glyphs change)" one-liner before
deleting.

## Deliverables

- Pruned `Resources/Fonts` (+ kept licenses), renamed space-free icon
  font, updated `Fonts.qml` and any manifest; `numpy` removed from
  `pyproject.toml`; the fonts-vs-references CI check.

## Acceptance gates

- I-0015 + I-0027 acceptance criteria verbatim (one FA file; no spaces;
  shipped == referenced, CI-checked; icons render in the example;
  examples run without numpy).
- Wheel and WASM bundle sizes recorded before/after in the PR (expect a
  visible drop).

## Review focus

No glyph regressions (compare the app's icon surfaces light+dark
before/after); OFL/license files kept for every retained family.

## Definition of done

I-0015 + I-0027 closed; `status.yml` updated.
