# I-0004: No CMake / `qt_add_qml_module`; the build relies on deprecated QMake + a hand-maintained `.qrc`

- **Status:** open
- **Priority:** Highest
- **Area:** build
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0001, I-0009, I-0011, I-0020; milestone M01;
  [decisions-to-confirm.md §build](../../design/decisions-to-confirm.md);
  evidence
  [findings-build-qml.md](../audit-2026-07/findings-build-qml.md)

## Problem

There is **no CMake build anywhere** (`find . -name CMakeLists.txt` →
nothing). The library is consumed in three ad-hoc ways:

- **Desktop-Python:** QML files are shipped as _data_ inside a Python
  wheel and found at runtime via
  `engine.addImportPath(<site-packages>)`. Module boundaries are
  declared with hand-written `qmldir` files.
- **C++/WASM:** a QMake `.pro` (`examples/BasicC++/src/BasicC++.pro`,
  `QT += core quick qml`) and a **hand-maintained** `resources.qrc`
  (~270 lines, kept in sync by a helper script
  `scripts/add_aliases_to_qrc.py`).

This is the classic (Qt5-era) approach. Modern Qt (≥ 6.2, strongly
recommended by 6.5+) builds QML modules with **`qt_add_qml_module`** in
CMake, which:

- generates the `qmldir` and the resource manifest automatically (no
  drift → I-0001 becomes impossible),
- compiles QML to C++ with `qmlsc`/`qmlcachegen` (faster startup,
  smaller runtime cost — matters for WASM),
- registers QML types properly (URI == module, enabling `qmllint` and Qt
  Design Studio — see I-0009),
- is the **supported path for WebAssembly**.

QMake is in long-term maintenance-only mode and is not the recommended
tool for new Qt 6 work.

## Impact

- Every downstream problem that "the manifest drifted" (I-0001), "the
  module URI doesn't match" (I-0009), "the examples list deleted files"
  (I-0020), and "we can't run `qmllint`/tests" (I-0010, I-0011) traces
  back to the absence of a real module build. Fixing this removes a
  class of bugs rather than an instance.
- `edi` will need a CMake build for its WASM surface regardless; doing
  it here first gives `edi` a ready, tested module to
  `find_package`/`add_subdirectory`.

## Suggested fix

Record the choice in
[decisions-to-confirm.md](../../design/decisions-to-confirm.md) (dual
build vs. CMake-only), then:

1. **Add a top-level `CMakeLists.txt`** that declares each library
   module with `qt_add_qml_module`, one per current directory:
   `EasyApplication.Gui.Style`, `.Globals`, `.Animations`, `.Elements`,
   `.Components`, `.Charts`, `.Logic`. Use
   `URI EasyApplication.Gui.Style` etc. so URI == import path (I-0009).
   ```cmake
   qt_add_qml_module(EaStyle
     URI EasyApplication.Gui.Style
     VERSION 1.0
     QML_FILES Colors.qml Fonts.qml Sizes.qml Times.qml
     RESOURCES <fonts…>            # fonts/icons become module resources
   )
   ```
2. **Keep the Python/PySide desktop path working.** PySide6 can load a
   `qt_add_qml_module`-built module too; alternatively keep shipping the
   raw `.qml` for the interpreted PySide path and use CMake for the
   compiled C++/WASM path. The recommended target model is documented in
   [architecture-target.md](../../design/architecture-target.md) (dual
   distribution).
3. **Delete the hand-written `.qrc`** and `add_aliases_to_qrc.py` once
   the CMake build embeds resources; delete/retire the `.pro` files.
4. Wire a WASM configure/build preset (`qt-cmake` + emscripten) and
   point CI (I-0005) at it.
5. Run `qmllint` (now enabled by proper modules) and fix what it
   surfaces (feeds I-0011).

Do this incrementally: land the `Elements` + `Style` + `Globals` modules
first (they have the fewest external deps), prove desktop + WASM both
load them, then migrate `Components`/`Charts`.

## Acceptance criteria

- `cmake --preset …` builds the library modules on desktop; `qt-cmake`
  builds them for WASM.
- The `qmldir` and resource manifests are **generated** (not
  hand-written); the old `.qrc`/`.pro` are gone or clearly marked
  legacy.
- `qmllint` runs over every module (green or with a tracked allowlist).
- Both the PySide desktop example and the WASM example run against the
  CMake-built modules.
- The build model (dual vs CMake-only, and how PySide consumes it) is
  ratified in `decisions-to-confirm.md`.
