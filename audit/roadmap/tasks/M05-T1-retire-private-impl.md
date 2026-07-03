# M05-T1: Replace/wrap the private `QtQuick.Controls.impl` usages

- **Class:** standard
- **Status:** blocked (needs the M04-T1 qmllint findings list + M04-T2
  smoke test as the safety net)
- **Depends:** M04-T1, M04-T2
- **Issues:**
  [I-0011](../../issues/open/I-0011-private-controls-impl-imports.md)
- **Anchors:**
  [modern-qt-guidelines.md §2](../../design/modern-qt-guidelines.md);
  the M04-T1 deferred-findings list

## Goal

No shipped QML imports the private `QtQuick.Controls.impl` (21 files
today) except an explicit, minimal wrapper allowlist — so routine Qt
upgrades can't silently break the controls. `QtQuick.Templates`
(supported) stays.

## Scope

- **In:** per-type replacement per
  [I-0011 §Suggested fix](../../issues/open/I-0011-private-controls-impl-imports.md):
  `IconLabel` → a project `EaIconLabel` (one place), `PlaceholderText` →
  plain positioned `Text`,
  `CheckIndicator`/`RadioIndicator`/`CursorDelegate` → the project's own
  same-named elements; a CI grep gate with the (ideally empty)
  allowlist.
- **Out:** visual redesign (pixel-parity is the goal); the base-window
  rename (M05-T2); Templates usage (keep).

## Plan

1. Take the M04-T1 findings list; group the 21 files by private type
   used.
2. Introduce the single wrapper (`EaIconLabel`) first; mechanically
   migrate its users; then the indicator/placeholder swaps file-by-file.
3. After each group: run the smoke test + eyeball the gallery/example
   app in light **and** dark.
4. Add the allowlist grep gate to `tools/check_gates.sh` (from M04-T1).

## Deliverables

- Migrated controls; `EaIconLabel` (and any other wrapper) documented;
  the gate updated.

## Acceptance gates

- `grep -rln "QtQuick.Controls.impl" src/` → only the allowlisted
  wrapper files (target: 0–2).
- Smoke test green; the example app renders identically before/after
  (screenshot comparison in the PR, light + dark).
- I-0011 acceptance criteria verbatim.

## Review focus

Visual parity of hover/pressed/disabled states (the `.impl` types
carried state colors); no behaviour change in `IconLabel` display modes
(icon-only/text-only/both).

## Definition of done

I-0011 closed; `status.yml` updated.
