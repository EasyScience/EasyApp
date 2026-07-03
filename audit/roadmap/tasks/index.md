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

## M01 — Web/WASM revival + CMake

| Task                                                              | Class           | Status       | Packet                                      |
| ----------------------------------------------------------------- | --------------- | ------------ | ------------------------------------------- |
| M01-T1 CMake `qt_add_qml_module` for core modules (Decision B ✅) | design→standard | ready        | [packet](M01-T1-cmake-core-modules.md)      |
| M01-T2 Migrate remaining modules; retire `.qrc`/`.pro`            | standard        | blocked (T1) | [packet](M01-T2-cmake-remaining-modules.md) |
| M01-T3 WASM build in CI                                           | standard        | ready        | [packet](M01-T3-wasm-ci.md)                 |
| M01-T4 Remove diverged variant + sync manifests + I-0033 stop-gap | mechanical      | ready        | [packet](M01-T4-manifest-cleanup.md)        |

## M02 — Render everywhere

| Task                                                                | Class           | Status        | Packet                                  |
| ------------------------------------------------------------------- | --------------- | ------------- | --------------------------------------- |
| M02-T1 Charting façade + native 1D backend (Decision A ✅ QtGraphs) | design→standard | blocked (M01) | [packet](M02-T1-charting-facade.md)     |
| M02-T2 2D/3D charts + report without WebEngine                      | standard        | blocked (T1)  | [packet](M02-T2-charts-2d-3d-report.md) |
| M02-T3 Settings façade, WASM-safe persistence                       | standard        | ready         | [packet](M02-T3-settings-facade.md)     |

## M03 — Decouple from EasyDiffraction

| Task                                                                    | Class    | Status | Packet                                       |
| ----------------------------------------------------------------------- | -------- | ------ | -------------------------------------------- |
| M03-T1 Data-driven app bar / page model                                 | design   | ready  | [packet](M03-T1-page-model.md)               |
| M03-T2 Inject `ApplicationInfo`; de-hardcode logging/settings           | standard | ready  | [packet](M03-T2-application-info.md)         |
| M03-T3 Lift the auto-updater to the app (incl. PreferencesDialog sites) | standard | ready  | [packet](M03-T3-extract-updater.md)          |
| M03-T4 Lift tutorial/QtTest harness out of core                         | standard | ready  | [packet](M03-T4-extract-tutorial-harness.md) |

## M04 — QML tooling & test pyramid

| Task                                                                      | Class    | Status           | Packet                               |
| ------------------------------------------------------------------------- | -------- | ---------------- | ------------------------------------ |
| M04-T1 `qmllint`+`qmlformat` gates; un-manual pre-commit; console cleanup | standard | blocked (M01-T1) | [packet](M04-T1-qml-gates.md)        |
| M04-T2 Qt Quick Test smoke-load + unit tests                              | standard | ready            | [packet](M04-T2-qml-test-pyramid.md) |
| M04-T3 Template/tooling framing (Decision C — ratify first)               | design   | draft            | [packet](M04-T3-template-framing.md) |

## M05 — Modern-Qt migration

| Task                                                                          | Class    | Status           | Packet                                  |
| ----------------------------------------------------------------------------- | -------- | ---------------- | --------------------------------------- |
| M05-T1 Replace/wrap private `QtQuick.Controls.impl` (21 files)                | standard | blocked (M04)    | [packet](M05-T1-retire-private-impl.md) |
| M05-T2 Unversioned imports; base-window rename; smells; JsonListModel de-eval | standard | blocked (M04-T2) | [packet](M05-T2-modernisation-batch.md) |
| M05-T3 HiDPI/sizing cleanup (FontMetrics, named tokens)                       | standard | draft            | [packet](M05-T3-hidpi-sizing.md)        |

## M06 — Packaging & distribution

| Task                                                               | Class           | Status         | Packet                                    |
| ------------------------------------------------------------------ | --------------- | -------------- | ----------------------------------------- |
| M06-T1 Dual distribution (CMake package + wheel) + `__main__` demo | design→standard | draft (M01-T2) | [packet](M06-T1-distribution-and-demo.md) |
| M06-T2 Prune fonts; drop numpy                                     | mechanical      | ready          | [packet](M06-T2-prune-fonts-deps.md)      |

## M07 — i18n & accessibility

| Task                                           | Class    | Status                | Packet                                   |
| ---------------------------------------------- | -------- | --------------------- | ---------------------------------------- |
| M07-T1 qsTr sweep + lupdate                    | standard | blocked (M03, M04-T2) | [packet](M07-T1-qstr-sweep.md)           |
| M07-T2 One canonical translator wired + tested | standard | blocked (T1)          | [packet](M07-T2-canonical-translator.md) |

## M08 — Docs, gallery & style guide

| Task                                                   | Class      | Status                | Packet                                    |
| ------------------------------------------------------ | ---------- | --------------------- | ----------------------------------------- |
| M08-T1 Gallery example (visual smoke)                  | standard   | blocked (M04-T2, M03) | [packet](M08-T1-gallery.md)               |
| M08-T2 Component catalog docs; knowledge into the site | standard   | draft (T1)            | [packet](M08-T2-catalog-docs.md)          |
| M08-T3 Publish & enforce the QML style guide           | standard   | ready                 | [packet](M08-T3-style-guide.md)           |
| M08-T4 Branding & docs-drift cleanup (I-0019/I-0032)   | mechanical | ready                 | [packet](M08-T4-branding-docs-cleanup.md) |

## M09 — edi handoff

| Task                                                            | Class  | Status               | Packet                          |
| --------------------------------------------------------------- | ------ | -------------------- | ------------------------------- |
| M09-T1 Semver + seam contract + beta→components migration guide | design | draft (M02/03/05/08) | [packet](M09-T1-edi-handoff.md) |

## Ready today (no dependencies)

`M01-T1` · `M01-T3` · `M01-T4` · `M02-T3` · `M03-T1` · `M03-T2` ·
`M03-T3` · `M03-T4` · `M04-T2` · `M06-T2` · `M08-T3` · `M08-T4` — twelve
tasks can start immediately, across independent files. The recommended
first two lanes: **M01-T1** (build beachhead) and **M03-T2** (decoupling
beachhead).
