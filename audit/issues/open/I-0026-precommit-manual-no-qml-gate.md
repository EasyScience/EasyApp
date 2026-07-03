# I-0026: Pre-commit hooks are all `stages: [manual]`; no QML lint/format gate anywhere

- **Status:** open
- **Priority:** Medium
- **Area:** ci
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0004, I-0009, I-0010, I-0018; milestone M04

## Problem

`.pre-commit-config.yaml` defines useful checks (pyproject validation,
license headers, ruff lint/format, docstring lint, prettier, unit tests)
— but **every hook is `stages: [manual]`**, so none run automatically on
`git commit`/`push`. They only run if invoked explicitly
(`pixi run check`). In practice the gate is opt-in and easily skipped.

There is also **no QML tooling** in pre-commit or CI: no `qmllint`, no
`qmlformat`, no QML tests. `prettier` formats JSON/MD/YAML but not
`.qml`.

## Impact

- Formatting/lint drift and QML errors land unchecked (contributes to
  I-0011, I-0021, I-0001).
- CI (`test.yml`) runs the Python checks but nothing QML — the actual
  product is ungated.

## Suggested fix

1. Move the everyday checks off `manual` so they run on
   `pre-commit`/`pre-push` (keep slow ones on push). Keep a `manual`
   full-suite for on-demand runs.
2. Add QML gates once modules build (I-0004/I-0009):
   - `qmllint` over every module (pre-commit + CI),
   - `qmlformat --check` (and a `qmlformat -i` fix task),
   - the QML smoke/unit tests (I-0010) in CI.
3. Add the grep gates other issues rely on (no `EasyDiffraction` in
   `src` — I-0006; no `QtQuick.Controls.impl` outside allowlist —
   I-0011; no dangling `.qrc` paths — I-0020).

## Acceptance criteria

- A commit that violates ruff/qmllint/qmlformat is rejected by
  pre-commit locally and by CI.
- CI runs `qmllint`, `qmlformat --check`, and the QML tests on every PR.
