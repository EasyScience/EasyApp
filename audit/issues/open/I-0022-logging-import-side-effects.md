# I-0022: `Logging.py` does `QSettings` file I/O at import and duplicates settings logic

- **Status:** open
- **Priority:** Medium
- **Area:** python
- **Targets:** desktop
- **Found:** 2026-07 GUI base audit
- **Related:** I-0006 (the hard-coded `EasyDiffraction` app name lives
  here); milestone M03

## Problem

`Logic/Logging.py` ends with a module-level:

```python
console = Logger()
```

`Logger.__init__` calls `self._getLevelFromSettings()`, which opens a
`QSettings` file (`~/.EasyDiffraction/settings.ini`) and reads a value —
so **importing the module performs disk I/O and depends on a specific
app name**. `_getLevelFromSettings` is also called twice in `__init__`
(once directly, once via `self._level = self._getLevelFromSettings()`),
and it carries two `# NEED FIX` comments noting the
`appName = 'EasyDiffraction'` hard-code and duplication from `main.py`.

## Impact

- Import-time side effects make the module hard to test and reuse (any
  importer pays the file read; the path is EDI-specific — see I-0006).
- The redundant call and the `# NEED FIX` markers are self-acknowledged
  debt.

## Suggested fix

1. **Remove I/O from import.** Construct the logger lazily or configure
   it explicitly from the app's `main` (pass the desired level in),
   rather than reading settings at module load. A module-level `console`
   object is fine; reading a settings file at import is not.
2. Take the app name / settings namespace from the injected
   `ApplicationInfo` (I-0006), not a literal.
3. Remove the duplicated `_getLevelFromSettings()` call in `__init__`.
4. Guard the settings read (missing file / non-string value) so it can't
   throw.

## Acceptance criteria

- Importing `Logging` performs no filesystem access; a unit test imports
  it with no `~/.*` file present and observes no I/O and no exception.
- No `EasyDiffraction` literal remains (shared with I-0006); the
  `# NEED FIX` comments are gone.
