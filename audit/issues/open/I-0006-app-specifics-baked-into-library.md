# I-0006: App-specific concepts hard-wired into the "generic" component library

- **Status:** open
- **Priority:** High
- **Area:** reusability
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0007, I-0022; milestone M03; evidence
  [findings-reusability-python.md](../audit-2026-07/findings-reusability-python.md)

## Problem

`gui-components` is meant to be a **generic** GUI base reused by
multiple apps (beta today, `edi` next). But EasyDiffraction/app-specific
knowledge is compiled into it:

- **Page taxonomy in the global singleton.** `Gui/Globals/Vars.qml:61`
  defines
  ```qml
  enum AppBarIndexEnum { HomePageIndex, ProjectPageIndex, SamplePageIndex,
                         ExperimentPageIndex, AnalysisPageIndex, SummaryPageIndex }
  ```
  These are the _pages of a diffraction app_, not a property of a
  generic toolkit. Same file also bakes in `ParamNameFormats`
  (parameter-naming conventions specific to the science app).
- **Hard-coded product name in logging.**
  `Logic/Logging.py:_getLevelFromSettings` sets
  `appName = 'EasyDiffraction'  # NEED FIX` and builds the settings path
  from it — the library reads _EasyDiffraction's_ settings file. The
  author flagged it `# NEED FIX` twice.
- App-specific dialogs (`ProjectDescriptionDialog`, a "Summary/Report"
  pipeline) live in `Components/` alongside truly generic ones.

## Impact

- A second app (`edi`) cannot use the library without inheriting
  EasyDiffraction's page names and settings namespace, or forking the
  singleton. That defeats the purpose of a shared base and guarantees
  divergence.
- The `# NEED FIX` settings path means logging level is read from the
  wrong file for any non-EDI app, so the library's own logging is
  misconfigured out of the box elsewhere.

## Suggested fix

1. **Move app taxonomy out of the library.** Delete `AppBarIndexEnum`
   and `ParamNameFormats` from `Vars.qml`. The generic app-bar/tab
   machinery should be **data-driven**: the consuming app supplies a
   list/model of pages (title, icon, component) to a generic
   `AppBar`/`ContentArea` API; the library holds _no_ named pages.
   Provide the page model as a required property on the
   `Components.ApplicationWindow` (see
   [architecture-target.md](../../design/architecture-target.md)).
2. **Parameterise the product identity.** Replace
   `appName = 'EasyDiffraction'` with a value the host injects once at
   startup (e.g. an `ApplicationInfo` singleton with `organization`,
   `applicationName`, set by the app's `main`), and derive the settings
   path/namespace from it. The library must contain **no product name
   literals**.
3. **Split generic vs app-specific components.** Keep truly reusable
   pieces in `Components/`; move diffraction-specific screens/dialogs to
   the consuming app (beta / `edi`), or behind an opt-in "recipes"
   subfolder clearly marked non-core.
4. Add a lint/grep gate (CI) that fails if `EasyDiffraction`,
   `easydiffraction`, or app page names reappear in `src/`.

## Acceptance criteria

- `grep -Rin "easydiffraction" src/` returns nothing (case-insensitive),
  enforced in CI.
- `Vars.qml` contains no app-page enum; the app bar/content area render
  pages from a host-supplied model, demonstrated by an example app that
  names its own pages.
- The logging/settings namespace is set from host-injected
  `ApplicationInfo`, verified by running a second example under a
  different app name and seeing its own settings file used.
