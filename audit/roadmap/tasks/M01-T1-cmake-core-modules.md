# M01-T1: CMake `qt_add_qml_module` for the core modules (Style, Globals, Elements)

- **Class:** design → standard (the governing Decision B was ratified
  2026-07-03: dual build)
- **Status:** ready
- **Depends:** —
- **Issues:**
  [I-0004](../../issues/open/I-0004-no-cmake-qt-add-qml-module.md),
  [I-0009](../../issues/open/I-0009-qmldir-module-uri-mismatch.md)
- **Anchors:**
  [decisions-to-confirm.md §build](../../design/decisions-to-confirm.md),
  [architecture-target.md](../../design/architecture-target.md),
  [modern-qt-guidelines.md](../../design/modern-qt-guidelines.md)

## Goal

Stand up a CMake build for the three foundational QML modules —
`EasyApplication.Gui.Style`, `.Globals`, `.Animations`, `.Elements` —
using `qt_add_qml_module`, with **URI == import path**, so that (a) the
module identity is correct (fixes I-0009), (b) `qmllint`/`qmlsc` work,
and (c) both a desktop C++ smoke and a WASM build can load these
modules. This is the beachhead that proves the model before the rest of
the library migrates (M01-T2).

## Scope

- **In:** a top-level `CMakeLists.txt` + per-module `qt_add_qml_module`
  targets for Style, Globals, Animations, Elements; a tiny C++
  `main.cpp` that loads an Elements smoke scene; fonts as module
  `RESOURCES`; correct `URI`/`VERSION`; the module-identity fix so
  `qmldir` is generated, not hand-written.
- **Out:** migrating Components/Charts/Logic (that's M01-T2); replacing
  WebEngine charts (M02); the PySide packaging change (M06) — but **do
  not break** the existing PySide import path (keep the `.qml` files
  where they are; CMake reads them in place).

## Plan

1. **Decision B is ratified (2026-07-03): dual build, one source tree**
   (PySide interprets the raw `.qml`; CMake compiles the same files for
   C++/WASM). Do not re-decide — implement per the decision; if reality
   contradicts it (e.g. a module genuinely cannot serve both paths),
   stop and report with specifics rather than improvising.
2. Add root `CMakeLists.txt` (`cmake_minimum_required(VERSION 3.21)`,
   `find_package(Qt6 REQUIRED COMPONENTS Quick Gui Qml)`,
   `qt_standard_project_setup(REQUIRES 6.5)`).
3. For each module add a target, e.g.:
   ```cmake
   qt_add_qml_module(EaStyle
     URI EasyApplication.Gui.Style
     VERSION 1.0
     QML_FILES Colors.qml Fonts.qml Sizes.qml Times.qml
     RESOURCES ${EA_FONTS}          # fonts referenced by Fonts.qml
   )
   ```
   Repeat for `.Globals` (Vars.qml), `.Animations`, `.Elements` (all
   `Elements/*.qml`). Do **not** commit hand-written `qmldir` for these
   — let CMake generate them (delete the old ones for the migrated
   modules, or keep only for the not-yet-migrated ones).
4. Note the interdependencies: `Elements` imports `Style`, `Globals`,
   `Animations` → link those modules and declare the import so `qmllint`
   resolves them.
5. Add a `main.cpp` that loads a minimal scene instantiating a handful
   of `Elements` (Button, Label, TextField) to prove the modules load
   with no QML error.
6. Add a CMake **preset** for desktop and one for WASM (`qt-cmake`
   toolchain). Build both locally.
7. Run `qmllint` on the three modules; fix module-identity warnings
   (should vanish now that URI==path) and record any private-`.impl`
   warnings for M05 (do **not** fix those here).

## Deliverables

- Root `CMakeLists.txt` + `CMakePresets.json` (desktop + wasm presets).
- `qt_add_qml_module` targets for Style, Globals, Animations, Elements.
- A C++ smoke `main.cpp` + scene loading Elements.
- Generated (not hand-written) `qmldir` for the migrated modules.
- Any deviations from ratified Decision B appended to
  `decisions-to-confirm.md` (none expected).

## Acceptance gates

- `cmake --preset desktop && cmake --build` builds; the smoke app opens
  and shows the Elements with no QML warnings/errors on the console.
- `qt-cmake` WASM preset **builds** the Elements/Style/Globals modules
  (rendering these three is proved here; the full app renders in
  M01-T2/M02).
- `qmllint` reports no module-identity warning for the three modules
  (I-0009 acceptance).
- The **existing PySide example still runs** unchanged (the raw `.qml`
  path is untouched).

## Test brief

Gate: each migrated module loads under both the C++ smoke and
(build-only) WASM; a deliberately renamed source file breaks the build
(proving the manifest is generated, not stale-able).

## Review focus

URI == import path exactly; fonts actually embedded (icons render in the
smoke, not tofu); no hand-written `qmldir` left for migrated modules;
PySide path untouched; private-`.impl` warnings recorded but not "fixed"
here (scope discipline).

## Definition of done

I-0009 acceptance met for the three modules; I-0004 beachhead delivered;
`status.yml` M01-T1 → done and M01-T2 unblocked.
