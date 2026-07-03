# Operator playbook — how to run a task

For the implementing agent. It assumes you are less-advanced by design:
everything you need is in the task packet and the linked issue; do not
improvise beyond them.

## Pick up a task

1. Open [`roadmap/tasks/index.md`](../roadmap/tasks/index.md). Choose a
   task whose **Status: ready** (not `blocked`/`draft`). Prefer the
   lowest-numbered ready task in the active milestone.
2. Read its packet **and every issue it lists** (the `## Suggested fix`
   in each issue is your step-by-step; the packet's `## Plan` is the
   task-level version).
3. If the task is **class: design**, first check
   [`decisions-to-confirm.md`](../design/decisions-to-confirm.md): the
   relevant decision must be ✅ ratified. If it is still 🔵, stop and
   ask the owner — do not pick the approach yourself.
4. Set the task `active` in
   [`roadmap/status.yml`](../roadmap/status.yml).

## Do the work

5. Follow the packet `## Plan` / issue `## Suggested fix` **literally**.
   Stay inside `## Scope` — the `Out:` bullets name the tempting
   adjacents you must **not** touch.
6. Obey [`modern-qt-guidelines.md`](../design/modern-qt-guidelines.md).
   The **[MUST]** rules are non-negotiable.
7. Keep the diff small and reviewable. One task = one focused change.

## Prove it (acceptance gates)

8. Make the packet's `## Acceptance gates` **all** green. For this repo
   that always includes the relevant subset of:
   - `qmllint` clean · `qmlformat --check` clean (once M04 exists),
   - the **QML smoke-load** test green (once M04-T2 exists),
   - the **desktop example runs** (window renders, no console QML
     errors),
   - the **WASM example builds and renders** (for web-affecting tasks),
   - the carried issue's own `## Acceptance criteria`, verbatim,
     including any **CI grep** it specifies (e.g.
     `grep -Rin easydiffraction src/` → nothing).
9. If a gate can't pass, the task is **not done** — leave it `active`,
   write down the blocker, and (if it's a real dependency) open/annotate
   an issue. Never mark done with a red gate.

## Close it

10. Update `status.yml`: task → `done`.
11. For each carried issue: set `Status: closed`, add a `## Resolution`
    section (what changed + the commit/PR), `git mv` the file
    `open/ → closed/`, and update its row in
    [`issues/index.md`](../issues/index.md) (status + move to a closed
    section).
12. Reference the issue IDs in the commit/PR message.

## Task classes (how much latitude you have)

- **mechanical** — pure execution; the plan is exact; zero design
  latitude.
- **standard** — the plan is baked, but you choose obvious local
  implementation details within the guidelines.
- **design** — a decision precedes code; it must be ratified in
  `decisions-to-confirm.md` first; then it becomes standard.

## When in doubt

- Re-read the issue `## Impact` — it tells you what must not regress.
- Prefer a **gate** (a test/grep) over a judgement call. If you can
  express "done" as a check, add the check.
- If the packet and the code disagree about reality (a file moved, a
  name changed), **stop and report** — do not guess. The audit itself
  was caused by a rename that outran its manifest.
