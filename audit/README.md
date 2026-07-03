# gui-components audit knowledge base

This directory is the in-repo, git-tracked **audit, roadmap and design
record** for `easyscience/gui-components` (the `EasyApplication` Qt/QML
component library). It was opened by the **2026-07 GUI base audit**,
whose purpose is to turn this library into _"a very solid, robust,
sustainable and maintainable base for GUI"_ that the new
diffraction-analysis product
[`enhantica/edi`](https://github.com/enhantica/edi) can build its
**desktop (PySide6) and web (WASM/C++)** front-ends on.

It deliberately mirrors the structure of the
[`enhantica/crysta`](https://github.com/enhantica/crysta) knowledge base
(issues · roadmap · milestones · design · process), so the same agents
and playbooks can operate on both repos.

## Why this exists

`gui-components` is the shared GUI foundation. Two consumers depend on
it:

- The current reference app
  [`easydiffractionbeta`](https://github.com/easyscience/easydiffractionbeta)
  (Qt/QML + PySide6, QMake) — the app whose look-and-feel we are
  keeping.
- The **future** product `edi` — desktop **and** WASM web app,
  implemented by less-advanced agents who need an unambiguous,
  well-documented, tested base to work against.

The audit found the base is **functional on desktop-Python but
structurally fragile, is broken on the web/WASM target it claims to
support, and is entangled with EasyDiffraction specifics** that block
reuse. This knowledge base records every finding with evidence, rates
it, and lays out an ordered plan to fix it.

## Layout

```
audit/
├── README.md                 ← this file
├── issues/
│   ├── about.md              ← issue-tracker process (priorities, format, workflow)
│   ├── index.md              ← THE single source of truth: one rated row per issue
│   ├── open/                 ← one file per OPEN issue: I-NNNN-slug.md
│   ├── closed/               ← resolved issues move here (git keeps history)
│   └── audit-2026-07/        ← the raw evidence (file:line proofs) backing each issue
├── roadmap/
│   ├── index.md              ← phases, milestone ordering, how a task is run
│   ├── status.yml            ← single source of truth for milestone/task progress
│   └── tasks/                ← one packet per one-session task: M##-T##-slug.md
├── milestones/               ← externally-checkable capability deliverables
├── design/                   ← the analysis, target architecture, Qt best-practices, decisions
└── process/                  ← operator playbook + how to write for junior agents
```

## Start here

1. **See the problems, rated:** [`issues/index.md`](issues/index.md).
2. **Understand the strategy & long-term improvements:**
   [`design/audit-2026-07-strategy.md`](design/audit-2026-07-strategy.md).
3. **See the plan (milestones/tasks):**
   [`roadmap/index.md`](roadmap/index.md).
4. **Confirm the big forks before coding:**
   [`design/decisions-to-confirm.md`](design/decisions-to-confirm.md).
5. **If you are the implementing agent:** read
   [`process/operator-playbook.md`](process/operator-playbook.md) and
   [`design/modern-qt-guidelines.md`](design/modern-qt-guidelines.md)
   first.

## Audit headline

| Verdict                               |                                                                                                                                                                                                                                   |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Desktop-Python (PySide6)**          | Works today; maintainability & test debt is high.                                                                                                                                                                                 |
| **Web (WASM/C++)**                    | **Broken.** The C++ example's `resources.qrc` still points at the pre-rename `src/EasyApp/…` tree and lists deleted files; charts/reports need `QtWebEngine` (unavailable in WASM); `Settings{ location }` throws in the browser. |
| **Reusable base for a _new_ product** | **Not yet.** App-specific concepts (`EasyDiffraction`, page enums, auto-updater) are hard-wired into the "generic" library.                                                                                                       |
| **Modern-Qt hygiene**                 | Classic-only: no CMake/`qt_add_qml_module`, no QML linting/tests, private `QtQuick.Controls.impl` used in 21 files, mixed versioned imports, zero real tests.                                                                     |

The good news: the visual design system (Style singletons,
Elements/Components layering, theming and animations) is coherent and
worth preserving. The work is **hardening and decoupling**, not a
rewrite.
