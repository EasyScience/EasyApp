# I-0010: Zero real tests — every test file is a `test_dummy.py`; no QML tests; no smoke-load

- **Status:** open
- **Priority:** High
- **Area:** ci
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0001, I-0005, I-0018, I-0026; milestone G04; evidence
  [findings-governance-ci.md](../audit-2026-07/findings-governance-ci.md)

## Problem

The entire test suite is placeholders:

```
tests/unit/test_dummy.py
tests/functional/test_dummy.py
tests/integration/fitting/test_dummy.py
tests/integration/scipp-analysis/test_dummy.py
```

There are **no tests of any actual behaviour**, and — critically for a
QML library — **no QML tests at all** (no Qt Quick Test /
`qmltestrunner`, no smoke test that even loads the components). The
`integration/fitting` and `integration/scipp-analysis` folders are
leftover science-app scaffolding unrelated to GUI components.

Consequences already observed: the WASM build has been broken since the
`EasyApp` rename (I-0001) with a green CI, because nothing exercises the
QML or the web build.

## Impact

- No regression safety net. Any refactor (and the whole hardening plan
  is refactors) is blind.
- Junior agents have nothing to run to know if their change works — they
  cannot self-verify, which is exactly what this project needs them to
  do.

## Suggested fix

Build a small but real test pyramid; each layer catches a class of the
bugs this audit found:

1. **QML smoke-load test (highest value first).** A headless test that
   loads each top-level component and every `Elements/*` type and
   asserts it instantiates with no QML error/warning. Use Qt Quick Test
   (`qmltestrunner` / `QQuickTest`) or a PySide `QQmlComponent` loop
   that fails on any `component.errors()`. This alone would have caught
   I-0001, I-0013, I-0020.
2. **Qt Quick Test unit tests** for interactive `Elements` (Button
   click, CheckBox toggle, ComboBox selection, TextField edit) and for
   `Style` singletons (theme switch flips `Colors.isDarkPalette` and the
   derived colors).
3. **Python unit tests** for the backend logic that remains after
   decoupling: `Logging` level mapping, `Translate` language
   selection/sorting, `Utils.generalize_path` on posix/win inputs, and
   the `Maintenance` parse guards (I-0008). Delete the
   `fitting`/`scipp-analysis` dummy dirs.
4. **A WASM/desktop build smoke** in CI (I-0005): assert the built
   artifacts exist and, if feasible, run a headless load.
5. Wire all of it into `pixi run test` and make it required in CI. Set a
   coverage floor and ratchet it up (`fail_under` is currently 0).

## Acceptance criteria

- `pixi run test` executes real assertions (not `assert True`) across
  unit + QML smoke layers and is required for merge.
- A QML smoke test loads every `Elements/*` and every top-level
  `Components/*` type and fails on any QML error; deliberately breaking
  an import turns it red.
- The `test_dummy.py` files and the `fitting`/`scipp-analysis` folders
  are gone.
- CI runs the QML tests headlessly (e.g. with
  `QT_QPA_PLATFORM=offscreen`).
