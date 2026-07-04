# I-0021: Leftover `console.*` logging and commented-out dead code in QML

- **Status:** open
- **Priority:** Low
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0026 (a lint gate prevents recurrence); milestone G04

## Problem

- 18 QML files contain `console.log/debug/error(...)` calls, several
  commented out (e.g. `Button.qml` has `//console.error(...)` dead
  code).
- `print()` debug calls and large commented-out blocks appear in
  `RemoteController.qml` and others.
- `Colors.qml`/`Vars.qml` singletons emit `console.debug` on every
  property change (`onThemeChanged`, `onSystemColorSchemeChanged`,
  `onIsDarkPaletteChanged`, `onLoggingLevelChanged`) — chatty logs in a
  shipped library.

## Impact

- Console noise in production; dead code obscures intent; per-change
  debug logging in singletons is spammy and mildly costly.

## Suggested fix

1. Remove commented-out dead code.
2. Route intentional diagnostics through the project logger at an
   appropriate level (or a `Qt.createQmlObject`-free debug flag), not
   raw `console.*`; delete incidental `console.*`.
3. Keep singleton change-logging behind a debug flag, off by default.
4. Add a `qmllint`/grep gate (I-0026) flagging new `console.log`/`print`
   in `src/`.

## Acceptance criteria

- `grep -R "console\.\(log\|debug\|error\)\|[^A-Za-z]print(" src/`
  returns only intentional, flag-guarded diagnostics.
- No commented-out dead code blocks remain in the touched files.
