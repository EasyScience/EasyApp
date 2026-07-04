# G01-T3: WASM build in CI (enable triggers, credential-free Qt, cheaper runner)

- **Class:** standard
- **Status:** ready (can run before T1 against the current qmake build;
  re-point at CMake after T1)
- **Depends:** — (hardens after G01-T1/T2)
- **Issues:**
  [I-0005](../../issues/open/I-0005-wasm-ci-dispatch-only.md)
- **Anchors:** `.github/workflows/wasm.yml`

## Goal

Make the WASM build run automatically on every PR and push so a
web-target regression turns CI red (the guard that was missing when
I-0001 shipped). Remove the Qt-account-credential install and move to a
cheap Linux runner.

## Scope

- **In:** enable `push`/`pull_request` triggers; switch Qt install to
  `jurplel/install-qt-action` (aqtinstall) with `target: wasm`; move to
  `ubuntu-latest`; fail the job if artifacts are missing or empty; keep
  the `webapp` deploy gated to `master`.
- **Out:** the CMake migration itself (T1/T2) — this task adapts
  whichever build exists; charts (G02).

## Plan

1. In `.github/workflows/wasm.yml`, replace the trigger block:
   ```yaml
   on:
     push: { branches: [master, develop] }
     pull_request: { branches: ['**'] }
     workflow_dispatch:
   ```
2. Replace the online-installer + `secrets.QT_ACCOUNT_*` steps with
   `jurplel/install-qt-action@v4` (`version: 6.9.*`, `target: wasm`,
   `arch: wasm_singlethread`, plus host Qt for tools) and set up emsdk
   (matching version per the existing comments). Move `runs-on` to
   `ubuntu-latest`.
3. Build step: keep `qmake -spec wasm-emscripten` **until** G01-T2
   lands, then switch to `qt-cmake --preset wasm && cmake --build`.
4. Add a smoke assertion after build: the expected `*.wasm` and `*.html`
   exist and are non-empty (extend the existing
   `if-no-files-found: error`). Optionally serve headless and check the
   page loads (once the smoke test from G04-T2 exists).
5. Keep the push-to-`webapp`-branch deploy step, but only
   `if: github.ref == 'refs/heads/master'`.
6. Mark the job **required** in branch protection.

## Deliverables

- Updated `wasm.yml` with automatic triggers, credential-free Qt, ubuntu
  runner, artifact assertion, gated deploy.

## Acceptance gates

- The `wasm` job runs on a PR and on push to `master`/`develop`, and is
  required for merge.
- A deliberately broken resource path (e.g. rename a file referenced by
  the manifest) **fails** the job — the regression guard for I-0001.
- No `QT_ACCOUNT_EMAIL`/`QT_ACCOUNT_PASSWORD` secrets are used.

## Test brief

Prove the guard: open a throwaway PR that breaks a manifest path and
confirm the job goes red; revert.

## Review focus

Deploy step correctly gated to `master` only; emsdk↔Qt version match;
the failure assertion actually fails on empty/missing artifacts (test
it).

## Definition of done

I-0005 acceptance met; `status.yml` G01-T3 → done.
