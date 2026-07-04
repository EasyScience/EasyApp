# G09-T1: edi handoff — semver, the shared-session-layer seam, beta→components migration guide

- **Class:** design
- **Status:** draft (activates when G02+G03+G05+G08 are done — it
  packages their results)
- **Depends:** G02, G03, G05, G08
- **Issues:** — (forward-looking; consumes the closed Phase-I/II issues)
- **Anchors:**
  [architecture-target.md §edi consumption](../../design/architecture-target.md);
  `edi/knowledge/design/architecture-and-upstreams.md`; crysta decision
  20 (edi monorepo); `easydiffractionbeta` (the flows to migrate)

## Goal

`enhantica/edi` can pin a versioned, documented base and build both
surfaces on it without reading this repo's source: a semver + support
policy exists, the injection seams are documented as a stable contract,
and a migration guide maps every `easydiffractionbeta` GUI concept to
its hardened-base equivalent.

## Scope

- **In:**
  1. **Versioning policy** — semver for the QML API (what counts as
     breaking: removed/renamed types, property signature changes, token
     renames), a CHANGELOG, a documented Qt support window (Decision E),
     and the release tagging flow.
  2. **Seam contract doc** — one page freezing the injection seams:
     `ApplicationInfo`, the page model shape, `AppSettings`, the chart
     façade property APIs, optional services (`updateService`), and the
     theming tokens — each with "stable since vX.Y".
  3. **beta→components migration guide** — a table: each beta GUI
     concept (page structure, sidebar groups, parameter tables, chart
     views, dialogs, updater, tutorials) → the hardened-base equivalent
     (or "moved to app" / "dropped, because…"), with snippets.
  4. Sync `edi/knowledge` (upstream-gate table, the E03/E06 packets'
     assumptions) against the final state of this repo.
- **Out:** any edi code (edi's own milestones); new base features
  discovered missing during the guide-writing (open issues here
  instead).

## Plan

1. Draft the seam contract from `architecture-target.md` + the as-built
   G02/G03 APIs; freeze it with the owner.
2. Tag the first semver release (v1.0.0 of the hardened base) with the
   CHANGELOG.
3. Write the migration guide against the real beta repo (walk its
   `easyDiffractionApp` QML tree; map every screen).
4. Update `edi/knowledge` and hand the baton to edi's E03.

## Deliverables

- Versioning policy + CHANGELOG + first tag; the seam contract page; the
  migration guide; the edi knowledge-base sync.

## Acceptance gates

- An edi-side reader can answer "how do I add a page / persist a setting
  / draw the pattern / brand the app" from the seam contract alone
  (dry-run with a junior agent).
- The migration guide covers every top-level beta screen (checked
  against the beta repo's page list).
- The base is tagged; `edi/knowledge/roadmap/status.yml`'s guibase gates
  flip to "met".

## Review focus

That the seams documented match what G02/G03 actually shipped (no
aspirational API in the contract); breaking-change definition is
unambiguous.

## Definition of done

edi's E03 unblocked with a versioned base; `status.yml` updated (G09
done = Phase III complete).
