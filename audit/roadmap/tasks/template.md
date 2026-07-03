# M##-T##: <title>

- **Class:** design | standard | mechanical
- **Status:** draft | ready | active | blocked | done — `status.yml` is
  **authoritative**; mirror it here
- **Depends:** <M##-T## | —>
- **Issues:** <I-NNNN links this task closes | —>
- **Anchors:** <design docs, guideline §, evidence files>

## Goal

<One paragraph: the outcome, not the activity. Junior-agent-clear —
someone with no prior context should know when they are done.>

## Scope

- **In:** <bullets>
- **Out:** <bullets — name the tempting-but-forbidden adjacents so scope
  doesn't creep>

## Plan

<Pre-baked steps for standard/mechanical tasks (often "follow the
Suggested fix of I-NNNN, steps 1–N"). For design-class tasks: the
decision to make + where to record it, then TBD steps produced after the
decision is ratified.>

## Deliverables

<Files/artifacts that must exist or change, incl. doc/gallery/CI syncs.>

## Acceptance gates

<Concrete, checkable — the reviewer's close conditions. For this repo,
ALWAYS include the relevant subset of: `qmllint` clean ·
`qmlformat --check` clean · QML smoke-load test green · desktop example
runs · WASM example builds+renders · the issue's own acceptance criteria
verbatim.>

## Test brief (for the tests lane)

<WHAT to gate, not how: which components/behaviours; light+dark;
desktop+WASM where relevant.>

## Review focus

<Where a reviewer should push hardest; known risk spots; regression
traps.>

## Definition of done

<The carried issue(s) meet their acceptance criteria; gates green;
`status.yml` updated; issue moved to closed/ with a Resolution note.>
