# Issue tracker

A lightweight, in-repo, git-tracked issue tracker for the
`gui-components` GUI base — correctness, architecture,
WASM/web-readiness, reusability, and process findings. It is
complementary to GitHub issues and lives in the repo so every finding
travels with the code and renders next to the design/roadmap it
concerns.

Opened by the **2026-07 GUI base audit** (see [`index.md`](index.md) for
the live table). It is meant to keep growing: any agent or contributor
may add issues.

## Layout

```
audit/issues/
├── about.md          ← this file (process)
├── index.md          ← the single source of truth: one table row per issue
├── open/             ← one file per OPEN issue:  I-NNNN-slug.md
├── closed/           ← resolved issues move here (git preserves history)
└── audit-2026-07/    ← the raw evidence (file:line proofs, greps, counts) each I-NNNN cites
```

## Priorities

| Priority    | Meaning                                                                                               |
| ----------- | ----------------------------------------------------------------------------------------------------- |
| **Highest** | Breaks a stated target (the web/WASM build), or blocks the whole hardening plan. Fix first.           |
| **High**    | Wrong/broken behaviour on a supported path, latent crash, or entanglement that blocks reuse by `edi`. |
| **Medium**  | Robustness, maintainability, performance, or tooling improvement with concrete benefit.               |
| **Low**     | Consistency / documentation / hygiene polish.                                                         |
| **Lowest**  | Nit.                                                                                                  |

## Issue file format

Every issue is one file with this front-matter and sections:

```markdown
# I-NNNN: <title>

- **Status:** open | closed
- **Priority:** Highest | High | Medium | Low | Lowest
- **Area:** architecture | wasm-web | qml | python | build | ci |
  reusability | docs | process
- **Targets:** desktop | web | both ← which delivery target(s) this
  affects
- **Found:** 2026-07 GUI base audit
- **Related:** <other I-NNNN, milestone/task IDs, evidence file>

## Problem

<what is wrong and why — with evidence file:line and, where relevant, a
numeric/grep proof>

## Impact

<who/what it affects; how it can bite; which consumer (beta / edi) and
which target>

## Suggested fix

<explicit, step-by-step instructions a JUNIOR agent can follow with no
extra context>

## Acceptance criteria

<how we know it is fixed — a build that passes, a test, a grep that
returns nothing, a doc change>
```

The **Suggested fix** and **Acceptance criteria** sections are contracts
for a less-advanced implementing agent: they must be concrete enough to
follow verbatim. When a fix has real design choices, the issue names the
recommended option first and points at
[`design/decisions-to-confirm.md`](../design/decisions-to-confirm.md).

## Workflow

1. **Open:** create `open/I-NNNN-slug.md`, add a row to `index.md`.
2. **Work:** reference the issue ID in commits/PRs and in the roadmap
   task that carries it.
3. **Close:** set `Status: closed`, add a short `## Resolution` section
   (what changed + commit/PR), `git mv` the file to `closed/`, and
   update its `index.md` row (status + move to the closed section).
   Never delete — git keeps the trail.

## Numbering

`I-NNNN`, zero-padded, monotonically increasing across both `open/` and
`closed/` (never reused). The next free number is one past the highest
in `index.md`.
