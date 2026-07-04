# I-0031: `JsonListModel` vendors a 2007 `eval()`-based JSONPath implementation

- **Status:** open
- **Priority:** Low
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit (round 2)
- **Related:** I-0011 (same modernisation batch); milestone G05

## Problem

`Gui/Components/JsonListModel.qml` is a `ListModel` that fills itself
from JSON. Inside it is a **vendored copy of Stefan Goessner's 2007
JSONPath** (headers cite 2007/2012, the Qt wiki and two archived GitHub
repos). Its `P.eval` uses JavaScript **`eval()`** on rewritten query
expressions — three sites: `JsonListModel.qml:112`, `:114`, `:148`:

```js
eval: function(x, _v, _vname) {
   try { return $ && _v && eval(x.replace(/(^|[^\\])@/g, "$1_v")...); }
   ...
```

Additional smells in the same file: `updateJson()` loads `source` via a
raw `XMLHttpRequest` with no error/status handling (`:39-48` — a network
failure silently leaves stale/empty json), and the `status` property is
set to `Updating`/`Ready` but never `Error`.

## Impact

- `eval()` blocks ahead-of-time QML compilation (`qmlsc`) for this file
  and is a needless code-injection surface if a query string is ever
  derived from data.
- The vendored library is 18+ years old and unmaintained; nobody should
  debug JSONPath slicing semantics inside a GUI toolkit.
- Silent XHR failures make data binding flaky with no diagnosis.

## Suggested fix

1. Survey actual usage (grep the consumers in this repo and
   `easydiffractionbeta`): in practice the queries used are trivial
   (`$[*]`, a single key path). If so, replace the JSONPath engine with
   `JSON.parse` + a small explicit path-walk helper (~20 lines, no
   `eval`).
2. If a real JSONPath need exists, implement the used subset without
   `eval` — do not upgrade the vendored library.
3. Add error handling to `updateJson()` (set
   `status = JsonListModel.Error` on non-200/exception, log via the
   project logger).
4. Add a Qt Quick Test: JSON in → model rows out; bad JSON → `Error`
   status, no throw.

## Acceptance criteria

- `grep -n "eval(" src/EasyApplication/Gui/Components/JsonListModel.qml`
  → nothing.
- Existing consumers render identical rows (test with a representative
  JSON fixture).
- A failed `source` load sets `status` to `Error` (unit-tested) instead
  of silently doing nothing.
