# Task packets

One-session units of work — **every task now has a full packet**
(round-2 improvement). Each packet names its issues, plan, deliverables,
and acceptance gates, and is written so a **less-advanced implementing
agent can follow it without extra context**. `status.yml` is
authoritative for status; this table mirrors it. `template.md` is the
blank.

**Class:** `design` (a decision precedes code — check
[decisions-to-confirm.md](../../design/decisions-to-confirm.md); A and B
are already ratified) · `standard` · `mechanical`. **Status:** `ready`
(pick these up) · `blocked` (waiting on a dependency) · `draft` (spec
present, promote when its dependency lands) · `active` · `done`.

## G01 — Web/WASM revival + CMake

| Task                                                              | Class           | Status       | Packet                                      |
| ----------------------------------------------------------------- | --------------- | ------------ | ------------------------------------------- |
| G01-T1 CMake `qt_add_qml_module` for core modules (Decision B ✅) | design→standard | ready        | [packet](G01-T1-cmake-core-modules.md)      |
| G01-T2 Migrate remaining modules; retire `.qrc`/`.pro`            | standard        | blocked (T1) | [packet](G01-T2-cmake-remaining-modules.md) |
| G01-T3 WASM build in CI                                           | standard        | ready        | [packet](G01-T3-wasm-ci.md)                 |
| G01-T4 Remove diverged variant + sync manifests + I-0033 stop-gap | mechanical      | ready        | [packet](G01-T4-manifest-cleanup.md)        |

## G02 — Render everywhere

| Task                                                                | Class           | Status        | Packet                                  |
| ------------------------------------------------------------------- | --------------- | ------------- | --------------------------------------- |
| G02-T1 Charting façade + native 1D backend (Decision A ✅ QtGraphs) | design→standard | blocked (G01) | [packet](G02-T1-charting-facade.md)     |
| G02-T2 2D/3D charts + report without WebEngine                      | standard        | blocked (T1)  | [packet](G02-T2-charts-2d-3d-report.md) |
| G02-T3 Settings façade, WASM-safe persistence                       | standard        | ready         | [packet](G02-T3-settings-facade.md)     |

## G03 — Decouple from EasyDiffraction

| Task                                                                    | Class    | Status | Packet                                       |
| ----------------------------------------------------------------------- | -------- | ------ | -------------------------------------------- |
| G03-T1 Data-driven app bar / page model                                 | design   | ready  | [packet](G03-T1-page-model.md)               |
| G03-T2 Inject `ApplicationInfo`; de-hardcode logging/settings           | standard | ready  | [packet](G03-T2-application-info.md)         |
| G03-T3 Lift the auto-updater to the app (incl. PreferencesDialog sites) | standard | ready  | [packet](G03-T3-extract-updater.md)          |
| G03-T4 Lift tutorial/QtTest harness out of core                         | standard | ready  | [packet](G03-T4-extract-tutorial-harness.md) |

## G04 — QML tooling & test pyramid

| Task                                                                      | Class    | Status           | Packet                               |
| ------------------------------------------------------------------------- | -------- | ---------------- | ------------------------------------ |
| G04-T1 `qmllint`+`qmlformat` gates; un-manual pre-commit; console cleanup | standard | blocked (G01-T1) | [packet](G04-T1-qml-gates.md)        |
| G04-T2 Qt Quick Test smoke-load + unit tests                              | standard | ready            | [packet](G04-T2-qml-test-pyramid.md) |
| G04-T3 Template/tooling framing (Decision C — ratify first)               | design   | draft            | [packet](G04-T3-template-framing.md) |

## G05 — Modern-Qt migration

| Task                                                                          | Class    | Status           | Packet                                  |
| ----------------------------------------------------------------------------- | -------- | ---------------- | --------------------------------------- |
| G05-T1 Replace/wrap private `QtQuick.Controls.impl` (21 files)                | standard | blocked (G04)    | [packet](G05-T1-retire-private-impl.md) |
| G05-T2 Unversioned imports; base-window rename; smells; JsonListModel de-eval | standard | blocked (G04-T2) | [packet](G05-T2-modernisation-batch.md) |
| G05-T3 HiDPI/sizing cleanup (FontMetrics, named tokens)                       | standard | draft            | [packet](G05-T3-hidpi-sizing.md)        |

## G06 — Packaging & distribution

| Task                                                               | Class           | Status         | Packet                                    |
| ------------------------------------------------------------------ | --------------- | -------------- | ----------------------------------------- |
| G06-T1 Dual distribution (CMake package + wheel) + `__main__` demo | design→standard | draft (G01-T2) | [packet](G06-T1-distribution-and-demo.md) |
| G06-T2 Prune fonts; drop numpy                                     | mechanical      | ready          | [packet](G06-T2-prune-fonts-deps.md)      |

## G07 — i18n & accessibility

| Task                                           | Class    | Status                | Packet                                   |
| ---------------------------------------------- | -------- | --------------------- | ---------------------------------------- |
| G07-T1 qsTr sweep + lupdate                    | standard | blocked (G03, G04-T2) | [packet](G07-T1-qstr-sweep.md)           |
| G07-T2 One canonical translator wired + tested | standard | blocked (T1)          | [packet](G07-T2-canonical-translator.md) |

## G08 — Docs, gallery & style guide

| Task                                                   | Class      | Status                | Packet                                    |
| ------------------------------------------------------ | ---------- | --------------------- | ----------------------------------------- |
| G08-T1 Gallery example (visual smoke)                  | standard   | blocked (G04-T2, G03) | [packet](G08-T1-gallery.md)               |
| G08-T2 Component catalog docs; knowledge into the site | standard   | draft (T1)            | [packet](G08-T2-catalog-docs.md)          |
| G08-T3 Publish & enforce the QML style guide           | standard   | ready                 | [packet](G08-T3-style-guide.md)           |
| G08-T4 Branding & docs-drift cleanup (I-0019/I-0032)   | mechanical | ready                 | [packet](G08-T4-branding-docs-cleanup.md) |

## G09 — edi handoff

| Task                                                            | Class  | Status               | Packet                          |
| --------------------------------------------------------------- | ------ | -------------------- | ------------------------------- |
| G09-T1 Semver + seam contract + beta→components migration guide | design | draft (G02/03/05/08) | [packet](G09-T1-edi-handoff.md) |

## Ready today (no dependencies)

`G01-T1` · `G01-T3` · `G01-T4` · `G02-T3` · `G03-T1` · `G03-T2` ·
`G03-T3` · `G03-T4` · `G04-T2` · `G06-T2` · `G08-T3` · `G08-T4` — twelve
tasks can start immediately, across independent files. The recommended
first two lanes: **G01-T1** (build beachhead) and **G03-T2** (decoupling
beachhead).
