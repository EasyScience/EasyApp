# I-0027: `numpy` is a hard runtime dependency of a QML component package with no obvious use

- **Status:** open
- **Priority:** Low
- **Area:** build
- **Targets:** desktop
- **Found:** 2026-07 GUI base audit
- **Related:** I-0018; milestone G06

## Problem

`pyproject.toml` lists `numpy` in `dependencies`
(`'numpy', # Scientific computing library`), but the library's Python
code (`Logging.py`, `Maintenance.py`, `Translate.py`, `Utils.py`) does
not import numpy. It appears to be an inherited default from the generic
scientific-Python-lib template (I-0018). It is also irrelevant to the
C++/WASM target (no Python there).

## Impact

- Unnecessary heavy dependency and larger install/wheel for consumers of
  a _GUI_ package; possible version-conflict surface for apps that pin
  numpy.

## Suggested fix

1. Confirm no runtime import: `grep -Rn "import numpy\|from numpy" src/`
   (expected: nothing).
2. Remove `numpy` from `[project].dependencies`. If a future component
   genuinely needs array math, add it back scoped to that component (or
   as an optional extra).
3. Keep `PySide6` as the one real runtime dependency for the
   desktop-Python path.

## Acceptance criteria

- `numpy` is not a hard dependency unless a real import justifies it.
- The example apps still run after removal.
