# I-0014: `python -m EasyApplication` / `pixi run EasyApplication` is broken (no `__main__.py`)

- **Status:** open
- **Priority:** Low
- **Area:** python
- **Targets:** desktop
- **Found:** 2026-07 GUI base audit
- **Related:** I-0025; milestone M06

## Problem

`pixi.toml` defines a "Main Package Shortcut":
`EasyApplication = 'python -m EasyApplication'`. But the package has no
`__main__.py` (`src/EasyApplication/__init__.py` is only an SPDX
header), so `python -m EasyApplication` fails with "No module named
EasyApplication.**main**". The advertised entry point does nothing.

## Impact

- A documented run command is broken; a newcomer following it hits an
  error. Minor, but it signals the package has no runnable demo of its
  own.

## Suggested fix

Decide what the shortcut should do, then either:

1. **Add a `src/EasyApplication/__main__.py`** that launches a minimal
   demo/gallery window (ties to the gallery in I-0025) — best, gives the
   library a self-demo; or
2. Remove the `EasyApplication` pixi task if no entry point is intended,
   and document that the library is consumed by apps, not run directly.

## Acceptance criteria

- `pixi run EasyApplication` either launches a working demo window or
  the task is removed and the docs reflect that.
