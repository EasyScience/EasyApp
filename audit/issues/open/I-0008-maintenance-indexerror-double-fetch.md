# I-0008: `Maintenance.py._getWebDate()` can `IndexError`; the web changelog is downloaded twice per check

- **Status:** open
- **Priority:** High
- **Area:** python
- **Targets:** desktop
- **Found:** 2026-07 GUI base audit
- **Related:** I-0007 (this code should move to the app); milestone M03

## Problem

In `Logic/Maintenance.py`:

```python
def _getWebDate(self):
    web_changelog = self._getWebChangelog()
    pattern = r'^# Version .*? \(([A-Za-z0-9\s]*)\)'
    matches = re.findall(pattern, web_changelog)
    web_date = matches[0]      # ← no guard: IndexError if no match / empty / offline
    return web_date
```

`matches[0]` runs with no check. If the download fails, the changelog
format changes, or the file is empty, `re.findall` returns `[]` and this
raises `IndexError`, aborting the update flow with an uncaught exception
(the surrounding `_onFinished` has no try/except around `_getWebDate`).

Separately, one update check downloads the **web changelog twice**:
`_onFinished` first calls `_getWebDate()` → `_getWebChangelog()`
(network GET #1), then `_getReleaseNotes()` → `_getWebChangelog()` again
(network GET #2, same URL) plus `_getAppChangelog()` (a **local** file
read). Two network round-trips to the same URL per check.

Also: the module imports `QApplication` from `QtWidgets` for a QtQuick
(`QGuiApplication`) app, pulling in the entire widgets stack
unnecessarily.

## Impact

- A transient network failure or an upstream changelog reformat crashes
  the updater instead of showing "no updates / update failed". Users on
  flaky networks hit it.
- The redundant download doubles the network latency and bandwidth of
  every check.

## Suggested fix

1. Guard the parse:
   ```python
   matches = re.findall(pattern, web_changelog)
   if not matches:
       console.debug('No version-date found in web changelog')
       return ''
   return matches[0]
   ```
2. Download the web changelog **once** per check: fetch it in
   `_onFinished`, pass the text into `_getWebDate(web_changelog)` and
   `_getReleaseNotes(web_changelog)` instead of re-downloading.
   (`_getAppChangelog()` is a local read and can stay as is.)
3. Replace `from PySide6.QtWidgets import QApplication` with
   `QCoreApplication`/`QGuiApplication` (use
   `QCoreApplication.applicationDirPath()`, `QGuiApplication.quit()`),
   dropping the widgets dependency.
4. When this code moves to the app under I-0007, carry these fixes with
   it.

## Acceptance criteria

- With the network unreachable or an unparseable changelog, an update
  check ends in the "failed"/"no updates" path with **no traceback**
  (add a unit test that feeds an empty/garbage changelog and asserts no
  exception).
- A single update check performs at most one GET to the web changelog
  URL.
- `Maintenance.py` no longer imports `QtWidgets`.
