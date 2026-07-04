# G04-T1: qmllint + qmlformat gates; un-manual pre-commit; strip console/dead code

- **Class:** standard
- **Status:** blocked (qmllint needs the G01-T1 module identities; the
  pre-commit/grep parts could start earlier if needed)
- **Depends:** G01-T1
- **Issues:**
  [I-0026](../../issues/open/I-0026-precommit-manual-no-qml-gate.md),
  [I-0021](../../issues/open/I-0021-console-debug-and-dead-code.md)
- **Anchors:**
  [findings-governance-ci.md §CI](../../issues/audit-2026-07/findings-governance-ci.md),
  [modern-qt-guidelines.md §Enforcement](../../design/modern-qt-guidelines.md)

## Goal

The QML — the actual product — is gated: `qmllint` and
`qmlformat --check` run in pre-commit and CI and are required; the
everyday Python checks stop being `stages: [manual]`; the audit's grep
gates are wired; leftover `console.*`/dead code is removed so the lint
starts green.

## Scope

- **In:** pixi tasks
  `qml-lint-check`/`qml-format-check`/`qml-format-fix`; pre-commit hooks
  moved off `manual` (fast checks on commit, slower on push; keep a
  `manual` full suite); CI job running the QML gates; the grep gates
  from the guidelines enforcement table (no `easydiffraction`, no
  `QtQuick.Controls.impl` outside allowlist, no `Settings{location}` in
  screens, no `QtWebEngine`/`QtTest` in src, no dangling `.qrc` paths,
  no spaces in `src/` filenames); the I-0021 cleanup (delete
  commented-out dead code, remove/flag-guard `console.*` in the 18
  files, singleton change-logging off by default).
- **Out:** fixing what `qmllint` finds beyond formatting/dead code
  (private-API findings go to G05-T1; record them); the tests themselves
  (G04-T2).

## Plan

1. Add a `qmllint` configuration (settings file with the import paths of
   the G01 modules); run it over every module; triage output into (a)
   fix-here (format, unqualified access, dead code) and (b)
   record-for-G05 (`.impl`, etc.).
2. Do the I-0021 sweep per its §Suggested fix (steps 1–4).
3. Add pixi tasks + pre-commit hooks (default stages, not manual) + a CI
   job; add the grep gates as a small script (`tools/check_gates.sh` or
   Python) so local and CI runs are identical.
4. Flip the hooks/CI to **required** once green.

## Deliverables

- pixi tasks, pre-commit config with active stages, CI job, `tools` gate
  script, the I-0021 cleanup diff, and a recorded list of deferred
  qmllint findings for G05.

## Acceptance gates

- A commit violating ruff/qmllint/qmlformat is rejected locally
  (pre-commit) and in CI.
- `qmllint` + `qmlformat --check` green over all modules (with an
  explicit, minimal allowlist).
- I-0021 acceptance: only flag-guarded diagnostics remain (`grep` per
  the issue).
- The grep-gate script exits non-zero on a seeded violation (prove once
  in the PR, then revert).

## Review focus

The allowlist is minimal and justified line-by-line; hooks actually run
on commit (test with a deliberate violation); gate script consistent
between local and CI.

## Definition of done

I-0026 + I-0021 met and closed; deferred-findings list handed to G05-T1;
`status.yml` updated.
