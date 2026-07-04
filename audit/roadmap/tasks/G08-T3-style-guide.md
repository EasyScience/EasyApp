# G08-T3: Publish & enforce the QML style guide

- **Class:** standard
- **Status:** ready (the guide draft exists; publication + enforcement
  wiring can start any time, enforcement depth grows with G04)
- **Depends:** — (enforcement rows depend on G04-T1's gate script
  existing)
- **Issues:** [I-0030](../../issues/open/I-0030-no-qml-style-guide.md)
- **Anchors:**
  [modern-qt-guidelines.md](../../design/modern-qt-guidelines.md) (the
  draft — this task makes it _the_ guide),
  [process/writing-for-junior-agents.md](../../process/writing-for-junior-agents.md)

## Goal

The style guide is a first-class, published, **enforced** document:
linked from CONTRIBUTING and the docs nav, kept in sync with the gate
script (every checkable `[MUST]` has a gate), and proven usable by
having a junior agent add a component by following it alone.

## Scope

- **In:** promote `audit/design/modern-qt-guidelines.md` into the docs
  nav (or move it to `docs/` with a knowledge pointer — one canonical
  location, the other links); a CONTRIBUTING section pointing at it; a
  traceability table rule↔gate (extend the existing Enforcement summary
  with the actual script/lint rule names as they land); a "new component
  checklist" one-pager distilled from it (file layout, naming, tokens,
  qsTr, test, gallery entry).
- **Out:** building the gates themselves (G04-T1); rewriting the guide's
  content (amend only where enforcement work reveals a rule is
  untestable as written).

## Plan

1. Decide canonical location (recommend: keep in `audit/design/`,
   surface in the docs nav via the G08-T2 knowledge wiring; until then
   link it from CONTRIBUTING and the repo README).
2. Write the new-component checklist page; link both from CONTRIBUTING.
3. Sync the Enforcement summary table with the real gate implementations
   (names, file paths).
4. Dry-run: give the checklist to a junior agent (or simulate) to add
   one trivial Element; record friction and fix the guide, not the
   agent.

## Deliverables

- Published guide + checklist; CONTRIBUTING/README links; the synced
  enforcement table; the dry-run friction notes folded in.

## Acceptance gates

- I-0030 acceptance verbatim (published + linked; checkable rules
  enforced not prose; a new component built per the guide passes lint +
  smoke with no convention nits).
- Every `[MUST]` row in the enforcement table names a live gate or an
  explicit "not yet enforceable — tracked in <issue>".

## Review focus

No rule/gate drift (the table is the contract); the checklist is
genuinely followable without reading the whole guide.

## Definition of done

I-0030 closed; `status.yml` updated.
