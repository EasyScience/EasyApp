# Audit 2026-07 — evidence & findings

The raw evidence backing the [issue tracker](../index.md): the file:line
citations, greps, and counts that each `I-NNNN` issue summarises. Kept
in the repo (and renderable in the docs) so every finding is traceable
to what established it. These are **audit records**, not polished
chapters — terse and dense, written for the next agent to act on.

## What each file contains

| File                                                             | Scope                                                                                                                                                                                                  | Backs issues                                                                                   |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| [audit-log.md](audit-log.md)                                     | Methodology, what was read, how findings were gathered — **including the round-2 verification pass** (corrections, cleared non-findings, new issues).                                                  | (provenance)                                                                                   |
| [findings-wasm-web.md](findings-wasm-web.md)                     | The web/WASM verdict: stale qrc, QtWebEngine dependency, `Settings{location}` failures, dispatch-only CI (+ vestigial qt5compat), chart perf.                                                          | I-0001, I-0002, I-0003, I-0005, I-0016                                                         |
| [findings-reusability-python.md](findings-reusability-python.md) | Library↔app entanglement (EasyDiffraction, page enums, updater incl. PreferencesDialog sites) and the Python backend (Maintenance/Logging/Translate + the both-ways-broken language UI).               | I-0006, I-0007, I-0008, I-0012, I-0022, I-0029                                                 |
| [findings-build-qml.md](findings-build-qml.md)                   | Build system (no CMake, qmake, hand qrc), module identity + registration gaps, and QML-quality (private imports, versioned imports, smells, sizing, fonts, the diverged chart variant, eval-JSONPath). | I-0004, I-0009, I-0011, I-0013, I-0015, I-0020, I-0023, I-0024, I-0027, I-0028, I-0031, I-0033 |
| [findings-governance-ci.md](findings-governance-ci.md)           | Tests (all dummy), CI/pre-commit gates, template origin, docs emptiness (+ EXAMPLES.md drift), i18n coverage, branding.                                                                                | I-0010, I-0014, I-0017, I-0018, I-0019, I-0021, I-0025, I-0026, I-0030, I-0032                 |

## How this maps to the rest of the tracker

- The [issue index](../index.md) is the actionable, rated summary (one
  row per finding).
- Each [`open/`](../open/) issue is the junior-agent-ready write-up
  (problem · impact · fix · acceptance).
- The [strategy](../../design/audit-2026-07-strategy.md) and
  [roadmap](../../roadmap/index.md) turn the findings into an ordered
  plan; the [decisions](../../design/decisions-to-confirm.md) doc lists
  the forks to ratify first.

## Scope of what was audited (2026-07)

Library `src/EasyApplication/` (Gui: Elements 42 files, Components 28,
Charts, Style, Globals, Animations, Logic; Python Logic: Logging,
Maintenance, Translate, Utils) — 92 QML files / ~15.6k lines QML, ~2.6k
lines Python. Build/packaging (`pyproject.toml`, `pixi.toml`,
`.copier-answers.yml`, `.pre-commit-config.yaml`,
`.github/workflows/*`). All five examples (`BasicQml`, `BasicPy`,
`IntermediatePy`, `AdvancedPy`, `BasicC++`). Docs (`docs/`).
Cross-checked against the consumer app
[`easydiffractionbeta`](https://github.com/easyscience/easydiffractionbeta)
(same Qt/QML + PySide6

- QMake stack). A same-day **round-2 verification pass** re-checked
  every claim and read the remaining areas (`JsonListModel`,
  `Translate.js`, `PreferencesDialog`, chart bases, mkdocs nav) — see
  [audit-log.md §Round 2](audit-log.md).
