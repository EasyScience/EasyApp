# I-0007: Qt-Installer auto-updater embedded in the base `ApplicationWindow` and the library

- **Status:** open
- **Priority:** High
- **Area:** reusability
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0006, I-0008; milestone G03; evidence
  [findings-reusability-python.md](../audit-2026-07/findings-reusability-python.md)

## Problem

The base window element (`Gui/Elements/ApplicationWindow.qml`)
instantiates an auto-updater and fires a network check 2 s after every
launch:

```qml
EaMaintenance.Updater { id: updater; … Component.onCompleted: EaGlobals.Vars.updater = this }
Timer { interval: 2000; running: EaGlobals.Vars.checkUpdateOnAppStart
        onTriggered: { updater.silentCheck = true; updater.checkUpdate() } }
```

plus three update dialogs (found/not-found/failed). The backend
(`Logic/Maintenance.py`) drives the **Qt Installer Framework**
`MaintenanceTool` via `QProcess.startDetached` and downloads a changelog
from a **hard-coded EasyDiffraction URL**
(`https://download.easydiffraction.org/onlineRepository/<OS>/CHANGELOG.md`).

The coupling also reaches the preferences UI and the global singleton:
`Components/PreferencesDialog.qml:154-165` (the "Updates" group binds
`EaGlobals.Vars.checkUpdateOnAppStart` and calls
`EaGlobals.Vars.updater.checkUpdate()`), `PreferencesDialog.qml:370` (a
`Settings` alias persisting the check-on-start flag), and
`Globals/Vars.qml:45-46` (`checkUpdateOnAppStart`,
`property var updater`).

Problems this creates:

- **Desktop-only and product-specific** logic in the _base_ window:
  `QProcess`, an installer binary path per-OS, and an EasyDiffraction
  download host. None of it applies to a generic toolkit or another app.
- **Meaningless/broken on WASM:** a web app cannot spawn
  `MaintenanceTool` or self-update; the `QProcess`/`urllib` code cannot
  run in the browser at all.
- Every app built on the base inherits a startup network call to
  EasyDiffraction's servers.

## Impact

- `edi` (and any other consumer) gets an involuntary update-check to
  EasyDiffraction's infrastructure, or must rip the updater out of the
  base window — again defeating reuse.
- The base window pulls in `QtWidgets` (via `Maintenance.py`) and a
  networking/process stack that a web target cannot honour, so the base
  window is not portable across targets.

## Suggested fix

1. **Remove the updater from the base window and the singleton.**
   `Elements/ApplicationWindow.qml` and
   `Components/ApplicationWindow.qml` must contain no `Updater`, no
   update `Timer`, and no update dialogs; delete `updater` and
   `checkUpdateOnAppStart` from `Globals/Vars.qml`; move the "Updates"
   group out of `PreferencesDialog.qml` (`:154-165`, `:370`) — the host
   app that opts in provides its own preferences entry.
2. **Make updates an opt-in, host-provided plugin.** Expose a minimal,
   optional hook (e.g. the app can assign an `updateService` object with
   a `checkForUpdates()` method and bind the three dialogs itself). The
   _library_ ships no default implementation and no download URL.
3. **Keep the EDI updater in the app**, not the toolkit: move
   `Maintenance.py` + `Updater.qml` into the consuming app (beta /
   `edi`) where the EasyDiffraction URL and `MaintenanceTool`
   assumptions belong.
4. Guard any remaining update UI behind
   `Qt.platform.pluginName !== "wasm"`.

## Acceptance criteria

- The base `ApplicationWindow` (both variants) has no
  updater/network/`QProcess` code; a minimal example app runs with no
  startup network call.
- `grep -R "download.easydiffraction.org\|MaintenanceTool\|QProcess\|Vars.updater\|checkUpdateOnAppStart" src/`
  returns nothing in the library.
- Update-checking, if present, is injected by the host app and is absent
  on the WASM target.
