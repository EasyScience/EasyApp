# M04-T3: Template/tooling framing decision (Python-lib template → GUI-aware)

- **Class:** design (Decision C — owner ratification required before
  executing)
- **Status:** draft
- **Depends:** M04-T1 (so the QML tooling to be templated actually
  exists)
- **Issues:**
  [I-0018](../../issues/open/I-0018-scaffolded-from-python-lib-template.md)
- **Anchors:**
  [decisions-to-confirm.md §Decision C](../../design/decisions-to-confirm.md),
  `.copier-answers.yml`

## Goal

Resolve the root-cause framing: the repo is scaffolded from a generic
Python-lib copier template, which is why the QML core was ungated.
Either upstream a **GUI/QML variant** into `easyscience/templates`
(option C1, recommended — so `edi` inherits it) or formalise the local
bolt-on (C2) with a tracked follow-up.

## Scope

- **In:** the decision (ratify Decision C with the owner); if C1:
  contribute the QML tooling (CMake presets, qmllint/qmlformat hooks,
  QML test harness, gate script, the pruned dependency set) to the
  template as a `template_type=qml-lib` (or a flag) and re-run
  `copier update` here against it; if C2: document the divergence from
  the template and disable `copier update` steps that would overwrite
  the QML additions.
- **Out:** the tooling itself (built in M01/M04); edi's scaffolding
  (edi's E01 consumes the outcome).

## Plan

1. Ratify Decision C in
   [decisions-to-confirm.md](../../design/decisions-to-confirm.md)
   (owner).
2. C1 path: open a PR to `easyscience/templates` adding the GUI variant
   (source of truth = what M01/M04 built here); once merged, run
   `pixi run copier-update` with the new answers and verify nothing
   regresses (`git diff` review + full gate suite).
3. C2 path: add a `docs`/CONTRIBUTING note listing the intentional
   divergences and pin `.copier-answers.yml` so updates don't clobber
   them.
4. Either way: re-evaluate the inherited Python-lib assumptions flagged
   by the audit — docstring coverage as a primary metric, the
   `fitting`/`scipp-analysis` test folders (deleted in M04-T2), the
   numpy dependency (M06-T2).

## Deliverables

- Decision C ratified with rationale; the chosen path executed; `edi`'s
  E01 packet pointed at the resulting template/variant.

## Acceptance gates

- `copier update` (C1) or a documented pin (C2) leaves the repo green
  across the full gate suite.
- `edi`'s scaffolding task references the outcome (no re-derivation of
  the gap there).

## Review focus

That template updates cannot silently remove the QML gates again (this
is the whole point).

## Definition of done

I-0018 closed with the decision + execution recorded; `status.yml`
updated.
