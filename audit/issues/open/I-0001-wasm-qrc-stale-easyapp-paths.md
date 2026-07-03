# I-0001: C++/WASM `resources.qrc` points at the pre-rename `src/EasyApp/…` tree and lists deleted files

- **Status:** open
- **Priority:** Highest
- **Area:** build
- **Targets:** web
- **Found:** 2026-07 GUI base audit
- **Related:** I-0004 (CMake migration supersedes the hand-qrc), I-0009,
  I-0013, I-0020; milestone M01; evidence
  [findings-wasm-web.md](../audit-2026-07/findings-wasm-web.md)

## Problem

The only WASM/C++ vehicle is `examples/BasicC++`. Its resource manifest
embeds the whole component library by aliasing files from the library
`src` tree:

`examples/BasicC++/src/BasicC++/resources.qrc`

```xml
<file alias="EasyApp/Gui/Elements/Button.qml">../../../../src/EasyApp/Gui/Elements/Button.qml</file>
```

Every one of the ~180 aliased paths starts with
`../../../../src/EasyApp/…`. But the package was renamed from `EasyApp`
→ `EasyApplication` (git: `19f6937 Rename EasyApp to EasyApplication`),
so the real tree is `src/EasyApplication/…`. **None of those source
paths resolve any more.**

The same `.qrc` also lists files that no longer exist in the tree at all
— e.g. `Gui/Elements/BoxShadow.qml`, `ElevationEffect.qml`,
`RectangularGlow.qml`, `Popup.qml`, `ToolBar.qml`,
`Gui/Html/Plotly3dMesh.html`, `Gui/Html/PTSans-*.ttf`, and many extra
font weights (`EncodeSans-Black/-Medium/-Thin`, FontAwesome 6) — plus
the accidental duplicate `Gui/Charts/QtCharts1dBase 2.qml` (see I-0013).

The QMake project has the same stale path:
`examples/BasicC++/src/BasicC++.pro` →
`QML_IMPORT_PATH += ../../../src/EasyApp`.

## Impact

- **The web/WASM app cannot build.** `qmake`/`rcc` will fail on the
  missing RESOURCES files (or, worse, silently embed nothing and the app
  loads a blank window). The "web app" target that `edi` is supposed to
  inherit is currently non-functional and has been since the rename.
- It went unnoticed because the WASM CI never runs on push (I-0005) and
  there are no tests (I-0010). This is the concrete cost of those two
  gaps.
- Any junior agent told "build the web app" will hit an opaque wall of
  missing-file errors.

## Suggested fix

**Recommended:** do not repair the hand-written `.qrc` — replace the
whole mechanism with a CMake `qt_add_qml_module` build (I-0004), which
auto-generates the resource manifest from the module's actual files and
cannot drift. Track this fix under M01-T2 (CMake) and only do the
minimal repair below if a stop-gap WASM build is needed _before_ CMake
lands.

**Stop-gap (only if a WASM build is needed before I-0004):**

1. Regenerate the alias list from the real tree.
   `examples/BasicC++/scripts/add_aliases_to_qrc.py` already generates
   aliases — point it at `src/EasyApplication` and re-run it, or:
2. In `resources.qrc`, replace every `src/EasyApp/` with
   `src/EasyApplication/` **and** the alias prefix `EasyApp/` with
   `EasyApplication/` so the QML import URI matches
   (`import EasyApplication.Gui.Elements`). Verify the alias prefix
   equals the import path the QML uses.
3. Delete every `<file>` line whose target does not exist on disk. Get
   the authoritative list with:
   ```sh
   comm -23 \
     <(grep -oE 'src/EasyApp[^<"]*' resources.qrc | sed 's#src/EasyApp#src/EasyApplication#' | sort -u) \
     <(cd ../../../.. && git ls-files 'src/EasyApplication/*' | sort -u)
   ```
   Every path printed is a dangling reference — remove its line.
4. Remove the `QtCharts1dBase 2.qml` line (I-0013) and the Python-file
   lines (`Logic/*.py`, `__init__.py`) — Python is not used by the
   C++/WASM runtime.
5. Fix `BasicC++.pro`:
   `QML_IMPORT_PATH += ../../../src/EasyApplication`.
6. Rebuild for WASM per `.github/workflows/wasm.yml` locally and confirm
   the window renders.

## Acceptance criteria

- A WASM build of `examples/BasicC++` produces a running app (window
  renders, app bar visible), reproduced from a clean checkout.
- `grep -R "src/EasyApp\b" examples/` returns nothing (no un-renamed
  paths).
- No `<file>` in any `.qrc` points at a path absent from `git ls-files`.
- The `wasm` CI job (I-0005) builds this example on every push and is
  green.
