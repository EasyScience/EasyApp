# M03-T2: Inject `ApplicationInfo`; de-hardcode the logging/settings identity

- **Class:** standard
- **Status:** ready
- **Depends:** — (coordinate with M03-T1 and M02-T3 on the settings
  namespace)
- **Issues:**
  [I-0006](../../issues/open/I-0006-app-specifics-baked-into-library.md)
  (product-name half),
  [I-0022](../../issues/open/I-0022-logging-import-side-effects.md)
- **Anchors:**
  [findings-reusability-python.md §2](../../issues/audit-2026-07/findings-reusability-python.md)

## Goal

Remove every product-name literal from the library. The host app injects
its identity (organization, application name, settings namespace) once
at startup via an `ApplicationInfo` object; logging and settings derive
their paths/namespaces from it. Importing `Logging` performs no
filesystem I/O.

## Scope

- **In:** an `ApplicationInfo` seam (a QML singleton and/or a Python
  object set in `main`); route `Logging.py`'s settings path and any
  `appName` through it; remove import-time `QSettings` I/O and the
  duplicated `_getLevelFromSettings` call; delete the `EasyDiffraction`
  literal and the two `# NEED FIX` markers.
- **Out:** the updater move (M03-T3); the page model (M03-T1).

## Plan

1. Define `ApplicationInfo` (fields: `organization`, `applicationName`,
   `settingsNamespace`, `version`, `changelogUrl?`). The example's
   `main.py`/`main.cpp` sets it before the engine loads QML; expose it
   to QML (registered singleton / context) and to the Python logger.
2. `Logging.py`: stop reading settings at import. Construct `console`
   without I/O; configure its level explicitly from `main` (pass the
   level in) or lazily from injected `ApplicationInfo`. Remove the
   duplicate `self._getLevelFromSettings()` call. Guard the settings
   read against missing file / non-string.
3. Replace `appName = 'EasyDiffraction'` with
   `ApplicationInfo.applicationName`; derive the settings path from
   `settingsNamespace` (coordinate with M02-T3 so desktop and WASM
   agree).
4. CI grep gate (shared with M03-T1): no
   `EasyDiffraction`/`easydiffraction` in `src/`.

## Deliverables

- `ApplicationInfo` seam; `Logging.py` with no import I/O and no product
  literal; example wiring.

## Acceptance gates

- `grep -Rin "easydiffraction" src/` → nothing; the `# NEED FIX`
  comments are gone.
- Importing `Logging` touches no filesystem (unit test: import with no
  `~/.*` file present → no I/O, no exception).
- Running a **second** example under a different app name uses _its own_
  settings file/namespace (proves the identity is injected, not baked).

## Test brief

Unit: `Logging` import is side-effect-free; level configuration is
explicit. Functional: two apps with different `ApplicationInfo` get
different settings namespaces.

## Review focus

No product literal anywhere in `src/`; settings namespace single-sourced
(M02-T3 alignment); logger still colourises/formats as before.

## Definition of done

I-0006 (product-name half) + I-0022 met; `status.yml` M03-T2 → done.
