# I-0020: Examples reference components and files that no longer exist

- **Status:** open
- **Priority:** Medium
- **Area:** build
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0001, I-0004, I-0013, I-0019; milestone M01

## Problem

The C++ example's `resources.qrc` (and, by extension, the QMake WASM
build) lists library files that are **not in the current `src` tree**,
i.e. the examples describe an older/different version of the library
than what ships:

- Deleted `Elements`: `BoxShadow.qml`, `ElevationEffect.qml`,
  `RectangularGlow.qml`, `Popup.qml`, `ToolBar.qml`.
- Deleted `Charts`/`Html`: `Plotly3dMesh.html`,
  `Gui/Html/PTSans-Bold.ttf`, `Gui/Html/PTSans-Regular.ttf`.
- Font weights not present in `src` (e.g.
  `EncodeSans-Black/-Medium/-Thin`, FontAwesome 6 variants).
- The accidental duplicate `QtCharts1dBase 2.qml` (I-0013).

So even after the `EasyApp`→`EasyApplication` path fix (I-0001), the
manifest still points at absent files. The examples' own
`Gui/`/`Backends/` structure has also drifted from the library's
`Elements`/`Components` layering.

## Impact

- The web/C++ build cannot succeed until the manifest matches reality
  (compounds I-0001).
- The examples mislead a junior agent about which components exist and
  how to consume them.

## Suggested fix

1. **After I-0004 (CMake), this disappears** — the resource list is
   generated from real files. Prefer that.
2. As a stop-gap or verification, add a check that every path referenced
   by an example `.qrc`/`.pro` exists on disk (fail CI otherwise):
   ```sh
   for f in $(grep -oE '\.\./[^<"]+' examples/**/resources.qrc); do
     [ -e "$f" ] || echo "MISSING: $f"
   done
   ```
3. Re-sync the examples to the current library API
   (Elements/Components), or regenerate them from a single up-to-date
   template so they demonstrate the real components.

## Acceptance criteria

- No example manifest references a non-existent path (CI-enforced).
- Each example builds and runs against the current library.
- The duplicate `QtCharts1dBase 2.qml` reference is gone (with I-0013).
