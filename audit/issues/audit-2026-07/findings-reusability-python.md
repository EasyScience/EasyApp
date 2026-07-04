# Findings — Reusability (library↔app entanglement) & Python backend

Backs **I-0006, I-0007, I-0008, I-0012, I-0022, I-0029**. Verdict: **the
"generic" library is wired to EasyDiffraction specifics and desktop-only
services; not yet reusable by a second app.**

## 1. App-specific taxonomy in the global singleton (I-0006)

`Gui/Globals/Vars.qml:61` — the app's _pages_ are an enum in the shared
singleton:

```qml
enum AppBarIndexEnum { HomePageIndex=0, ProjectPageIndex, SamplePageIndex,
                       ExperimentPageIndex, AnalysisPageIndex, SummaryPageIndex }
```

`:72` `ParamNameFormats` (diffraction parameter-naming) likewise. A
generic toolkit must not name another product's screens. The
app-bar/content machinery should be **data-driven** (host supplies a
page model).

## 2. Product name hard-coded in logging (I-0006, I-0022)

`Logic/Logging.py._getLevelFromSettings`:

```python
appName = 'EasyDiffraction'  # NEED FIX
...
settingsIniFilePath = str(homeDirPath.joinpath(f'.{appName}', 'settings.ini'))
```

Two `# NEED FIX` markers (hard-coded name; "Duplication from main.py").
The library reads _EasyDiffraction's_ settings file for any consumer.
Also `console = Logger()` at module scope does this **file read at
import time** → import side effects, hard to test/reuse. `__init__`
calls `_getLevelFromSettings()` twice.

## 3. Auto-updater embedded in the base window (I-0007)

`Gui/Elements/ApplicationWindow.qml`:

```qml
EaMaintenance.Updater { id: updater; Component.onCompleted: EaGlobals.Vars.updater = this }
Timer { interval: 2000; running: EaGlobals.Vars.checkUpdateOnAppStart
        onTriggered: { updater.silentCheck = true; updater.checkUpdate() } }
```

- three update dialogs. Backend `Logic/Maintenance.py` drives the **Qt
  Installer Framework** `MaintenanceTool` via `QProcess.startDetached`,
  and downloads from a hard-coded host
  `https://download.easydiffraction.org/onlineRepository/<OS>/CHANGELOG.md`.
  Desktop-only, product-specific, and inert/broken on WASM
  (`QProcess`/`urllib` can't run in the browser). Every consumer
  inherits a startup network call to EasyDiffraction. `Maintenance.py`
  also imports `QApplication` from **QtWidgets** into a QtQuick
  (`QGuiApplication`) app.

The coupling extends beyond the window (round 2):
`PreferencesDialog.qml:154-165` (the "Updates" group drives
`Vars.updater.checkUpdate()`), `:370` (a `Settings` alias persisting
`checkUpdateOnAppStart`), and `Globals/Vars.qml:45-46`
(`checkUpdateOnAppStart` + the `updater` holder) — all must move with
the updater.

## 4. Updater crash + redundant download (I-0008)

`Maintenance.py._getWebDate`:

```python
matches = re.findall(pattern, web_changelog)
web_date = matches[0]     # IndexError if empty/offline/reformatted — no guard, no try/except
```

`_onFinished` → `_getWebDate()` → `_getWebChangelog()` (network GET #1),
then `_getReleaseNotes()` → `_getWebChangelog()` again (GET #2, same
URL) + `_getAppChangelog()` (a **local** file read) → the web changelog
is downloaded **twice per check**. _(Round-2 correction: round 1
miscounted this as three network fetches.)_

## 5. Test/automation modules in the shipped library (I-0012)

`Gui/Elements/RemoteController.qml` (a tutorial/screencast harness,
shipped): `import QtTest` (`TestUtil`/`TestResult`/`TestEvent` —
synthesizes input, grabs screenshots), `import QtMultimedia` (`Audio`
narration), and ~200 lines of **vendored** Qt-private
`qtest_compareInternal`/`qtest_typeof`. Reads
`EaGlobals.Vars.projectConfig.ci.app.tutorials. video.fps` (more CI/app
config leaking in). Runtime now needs `QtTest`/`QtMultimedia`; both are
inappropriate/unavailable on WASM.

## 6. Translator wiring is inconsistent — and the only consumer is broken both ways (I-0029)

Two `Translator`s with incompatible constructors:

- `Gui/Logic/Translate.js` — used via `Vars.qml` fallback
  `new EaLogic.Translate.Translator()` (0 args). Its whole interface is
  `languagesAsXml()` (an XML-string relic for the commented-out
  `XmlListModel` approach, cf. `PreferencesDialog.qml:6`),
  `defaultLanguageIndex()` (function), `selectLanguage(index)` (no-op).
  It has **no `languages` member**.
- `Logic/Translate.py` —
  `Translator(app, engine, translations_path, languages)` (4 required
  args); `languages` and `defaultLanguageIndex` are `@Property`s.

The one consumer, `Components/PreferencesDialog.qml:305-308`, binds
`model: EaGlobals.Vars.translator.languages` and calls
`translator.defaultLanguageIndex()`:

- with the **JS fallback**: `languages` is `undefined` → empty language
  ComboBox;
- with the **Python translator**: `defaultLanguageIndex()` invokes a
  property as a function → runtime error.

And the example `main.py` files never construct/register the Python one
anyway → language switching is broken end-to-end today, under every
resolution. `Translate.py.selectDefaultLanguage` passes
`self.defaultLanguageIndex` (a `@Property`) into `selectLanguage` —
works, but subtle; pin with a test.

## Net

Decoupling (roadmap G03) is the gate for `edi` adopting the base: remove
page enums (host-supplied model), parameterise product identity
(injected `ApplicationInfo`), lift the updater and the tutorial/QtTest
harness out of the core, and fix the Maintenance parse/fetch bugs as
they move to the app.
