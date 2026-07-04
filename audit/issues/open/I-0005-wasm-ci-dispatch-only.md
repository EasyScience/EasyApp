# I-0005: WASM CI is `workflow_dispatch`-only → the web target is unprotected

- **Status:** open
- **Priority:** High
- **Area:** ci
- **Targets:** web
- **Found:** 2026-07 GUI base audit
- **Related:** I-0001 (shipped _because_ of this gap), I-0004, I-0010;
  milestone G01

## Problem

`.github/workflows/wasm.yml` only triggers on `workflow_dispatch` — the
`push:` and `schedule:` triggers are commented out:

```yaml
on:
  workflow_dispatch:
  #push:
  #schedule:
  #  - cron: '*/120 8-18 * * *'
```

So the WASM build never runs automatically. Combined with zero tests
(I-0010), nothing catches a web-target regression. This is exactly why
the `src/EasyApp` rename (I-0001) broke the WASM build with no signal.

Secondary weaknesses in the same workflow:

- It builds only on `macos-14` (an emscripten build is host-independent;
  `ubuntu-latest` is cheaper/faster).
- It installs Qt via the **Qt online installer with account
  credentials** (`secrets.QT_ACCOUNT_EMAIL`/`QT_ACCOUNT_PASSWORD`) —
  slow and brittle; `jurplel/install-qt-action` (aqtinstall) is the
  standard, credential-free approach.
- It uses `qmake -spec wasm-emscripten` (ties the web target to the
  deprecated build — see I-0004).

## Impact

- The web app can break at any commit and stay broken indefinitely (it
  did). No agent or human gets a red check.
- `edi` will copy this workflow; the gap propagates.

## Suggested fix

1. Enable automatic triggers:
   ```yaml
   on:
     push:
       branches: [master, develop]
     pull_request:
       branches: ['**']
     workflow_dispatch:
   ```
2. Switch Qt installation to `jurplel/install-qt-action` with
   `target: wasm` (drops the Qt account secrets); move the build to
   `ubuntu-latest`. While there, **drop the vestigial `addons.qt5compat`
   install** — nothing in `src/` or `examples/` imports `Qt5Compat`
   (verified: `grep -rn "Qt5Compat|GraphicalEffects"` → no QML hits).
3. After I-0004, build with `qt-cmake`/CMake instead of `qmake`.
4. Make the job **fail** if the built `.wasm`/`.html` artifacts are
   missing or empty (there is already `if-no-files-found: error` on the
   upload — extend that to a real smoke assertion once a headless check
   exists, see I-0010).
5. Keep the `push-to-webapp-branch` deploy step gated to `master` only.

## Acceptance criteria

- The `wasm` job runs on every PR and on push to `master`/`develop`, and
  is required for merge.
- A deliberately broken resource path fails the job (regression guard
  for I-0001).
- Qt is installed without account credentials.
