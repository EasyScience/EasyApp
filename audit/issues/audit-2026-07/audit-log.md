# Audit log — 2026-07 GUI base audit

## Purpose

Assess `easyscience/gui-components` (the `EasyApplication` Qt/QML
component library) as the foundation for the future `enhantica/edi`
diffraction-analysis GUI, which must ship as **both** a desktop app
(PySide6) and a **web app (WASM/C++)**. Produce a rated issue list, a
hardening roadmap, and modern-Qt guidance — structured like the
`enhantica/crysta` knowledge base so the same agents/playbooks apply.

## Method

Read-only static audit (no code executed; the repo builds were not run —
several are known-broken, see I-0001). Evidence is file:line citations,
greps, and counts against the working tree at commit `a573a96` (branch
`master`, clean).

Sequence:

1. **Template study.** Read the crysta knowledge base
   (issues/roadmap/milestones/design/process, task + issue templates) to
   mirror its structure.
2. **Meta/build.** `README.md`, `EXAMPLES.md`, `pyproject.toml`,
   `pixi.toml`, `.copier-answers.yml`, `.pre-commit-config.yaml`,
   `.github/workflows/*`.
3. **Core QML architecture.** All `qmldir`; Style singletons (`Colors`,
   `Sizes`, `Fonts`, `Times`); `Globals/Vars`; both `ApplicationWindow`
   variants; representative Elements (`Button`, `Parameter`,
   `RemoteController`); Charts (`ChartViewSimple1dPlotly`).
4. **Python backend.** `Logging.py`, `Maintenance.py`, `Translate.py`,
   `Utils/Utils.py`; example `main.py` (Python↔QML registration + import
   paths).
5. **Web/C++ path.** `BasicC++` `main.cpp`, `.pro`, `resources.qrc`;
   `wasm.yml`.
6. **Cross-cutting greps.** Private `.impl` imports, versioned imports,
   `QtWebEngine` usage, `console.*`, `qsTr` coverage,
   `Settings{location}` WASM markers, `EasyApp` residue, `TODO`.
7. **Consumer cross-check.** `easydiffractionbeta` structure via web
   (confirms the same QML+PySide6+QMake stack `edi` would inherit).

## Key quantified findings (greps/counts — as corrected in round 2)

- `QtWebEngine`/`WebEngineView` in **10** shipped QML files (charts +
  `BasicReport`). → I-0002
- Private `QtQuick.Controls.impl` in **21** QML files; supported
  `QtQuick.Templates` in **30** (union 33). → I-0011
- `// Gives WASM error on run` at **11** live `Settings{location}`
  sites. → I-0003
- `qsTr(` used in only **8 / 92** QML files under `src`. → I-0017
- `console.log/debug/error` in **18** QML files. → I-0021
- `TODO/FIXME/HACK/temporary/workaround`: **7** in `src`. Plus
  `# NEED FIX` ×2 in `Logging.py`.
- Tests: **4** files, all `test_dummy.py`; **0** QML tests. → I-0010
- `CMakeLists.txt`: **0**. `qmllint/qmlformat/qmltestrunner` references:
  **0**. → I-0004/I-0026
- `resources.qrc`: ~180 aliases, **all** rooted at the deleted
  `src/EasyApp/…` path; lists ≥8 non-existent files. → I-0001/I-0020
- Fonts: FontAwesome **5, 6, 7** all present (only FA5 loaded);
  filenames contain spaces. → I-0015
- `eval(` in shipped QML: **3** sites, all in `JsonListModel.qml`. →
  I-0031 (round 2)

## Verdict

- **Desktop-Python:** functional; high maintainability/test debt.
- **Web/WASM:** broken (I-0001) and architecturally blocked
  (I-0002/I-0003) even once unbroken.
- **Reuse by a new product:** blocked by EasyDiffraction entanglement
  (I-0006/I-0007).
- **Modern-Qt hygiene:** classic-only; no module build, no QML gates,
  private-API reliance.
- **Preserve:** the visual design system (Style tokens,
  Elements/Components layering, theming, animations) is coherent — the
  work is _hardening + decoupling_, not a rewrite.

## Round 2 — verification pass (same day, owner-requested re-check)

Every round-1 claim was re-verified against the tree; previously-unread
areas were read (`JsonListModel`, `Translate.js`, `PreferencesDialog`,
`QtCharts1dMeasVsCalc`, the full examples set, mkdocs nav, test.yml
jobs). Outcome:

**Corrections to round-1 statements (applied to the issues/evidence):**

1. **I-0008** — the web changelog is downloaded **twice** per check (in
   `_getWebDate` and again in `_getReleaseNotes`), not three times:
   `_getAppChangelog()` is a **local file read**, not a network fetch.
   Issue slug renamed `…-triple-fetch` → `…-double-fetch`.
2. **I-0011** — precise split: private `.impl` in **21** files;
   `Templates` (supported) in 30; round 1 quoted the union (33) as if it
   were all `.impl`.
3. **I-0013** — `QtCharts1dBase 2.qml` is **not** an identical copy: the
   diff shows a diverged working-copy variant (Rectangle-wrapped
   `ChartView`, debug `color: 'red'`, extra
   `allowZoom`/`useOpenGL`/`plotArea` API). Also, a space-named file
   cannot be a QML type at all.
4. **Examples scope** — all **five** examples exist (BasicQml, BasicPy,
   IntermediatePy, AdvancedPy, BasicC++); round 1's file listing was
   truncated and named only three. Elements module: **42** `.qml` files
   on disk (41 registered; `RadioIndicator` unlisted → I-0033).
5. **I-0003 wording** — the WASM settings mechanism is stated as "Qt's
   browser storage backend, verify localStorage-vs-IndexedDB on the
   pinned Qt" rather than asserting `localStorage`.
6. **Cross-reference fix** — M02-T1/M02-T2/strategy referred to the
   chart choice as "Decision C"; the decision record has charts as
   **Decision A** (C is the template framing). All references aligned;
   packets updated for the A/B ratifications (2026-07-03).

**Non-findings (checked, explicitly cleared):**

- `XmlListModel` (removed in Qt 6 under its Qt 5 URI) appears only as a
  **commented-out** import (`PreferencesDialog.qml:6`) — no live break.
- `Qt5Compat`/`GraphicalEffects` — imported **nowhere** in
  `src`/`examples`; the `wasm.yml` `addons.qt5compat` install is
  vestigial (folded into I-0005's fix).
- `numpy` — confirmed: no `import numpy` anywhere under `src` (I-0027
  stands).

**New findings (opened as issues):**

- **I-0031** — `JsonListModel` vendors a 2007 `eval()`-based JSONPath (3
  `eval` sites; XHR loads with no error handling; `Error` status never
  set).
- **I-0032** — `EXAMPLES.md` references a non-existent
  `.vscode/launch.json` and `resources/images/vscode_debug.jpg`; stale
  `PySide6>=6.8,<6.9` pin.
- **I-0033** — `qmldir` registration gaps (`RadioIndicator`;
  `ChartView*Plotly` ×2).

**New evidence strengthening existing issues:**

- **I-0007** — updater coupling also in
  `PreferencesDialog.qml:154-165` + `:370` and `Vars.qml:45-46` (fix
  steps extended).
- **I-0029** — the language ComboBox (`PreferencesDialog.qml:305-308`)
  is broken against **both** translators: the JS fallback has no
  `languages` member (only a `languagesAsXml()` relic), and the Python
  `defaultLanguageIndex` property is invoked as a function.

## Constraints observed during the audit

- Single-operator, read-only; ≤1 helper agent (per owner instruction) —
  none were needed; the audit was done with direct reads/greps for full
  evidence fidelity.
