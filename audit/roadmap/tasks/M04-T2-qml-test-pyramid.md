# M04-T2: Qt Quick Test smoke-load + unit tests; delete the dummy tests

- **Class:** standard
- **Status:** ready (the smoke test is valuable even before CMake;
  deepen after M01)
- **Depends:** — (stronger with M01-T1 modules; can start against the
  PySide load path)
- **Issues:** [I-0010](../../issues/open/I-0010-zero-real-tests.md)
- **Anchors:**
  [findings-governance-ci.md §Tests](../../issues/audit-2026-07/findings-governance-ci.md)

## Goal

Give the project a real, runnable safety net — starting with the single
highest-value test: a **QML smoke-load** that instantiates every
`Elements/*` and every top-level `Components/*` type and fails on any
QML error/warning. Then add interactive unit tests and Python backend
tests. Delete the placeholder `test_dummy.py` files.

## Scope

- **In:** a headless QML smoke-load test (Qt Quick Test /
  `qmltestrunner`, or a PySide `QQmlComponent` loop failing on
  `component.errors()`); Qt Quick Test unit tests for a few interactive
  elements and the theme switch; Python unit tests for `Logging` level
  mapping, `Translate` selection/sort, `Utils.generalize_path`, and the
  `Maintenance` parse guards; wire all into `pixi run test` + CI
  headless (`QT_QPA_PLATFORM=offscreen`); delete dummy tests and the
  `fitting`/`scipp-analysis` dirs; raise the coverage floor off 0.
- **Out:** exhaustive per-component tests (grow over time);
  visual-regression/gallery (M08-T1).

## Plan

1. **Smoke-load (do first).** Enumerate `Elements/*.qml` + top-level
   `Components/*.qml`; for each, create the component and assert no
   errors/warnings. Run headless. This alone catches
   I-0001/I-0013/I-0020-class breakage.
2. **Interactive unit tests** (Qt Quick Test): Button click emits/acts;
   CheckBox toggles; ComboBox selects; TextField edits; toggling
   `Colors.theme` flips `Colors.isDarkPalette` and a derived color. Keep
   them small and deterministic.
3. **Python unit tests:** `Logging`
   `LOGGER_LEVELS`/`qtMsgTypeToCustomLevel`; `Translate`
   `sortByCode`/`systemLanguageIndex`/`defaultLanguageIndex`;
   `Utils.generalize_path` posix vs a simulated win path; `Maintenance`
   `_getWebDate` on empty/garbage input returns `''` (I-0008).
4. Delete `tests/**/test_dummy.py` and the
   `integration/{fitting,scipp-analysis}` dirs.
5. Wire into `pixi run test` and CI (offscreen); set a coverage floor
   and a ratchet.

## Deliverables

- QML smoke-load test; a starter set of Qt Quick Test unit tests; Python
  backend unit tests; dummy tests removed; CI runs QML tests headlessly.

## Acceptance gates

- `pixi run test` runs real assertions across unit + QML smoke and is
  required for merge.
- Deliberately breaking an `Elements` import turns the smoke test
  **red**.
- `test_dummy.py` and the `fitting`/`scipp-analysis` dirs are gone;
  coverage floor > 0 and enforced.
- CI runs the QML tests with `QT_QPA_PLATFORM=offscreen`.

## Test brief

The smoke test must load _every_ Element and top-level Component
(enumerate, don't hand-list, so new files are covered automatically).
Interactive tests assert behaviour, not pixels.

## Review focus

Headless stability (no flakiness); the enumerator picks up new files;
the smoke genuinely fails on a broken import (prove it in the PR, then
revert).

## Definition of done

I-0010 met; `status.yml` M04-T2 → done; unblocks the CI gates in M04-T1.
