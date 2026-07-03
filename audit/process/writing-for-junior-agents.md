# Writing tasks & reviews for less-advanced agents

`edi` and the hardening of this base will be implemented by
**less-advanced agents**. The owner's explicit requirement: reviews and
tasks must be "as detailed and explicit as possible" so they can be
followed without extra context. This note captures how the audit's
issues/tasks were written so the next batch matches.

## The contract

A junior agent should be able to complete a task **without inferring
anything**. If a step needs judgement, either (a) pre-make the judgement
and write the exact action, or (b) mark it a `design` decision and route
it to [`decisions-to-confirm.md`](../design/decisions-to-confirm.md).
Never leave a silent choice in the middle of a `standard`/`mechanical`
task.

## How to write an issue (`I-NNNN`)

- **Problem:** state it with **evidence** — `file:line`, a grep, a
  count, or a numeric proof. The agent must be able to _see_ it, not
  take your word.
- **Impact:** name who/what it breaks and on which target (desktop/web).
  This is the "do not regress" contract.
- **Suggested fix:** numbered, imperative, copy-pasteable. Include the
  actual commands/greps. If a choice exists, name the recommended option
  first and point at the decision doc.
- **Acceptance criteria:** checkable — a build that passes, a test that
  goes red when broken, a grep that returns nothing, a specific file
  that exists. "Looks better" is not a criterion.

## How to write a task packet (`M##-T##`)

Use [`roadmap/tasks/template.md`](../roadmap/tasks/template.md). The
load-bearing sections:

- **Scope `Out:`** — explicitly list the tempting-but-forbidden
  adjacents. Scope creep is the main failure mode for a junior agent;
  forbid it by name.
- **Plan** — for `standard`/`mechanical`, bake the steps (often "follow
  I-NNNN Suggested fix, steps 1–N"). For `design`, the first step is
  "ratify Decision X", then TBD.
- **Acceptance gates** — the reviewer's close conditions, always
  including the concrete build/lint/ test/grep for _this_ repo. Prefer
  gates the agent can run over things a reviewer must eyeball.

## Principles

1. **Evidence over assertion.** Every claim cites where it's true.
2. **Gates over judgement.** If "done" can be a command that exits 0,
   make it one. Reviews don't scale to many junior agents; gates do.
   (This is why the guidelines end in an enforcement table.)
3. **One task, one focused change.** Small diffs are reviewable and
   reversible.
4. **Name the trap.** If there's a way to do it wrong that looks right
   (repair the `.qrc` instead of generating it; fix one
   `Settings{location}` of eleven), say so in `Out:`/`Review focus`.
5. **Point, don't repeat.** Link to the guideline/issue rather than
   restating it, so there's one source of truth to update.
6. **Assume no memory.** Re-link the seam/decision each time; the agent
   may not have read the sibling doc.
7. **Fail loud on reality mismatch.** Tell the agent: if the code
   contradicts the packet (a file moved/renamed), stop and report —
   don't guess. (The whole audit exists because a rename outran its
   manifest silently.)

## Review style (when reviewing a junior agent's PR)

- Check the **acceptance gates first** — if any is red, the review is
  "not done yet", full stop.
- Verify **scope**: did they touch an `Out:` item? Send it back.
- Verify the **`[MUST]` guideline rules** relevant to the diff (grep for
  the forbidden patterns).
- Give **specific, located** feedback (`file:line` + the exact change),
  never "clean this up".
- Prefer converting a recurring nit into a **gate** so it never comes
  back.
