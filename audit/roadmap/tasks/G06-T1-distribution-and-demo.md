# G06-T1: Dual distribution model implementation + self-demo entry point

- **Class:** design → standard (Decision B is ratified: dual build; this
  task implements the _distribution_ half and decides the packaging
  details)
- **Status:** draft (promote once G01-T2 lands — it distributes what G01
  built)
- **Depends:** G01-T2
- **Issues:**
  [I-0014](../../issues/open/I-0014-broken-python-m-entrypoint.md)
- **Anchors:**
  [decisions-to-confirm.md §Decision B ✅](../../design/decisions-to-confirm.md),
  [architecture-target.md §Build & distribution](../../design/architecture-target.md)

## Goal

Both consumption paths are installable artifacts: the **Python wheel**
(raw QML + Python backend, for the PySide desktop path — exists today,
keep working) and a **CMake package** (`find_package( EasyApplication)`
or documented `add_subdirectory`/FetchContent, for the C++/WASM path).
Plus a working self-demo: `python -m EasyApplication` opens a minimal
demo window instead of erroring.

## Scope

- **In:** CMake install/export targets for the G01 modules (package
  config, versions); wheel content audit (ships exactly the runtime
  files — QML, the _used_ fonts, no tests/tools);
  `src/EasyApplication/__main__.py` launching a minimal window (upgrade
  to the G08-T1 gallery when it exists — keep this one tiny); document
  both install paths in the README/docs.
- **Out:** the gallery app itself (G08-T1); PyPI release mechanics
  (exists via workflows); font pruning (G06-T2 — but coordinate so the
  wheel audit reflects it).

## Plan

1. Add `install(...)`/`qt_generate_...` export so an external CMake
   project can `find_package(EasyApplication)` and import the QML
   modules; prove it with a tiny out-of-tree consumer in CI.
2. Write `__main__.py`: `QGuiApplication` + engine + a 30-line demo QML
   (an `ApplicationWindow` with a few Elements). Wire
   `pixi run EasyApplication` to it (I-0014).
3. Audit the wheel (`pixi run dist-build`, inspect contents) — exclude
   tools/tests/dev files.
4. Document: "consume from Python (pip)" and "consume from CMake
   (desktop/WASM)" quick-starts.

## Deliverables

- CMake package export + out-of-tree consumer smoke in CI; `__main__.py`
  demo; wheel content audit; docs section.

## Acceptance gates

- An out-of-tree `find_package(EasyApplication)` hello-app builds and
  runs in CI (desktop; WASM configure at minimum).
- `pixi run EasyApplication` opens the demo window (I-0014 acceptance).
- The wheel installs into a clean venv and the PySide example runs
  against it.

## Review focus

Version consistency between the wheel (versioningit) and the CMake
package version; no dev files leaking into either artifact.

## Definition of done

I-0014 closed; the distribution model documented; `status.yml` updated.
