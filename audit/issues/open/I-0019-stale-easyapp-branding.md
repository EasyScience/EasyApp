# I-0019: Stale `EasyApp` branding and paths across the examples

- **Status:** open
- **Priority:** Low
- **Area:** docs
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0001, I-0020; milestone G08

## Problem

After the `EasyApp` → `EasyApplication` rename, the examples still carry
the old identity:

- SPDX headers: `// SPDX-FileCopyrightText: 2024 EasyApp contributors`
  and
  `© 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>`
  across many example files.
- A live link
  `Qt.openUrlExternally('https://github.com/EasyScience/EasyApp')`
  (`examples/BasicPy/.../Home/Content.qml`).
- `.pro` path `../../../src/EasyApp` (also I-0001).
- Copyright year/owner inconsistency: library files say
  `2026 EasyScience contributors`, examples say
  `2024 EasyApp contributors`, `main.cpp` says `EasyApp project`.

## Impact

- Confusing provenance; a dead/renamed GitHub link; inconsistent
  copyright. Low functional impact but poor polish for a base others
  will copy.

## Suggested fix

1. Normalise SPDX headers to the current owner/year across `examples/`
   (the repo has `tools/license_headers.py` — extend/run it over
   examples too).
2. Fix the `github.com/…/EasyApp` URL to the current repo.
3. Fix the `.pro` path (with I-0001).
4. Add the SPDX/license-header check to CI for `examples/` too.

## Acceptance criteria

- `grep -Rn "EasyApp\b" examples/ | grep -v EasyApplication` returns
  nothing.
- License-header check passes over `examples/` in CI.
