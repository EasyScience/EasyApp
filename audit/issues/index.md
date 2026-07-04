# Issue index — 2026-07 GUI base audit

The single source of truth. One row per finding, rated. See
[`about.md`](about.md) for the priority scale and file format; each
`I-NNNN` links to the junior-agent-ready write-up in [`open/`](open/);
the raw evidence is in [`audit-2026-07/`](audit-2026-07/).

**Targets:** `web` = the WASM/C++ browser app · `desktop` = the PySide6
desktop app · `both`. **Milestone** = where it is scheduled in the
[roadmap](../roadmap/index.md).

## Summary

| Priority  | Count  | Open   | Closed |
| --------- | ------ | ------ | ------ |
| Highest   | 4      | 4      | 0      |
| High      | 6      | 6      | 0      |
| Medium    | 13     | 13     | 0      |
| Low       | 10     | 10     | 0      |
| **Total** | **33** | **33** | **0**  |

Web/WASM-blocking issues (`Targets: web` at High+): **I-0001, I-0002,
I-0003, I-0005**. These gate the entire "web app" promise and must clear
before `edi` starts its WASM surface.

## Highest

| ID                                                          | Title                                                                                                                                  | Area     | Targets | Milestone |
| ----------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- | --------- |
| [I-0001](open/I-0001-wasm-qrc-stale-easyapp-paths.md)       | C++/WASM `resources.qrc` points at the pre-rename `src/EasyApp/…` tree and lists deleted files → WASM build cannot find the components | build    | web     | G01       |
| [I-0002](open/I-0002-charts-reports-require-qtwebengine.md) | Charts & reports render via `QtWebEngine`/`WebEngineView` (10 files) — QtWebEngine does not exist for WASM                             | wasm-web | web     | G02       |
| [I-0003](open/I-0003-settings-location-breaks-wasm.md)      | `Settings { location: … }` throws on WASM at 11 sites → theme/geometry/preferences persistence broken in the browser                   | wasm-web | web     | G02       |
| [I-0004](open/I-0004-no-cmake-qt-add-qml-module.md)         | No CMake / `qt_add_qml_module`; build relies on deprecated QMake `.pro` + a hand-maintained `.qrc`                                     | build    | both    | G01       |

## High

| ID                                                           | Title                                                                                                                                                        | Area        | Targets | Milestone |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- | ------- | --------- |
| [I-0005](open/I-0005-wasm-ci-dispatch-only.md)               | WASM CI is `workflow_dispatch`-only (push/schedule commented out) → the web target is unprotected; this is why I-0001 shipped                                | ci          | web     | G01       |
| [I-0006](open/I-0006-app-specifics-baked-into-library.md)    | App-specific concepts hard-wired into the "generic" library: `Vars` page enums, `Logging.py` `appName='EasyDiffraction'`                                     | reusability | both    | G03       |
| [I-0007](open/I-0007-updater-embedded-in-base-window.md)     | Qt-Installer auto-updater embedded in the base `ApplicationWindow` + `Maintenance.py`; desktop-only, hard-coded EasyDiffraction URL, runs network on startup | reusability | both    | G03       |
| [I-0008](open/I-0008-maintenance-indexerror-double-fetch.md) | `Maintenance.py._getWebDate()` indexes `matches[0]` with no guard → `IndexError` crash; the web changelog is downloaded twice per check                      | python      | desktop | G03       |
| [I-0009](open/I-0009-qmldir-module-uri-mismatch.md)          | `qmldir` `module` names (`module Style`) don't match the import URIs (`import EasyApplication.Gui.Style`) → blocks `qt_add_qml_module`, confuses tooling     | build       | both    | G01       |
| [I-0010](open/I-0010-zero-real-tests.md)                     | Zero real tests — every test file is `test_dummy.py`; no QML (Qt Quick Test) tests, no smoke-load; CI is green while the GUI can be broken                   | ci          | both    | G04       |

## Medium

| ID                                                             | Title                                                                                                                                                                                                          | Area    | Targets | Milestone |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ------- | --------- |
| [I-0011](open/I-0011-private-controls-impl-imports.md)         | Private Qt API `QtQuick.Controls.impl` imported in 21 QML files → fragile across Qt updates                                                                                                                    | qml     | both    | G04/G05   |
| [I-0012](open/I-0012-qttest-qtmultimedia-in-shipped-lib.md)    | `RemoteController.qml` imports `QtTest` + `QtMultimedia` into the shipped library and vendors ~200 lines of Qt private compare code                                                                            | qml     | both    | G03       |
| [I-0015](open/I-0015-font-bloat-and-spaces.md)                 | Font bloat/ambiguity: FontAwesome 5/6/7 all shipped (only FA5 used), unused weights, spaces in filenames, all fonts eager-loaded                                                                               | build   | both    | G06       |
| [I-0016](open/I-0016-charts-reload-on-resize.md)               | Plotly charts full-page `reload()` on every resize + push data through the JS bridge via `JSON.stringify` → severe perf on large patterns                                                                      | qml     | both    | G02       |
| [I-0017](open/I-0017-i18n-coverage-tiny.md)                    | i18n coverage tiny — only 8/92 QML files use `qsTr()`; most user-facing strings are untranslatable                                                                                                             | qml     | both    | G07       |
| [I-0018](open/I-0018-scaffolded-from-python-lib-template.md)   | Repo scaffolded from a generic **Python-lib** copier template (`template_type=lib`) → Python-only tooling, `numpy` dep, QML treated as inert package data. Root cause of the tooling gaps                      | process | both    | G04       |
| [I-0020](open/I-0020-examples-reference-deleted-components.md) | Examples' `.pro`/`.qrc` list components that no longer exist (`BoxShadow`, `ElevationEffect`, `Popup`, `ToolBar`, `Plotly3dMesh`, extra font weights) → examples describe a different/older library than `src` | build   | both    | G01       |
| [I-0022](open/I-0022-logging-import-side-effects.md)           | `Logging.py` builds a module-level `console = Logger()` at import (does `QSettings` file I/O on import) and duplicates settings logic (`# NEED FIX`)                                                           | python  | desktop | G03       |
| [I-0024](open/I-0024-manual-scaling-vs-hidpi.md)               | `Sizes.qml` manual `scalePx`/`defaultScale` scaling can fight Qt HiDPI; magic multipliers; font metrics via a throwaway `Text{}` instead of `FontMetrics`                                                      | qml     | both    | G05       |
| [I-0025](open/I-0025-no-component-docs-gallery.md)             | No component documentation or gallery — docs are near-empty (user-guide 11 words, api-reference 11 words); junior agents have no catalog of what exists                                                        | docs    | both    | G08       |
| [I-0026](open/I-0026-precommit-manual-no-qml-gate.md)          | Pre-commit hooks are all `stages: [manual]` (don't run on commit); no QML lint/format gate anywhere                                                                                                            | ci      | both    | G04       |
| [I-0029](open/I-0029-translator-wiring-inconsistent.md)        | Two incompatible `Translator`s; the only language-selection UI (`PreferencesDialog:305-308`) is broken against **both** (JS fallback lacks `languages`; the Python property is called as a function)           | python  | both    | G07       |
| [I-0030](open/I-0030-no-qml-style-guide.md)                    | No QML style / naming / layering guide — the `Ea*` prefix, the Elements↔Components split, and property conventions are undocumented for the junior agents who will implement                                   | process | both    | G08       |

## Low

| ID                                                            | Title                                                                                                                                                                  | Area   | Targets | Milestone |
| ------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------- | --------- |
| [I-0013](open/I-0013-duplicate-qtcharts-base-file.md)         | Diverged working-copy variant `QtCharts1dBase 2.qml` in `src` (Rectangle-wrapped, `color:'red'` debug; unloadable type name) — referenced only by the stale C++ `.qrc` | qml    | both    | G01       |
| [I-0014](open/I-0014-broken-python-m-entrypoint.md)           | `pixi run EasyApplication` / `python -m EasyApplication` is broken — there is no `__main__.py`                                                                         | python | desktop | G06       |
| [I-0019](open/I-0019-stale-easyapp-branding.md)               | Stale `EasyApp` branding/paths across examples (SPDX "2024 EasyApp contributors", `github.com/easyscience/EasyApp` links, `.pro` `src/EasyApp` path)                   | docs   | both    | G08       |
| [I-0021](open/I-0021-console-debug-and-dead-code.md)          | Leftover `console.*` logging in 18 QML files and commented-out dead code / `print()` debugging throughout                                                              | qml    | both    | G04       |
| [I-0023](open/I-0023-minor-qml-code-smells.md)                | Minor QML smells: `Colors.isDarkPalette` redundant branches, `Button.qml` no-op ternary, MouseArea+HoverHandler workarounds                                            | qml    | both    | G05       |
| [I-0027](open/I-0027-numpy-runtime-dependency.md)             | `numpy` is a hard runtime dependency of a QML component package with no obvious use; irrelevant to the C++/WASM target                                                 | build  | desktop | G06       |
| [I-0028](open/I-0028-two-applicationwindow-types.md)          | Two different `ApplicationWindow` types (`Elements` vs `Components`) share a name → import ambiguity and confusion                                                     | qml    | both    | G05       |
| [I-0031](open/I-0031-jsonlistmodel-vendored-eval-jsonpath.md) | `JsonListModel` vendors a 2007 `eval()`-based JSONPath (3 eval sites; blocks `qmlsc`; silent XHR failures, `Error` status never set)                                   | qml    | both    | G05       |
| [I-0032](open/I-0032-examples-md-missing-assets.md)           | `EXAMPLES.md` references missing assets (`.vscode/launch.json`, `resources/images/vscode_debug.jpg`) and a stale `PySide6>=6.8,<6.9` pin                               | docs   | both    | G08       |
| [I-0033](open/I-0033-qmldir-registration-gaps.md)             | `qmldir` registration gaps: `RadioIndicator` missing from Elements; `ChartViewSimple1dPlotly`/`ChartViewHeatmap2dPlotly` missing from Charts                           | build  | both    | G01       |

> There is no gap in the numbering: every ID I-0001…I-0033 is present
> exactly once (4 Highest + 6 High account for I-0001…I-0010;
> I-0031…I-0033 were added by the round-2 verification pass, see
> [audit-log.md §Round 2](audit-2026-07/audit-log.md)).
