# Milestone 03 — Decouple the library from EasyDiffraction

- **Phase:** I · **Priority:** 5/5 · **Status:** planned · **Depends:**
  —
- **Bundles:**
  [I-0006](../issues/open/I-0006-app-specifics-baked-into-library.md),
  [I-0022](../issues/open/I-0022-logging-import-side-effects.md),
  [I-0007](../issues/open/I-0007-updater-embedded-in-base-window.md),
  [I-0008](../issues/open/I-0008-maintenance-indexerror-double-fetch.md),
  [I-0012](../issues/open/I-0012-qttest-qtmultimedia-in-shipped-lib.md)
- **Tasks:** [G03-T1](../roadmap/tasks/G03-T1-page-model.md) ·
  [G03-T2](../roadmap/tasks/G03-T2-application-info.md) ·
  [G03-T3](../roadmap/tasks/G03-T3-extract-updater.md) · G03-T4 (follow
  I-0012)

## Why

The library calls itself generic but hard-wires EasyDiffraction: its
global singleton names the science app's pages, its logger reads
`~/.EasyDiffraction/settings.ini`, its base window auto-checks
EasyDiffraction's servers for updates, and a `QtTest`-driven tutorial
harness ships inside it. `edi` cannot adopt this base without inheriting
all of it. Decoupling is a **prerequisite**, not a nicety — and it can
run in parallel with G01 (different files).

## Definition of done

1. `Gui/Globals/Vars.qml` has no app-page enum and no param-name-format
   enum; the app bar/content render pages from a **host-supplied model**
   (G03-T1).
2. No product-name literal anywhere in `src/`
   (`grep -Rin easydiffraction src/` → ∅, CI-enforced); logging/settings
   identity is injected via `ApplicationInfo`; importing `Logging` does
   no file I/O (G03-T2).
3. The base `ApplicationWindow` has no updater/network/`QProcess`;
   update-checking is an optional host service; the EDI updater (with
   the I-0008 crash/fetch fixes) lives in the app (G03-T3).
4. No `QtTest`/`QtMultimedia` in the shipped library; the tutorial
   harness is relocated or reimplemented without test modules (G03-T4).

## Sequence

`G03-T1`, `G03-T2`, `G03-T3`, `G03-T4` are largely independent; T1/T3
both touch the window files, so sequence those (and coordinate with the
I-0028 rename in G05). All can run in parallel with G01.

## Explicitly deferred

- Moving diffraction-specific _screens_ into the app entirely (can be
  incremental after the seams exist).
- The i18n/translator cleanup (**G07**) and docs of the new seams
  (**G08**).

## Success criteria

- A **second** example app (not EasyDiffraction) runs on the base: it
  declares its own pages, uses its own settings namespace, makes no
  startup network call, and needs no `QtTest` module.
- CI greps prove no
  `easydiffraction`/`QProcess`/`download.easydiffraction.org`/`import QtTest`
  in `src/`.
