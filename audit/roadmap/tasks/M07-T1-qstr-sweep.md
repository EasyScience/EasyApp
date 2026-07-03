# M07-T1: qsTr sweep + lupdate extraction

- **Class:** standard
- **Status:** blocked (wants M03 done first — no point translating
  strings that are moving out — and M04-T2's smoke as the net)
- **Depends:** M03, M04-T2
- **Issues:** [I-0017](../../issues/open/I-0017-i18n-coverage-tiny.md)
- **Anchors:**
  [modern-qt-guidelines.md §7](../../design/modern-qt-guidelines.md)

## Goal

Every user-visible string in the library is wrapped in `qsTr()` with
`%1` substitution (currently 8/92 files), `lupdate` extracts a
substantial `.ts`, and a lint heuristic keeps new literals from
regressing.

## Scope

- **In:** the sweep over `Elements/` + `Components/` (buttons, labels,
  dialog titles/bodies, tooltips, menu items, status text); `%1`-style
  interpolation replacing string concatenation; the `lupdate` wiring (a
  pixi task) + a committed source `.ts`; the CI heuristic
  (allowlistable) per I-0017; the style-guide rule already exists
  (guidelines §7).
- **Out:** actually _translating_ (no second language shipped here); the
  translator runtime (M07-T2); example-app strings (sweep
  opportunistically but don't gate on them).

## Plan

Follow
[I-0017 §Suggested fix](../../issues/open/I-0017-i18n-coverage-tiny.md)
steps 1–4. Mechanics: work module-by-module; a string is "user-visible"
if it renders in UI text — ids/style-token names/console messages are
not. When unsure, wrap it (over-extraction is cheap).

## Deliverables

- The sweep diff; `pixi run i18n-update` (lupdate) task; committed
  `.ts`; the CI heuristic in the gate script.

## Acceptance gates

- I-0017 acceptance verbatim (lupdate extracts a substantial count —
  record the number; heuristic red on a seeded unwrapped literal).
- Smoke test green; rendered text unchanged (qsTr is identity without
  translators).

## Review focus

Interpolations converted to `%1` (not concatenation); no qsTr around
non-UI strings that would pollute the translation file; plurals via
`qsTr(..., n)` where counts appear.

## Definition of done

I-0017 closed; `status.yml` updated.
