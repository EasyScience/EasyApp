# M01-T2: Migrate the remaining modules to CMake; retire the hand-written `.qrc`/`.pro`

- **Class:** standard
- **Status:** blocked (needs M01-T1)
- **Depends:** M01-T1
- **Issues:**
  [I-0004](../../issues/open/I-0004-no-cmake-qt-add-qml-module.md),
  [I-0001](../../issues/open/I-0001-wasm-qrc-stale-easyapp-paths.md),
  [I-0020](../../issues/open/I-0020-examples-reference-deleted-components.md)
- **Anchors:**
  [architecture-target.md](../../design/architecture-target.md); M01-T1
  result

## Goal

Extend the M01-T1 CMake build to the remaining modules (`Components`,
`Charts` — the WASM-capable subset only, `Logic`, `Logic/Maintenance` if
it still exists post-M03) so the **whole app** builds and renders on
desktop C++ and WASM from a generated resource manifest, and the
hand-written `resources.qrc` + `.pro` are deleted. After this,
I-0001/I-0020 are structurally impossible (no hand-maintained manifest
to drift).

## Scope

- **In:** `qt_add_qml_module` targets for the remaining modules; a
  full-app C++ `main.cpp` loading `Components.ApplicationWindow`; delete
  `examples/BasicC++/…/resources.qrc`, `add_aliases_to_qrc.py`, and the
  `.pro` files; convert the `BasicC++` example to CMake.
- **Out:** the WebEngine charts — **exclude** them from the WASM target
  (they cannot compile/run there); the native chart façade is M02-T1.
  Gate the WebEngine chart files behind a desktop-only CMake condition
  or omit until M02 replaces them.

## Plan

1. Add module targets mirroring M01-T1 for `Components`, `Logic`; for
   `Charts`, include only the `QtCharts*`/native files, **not** the
   `Plotly*`/WebEngine ones on WASM.
2. Wire inter-module deps (`Components` imports
   `Elements`/`Style`/`Globals`/`Charts`).
3. Replace the `BasicC++` example with a CMake target that links the
   modules and loads `EasyApplication.Gui.Components.ApplicationWindow`
   (a minimal host page model — see M03-T1).
4. Delete `resources.qrc`, `add_aliases_to_qrc.py`, `*.pro`.
5. Point M01-T3 CI at `qt-cmake --preset wasm`.
6. Run `qmllint` across all migrated modules; record (don't fix)
   private-`.impl` warnings for M05.

## Deliverables

- CMake targets for all shipped modules; CMake-based `BasicC++`; the
  hand-written manifest/scripts deleted.

## Acceptance gates

- Desktop C++ and WASM both build the full app; the window renders (app
  bar + a page) on both, from generated manifests.
- No hand-written `.qrc`/`.pro` remain
  (`find . -name '*.qrc' -o -name '*.pro'` → only legacy clearly-marked,
  ideally none).
- `qmllint` runs over every module.
- WebEngine chart files are excluded from the WASM target (build proves
  it).

## Review focus

That WASM genuinely excludes WebEngine (no `QtWebEngine` link on the
wasm preset); generated manifest completeness (every needed `.qml`/font
present); PySide path still works.

## Definition of done

I-0004 complete; I-0001/I-0020 structurally closed; M02 unblocked;
`status.yml` updated.
