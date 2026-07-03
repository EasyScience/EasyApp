# M03-T3: Lift the auto-updater out of the base window into the app

- **Class:** standard
- **Status:** ready
- **Depends:** — (touches the same files as M03-T1/I-0028; sequence to
  avoid conflicts)
- **Issues:**
  [I-0007](../../issues/open/I-0007-updater-embedded-in-base-window.md),
  [I-0008](../../issues/open/I-0008-maintenance-indexerror-double-fetch.md)
- **Anchors:**
  [findings-reusability-python.md §3–4](../../issues/audit-2026-07/findings-reusability-python.md)

## Goal

Make the base `ApplicationWindow` free of updater/network/`QProcess`
code. Update-checking becomes an **optional, host-provided** service
(the library ships none and hard-codes no URL). Move the EDI updater
into the consuming app, carrying the crash/redundant-fetch fixes.

## Scope

- **In:** remove the `Updater`, the startup `Timer`, and the three
  update dialogs from `Elements/ApplicationWindow.qml`; define a minimal
  optional hook (host may assign an `updateService`); move
  `Logic/Maintenance.py` + `Logic/Maintenance/Updater.qml` to the app
  (beta/`edi`) and apply the I-0008 fixes there.
- **Out:** the base-window rename (I-0028/M05) — but coordinate since
  both edit this file.

## Plan

1. Delete the `Updater{}`, update `Timer`, and
   `updateFound/NotFound/Failed` dialogs from
   `Elements/ApplicationWindow.qml`. Remove `import …Maintenance` there.
2. Add an optional seam: e.g. `property var updateService: null` on the
   app shell; if the host sets one, the host also owns the dialogs. The
   library provides no default and no URL.
3. Move `Maintenance.py`/`Updater.qml` into the app tree. While moving,
   apply I-0008: guard `matches[0]`; fetch the web changelog once per
   check; drop the `QtWidgets` import
   (`QGuiApplication`/`QCoreApplication`).
4. Guard any residual update UI behind
   `Qt.platform.pluginName !== "wasm"`.
5. Confirm a minimal example runs with **no** startup network call.

## Deliverables

- Updater-free base window; optional host `updateService` seam; updater
  relocated to the app with the parse/fetch fixes.

## Acceptance gates

- `grep -R "download.easydiffraction.org\|MaintenanceTool\|QProcess\|import .*Maintenance" src/`
  → nothing in the library.
- A minimal example app starts with no network activity (no update
  check).
- The relocated updater: an empty/garbage changelog produces no
  traceback (unit test); at most one GET per check; no `QtWidgets`
  import.

## Test brief

Unit (relocated updater): empty changelog → no exception; single fetch.
Smoke: base window loads with no updater present; WASM build has no
update code.

## Review focus

No network on the base path; the optional seam doesn't reintroduce a
default URL; the moved code's fixes are actually applied (not just
relocated).

## Definition of done

I-0007 + I-0008 met; `status.yml` M03-T3 → done.
