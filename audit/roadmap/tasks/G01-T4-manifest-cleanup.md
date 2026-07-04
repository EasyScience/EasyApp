# G01-T4: Remove the duplicate file and sync the example manifests

- **Class:** mechanical
- **Status:** ready
- **Depends:** — (independent; strongly complements G01-T1/T2)
- **Issues:**
  [I-0013](../../issues/open/I-0013-duplicate-qtcharts-base-file.md),
  [I-0020](../../issues/open/I-0020-examples-reference-deleted-components.md),
  [I-0001](../../issues/open/I-0001-wasm-qrc-stale-easyapp-paths.md)
  (the path-rename half),
  [I-0033](../../issues/open/I-0033-qmldir-registration-gaps.md)
  (stop-gap half)

## Goal

Delete the accidental duplicate `QtCharts1dBase 2.qml`, and make every
path referenced by an example `.qrc`/`.pro` point at a file that
actually exists (renaming `EasyApp`→`EasyApplication` and dropping
dangling entries), so the current qmake WASM build can at least find its
inputs. If G01-T2 has already replaced the hand-written manifest with a
generated one, this task's manifest half is moot — do only the
duplicate-file removal and the CI guard.

## Scope

- **In:**
  `git rm "src/EasyApplication/Gui/Charts/QtCharts1dBase 2.qml"`; rename
  `src/EasyApp/` →`src/EasyApplication/` in `resources.qrc` + the alias
  prefix; delete `<file>` lines whose target is absent on disk; fix
  `BasicC++.pro` `QML_IMPORT_PATH`; add CI guards.
- **Out:** the CMake migration (T1/T2); charts (G02); branding SPDX
  cleanup (that's G08-T4/I-0019, though fixing the `.pro` path here
  overlaps — do the path, leave the SPDX).

## Plan

1. Delete the diverged working-copy variant (I-0013). Review the diff
   against `QtCharts1dBase.qml` first — if its Rectangle-wrapped API
   looks like a wanted direction, note that in the G02-T1 packet; either
   way `git rm "…/QtCharts1dBase 2.qml"` (it is absent from `qmldir` and
   unloadable as a type). 1b. I-0033 stop-gap (only if the hand-written
   qmldir is still live, i.e. G01-T1 hasn't migrated the module yet):
   add `RadioIndicator 1.0 RadioIndicator.qml` to `Gui/Elements/qmldir`.
   Do NOT add the two `ChartView*Plotly` files to `Charts/qmldir` — they
   are WebEngine-based and are removed by G02-T2.
2. In `examples/BasicC++/src/BasicC++/resources.qrc`: replace
   `src/EasyApp/`→`src/EasyApplication/` and the `alias="EasyApp/…"`
   prefix→`EasyApplication/…` so aliases equal the import URIs.
3. Prune dangling entries. Generate the authoritative dangling list:
   ```sh
   cd examples/BasicC++/src/BasicC++
   for p in $(grep -oE '\.\./\.\./\.\./\.\./src/[^<"]+' resources.qrc); do
     [ -e "$p" ] || echo "MISSING: $p"
   done
   ```
   Remove each `MISSING` line (covers `BoxShadow`, `ElevationEffect`,
   `Popup`, `ToolBar`, `Plotly3dMesh`, `Html/PTSans-*`, absent font
   weights, and the removed duplicate). Also remove the
   `Logic/*.py`/`__init__.py` lines (Python is not used by the C++/WASM
   runtime).
4. Fix `examples/BasicC++/src/BasicC++.pro`:
   `QML_IMPORT_PATH += ../../../src/EasyApplication` (and
   `QML_DESIGNER_IMPORT_PATH`).
5. Add a **CI guard** (a small script, wired in G04-T1/CI) that fails
   if: (a) any `<file>` in a `.qrc` points at a non-existent path, or
   (b) any filename under `src/` contains a space or a ` N.ext`
   duplicate suffix.

## Deliverables

- Duplicate file deleted; `resources.qrc` and `.pro` corrected; CI guard
  script.

## Acceptance gates

- `grep -R "src/EasyApp\b" examples/` → nothing; no `.qrc` `<file>`
  points at a missing path (the guard script exits 0).
- `find src -name '* *'` → nothing (no spaces in source filenames).
- The qmake WASM build finds all its inputs (or G01-T2 has superseded
  the manifest, noted in the PR).

## Review focus

Alias prefix equals the QML import URI (not just the path renamed); no
live component accidentally dropped (cross-check the pruned list against
`git ls-files 'src/EasyApplication/*'`).

## Definition of done

I-0013 met; I-0020 met (or superseded by T2, noted); the path-rename
half of I-0001 met; `status.yml` G01-T4 → done.
