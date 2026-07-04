# Milestone 01 — Web/WASM revival + CMake module build

- **Phase:** I · **Priority:** 5/5 · **Status:** planned · **Depends:**
  —
- **Bundles:**
  [I-0004](../issues/open/I-0004-no-cmake-qt-add-qml-module.md),
  [I-0009](../issues/open/I-0009-qmldir-module-uri-mismatch.md),
  [I-0001](../issues/open/I-0001-wasm-qrc-stale-easyapp-paths.md),
  [I-0020](../issues/open/I-0020-examples-reference-deleted-components.md),
  [I-0013](../issues/open/I-0013-duplicate-qtcharts-base-file.md),
  [I-0005](../issues/open/I-0005-wasm-ci-dispatch-only.md),
  [I-0033](../issues/open/I-0033-qmldir-registration-gaps.md)
- **Tasks:** [G01-T1](../roadmap/tasks/G01-T1-cmake-core-modules.md) ·
  [G01-T2](../roadmap/tasks/G01-T2-cmake-remaining-modules.md) ·
  [G01-T3](../roadmap/tasks/G01-T3-wasm-ci.md) ·
  [G01-T4](../roadmap/tasks/G01-T4-manifest-cleanup.md)

## Why this is first

The web/WASM app — a stated target `edi` will inherit — **does not
build**. The C++ example's resource manifest still points at the
pre-rename `src/EasyApp/…` tree and lists deleted files (I-0001/I-0020),
and nothing in CI catches it because the WASM job never runs (I-0005).
Repairing the hand-written manifest would fix the instance but not the
class: the real fix is a **CMake `qt_add_qml_module` build** that
generates the manifest and cannot drift (I-0004), which also fixes the
module-identity problem (I-0009) and unblocks `qmllint`/compiled QML.

## Definition of done

1. The library builds as CMake QML modules (`qt_add_qml_module`, URI ==
   import path) on desktop C++ **and** WASM; the app window renders on
   both.
2. The hand-written `resources.qrc`/`.pro` and `add_aliases_to_qrc.py`
   are gone; the resource manifest is generated.
3. `qmllint` runs over every module with no module-identity warnings.
4. The `wasm` CI job runs on every PR/push, is required, and goes red if
   a resource path breaks.
5. The duplicate `QtCharts1dBase 2.qml` is gone; no `src/` filename
   contains a space; no manifest references a missing path.
6. The existing PySide desktop path still works (dual build preserved).

## Sequence

`G01-T1` (CMake beachhead: Style/Globals/Elements) → `G01-T2`
(Components/Charts-native/Logic; delete manifest). `G01-T3` (CI) and
`G01-T4` (duplicate + manifest cleanup) can run in parallel; `G01-T4`'s
manifest half is mooted once `G01-T2` lands (do the duplicate-removal +
CI guard regardless).

## Explicitly deferred

- Replacing the WebEngine charts (that's **G02**) — here they are simply
  excluded from the WASM target so the rest can build/render.
- Fixing private-`.impl` usage (record `qmllint` warnings; fix in
  **G05**).
- Packaging/distribution polish (**G06**).

## Success criteria (externally checkable)

- A reviewer, from a clean checkout, runs the desktop and WASM presets
  and sees a rendered window on both.
- Deliberately renaming a source file referenced by a module breaks the
  build (manifest is generated, not stale-able).
- The WASM CI check is green on `master` and red on a PR that breaks a
  path.
