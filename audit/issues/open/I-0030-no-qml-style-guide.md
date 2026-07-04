# I-0030: No QML style / naming / layering guide for the implementing agents

- **Status:** open
- **Priority:** Medium
- **Area:** process
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0011, I-0017, I-0025, I-0028; milestone G08

## Problem

The library has real, mostly-consistent conventions — the `Ea*` import
aliases (`EaStyle`/`EaElements`/`EaComponents`), the `Elements`
(primitive) vs `Components` (composed) split, singleton `Style` tokens,
`Behavior on color { ThemeChange {} }` theming — but **none of it is
written down**. `edi` will be built by less-advanced agents who must
extend this base; without an explicit guide they will guess, and the
conventions will erode (as the audit's scattered smells already show).

## Impact

- Inconsistent contributions, reinvented components, private-API reuse
  (I-0011), untranslated strings (I-0017) — all cheaper to prevent with
  a guide than to fix later.
- The user explicitly requires reviews/instructions "as detailed and
  explicit as possible" for less-advanced agents — a style guide is the
  durable form of that.

## Suggested fix

Write `audit/design/modern-qt-guidelines.md` (started by this audit)
into a first-class, enforced style guide covering:

1. **Layering:** when to add an `Element` vs a `Component`; the
   base-window rule (I-0028); no app-specifics in the library (I-0006).
2. **Naming/imports:** `Ea*` alias convention; module URI == directory
   (I-0009); one type per file.
3. **Modern-Qt rules:** unversioned imports; no `QtQuick.Controls.impl`
   outside wrappers (I-0011); prefer `qt_add_qml_module`;
   `required property` / `setInitialProperties` over context properties;
   `MultiEffect` over Qt5Compat graphical effects; typed properties over
   `var`.
4. **Theming/sizing:** always via `Style` tokens; `qsTr()` for all
   display text (I-0017); HiDPI rules (I-0024).
5. **Testing:** every new component gets a Qt Quick Test + a gallery
   entry (I-0010, I-0025).
6. Make the key rules machine-checkable (qmllint config + grep gates in
   CI, I-0026).

## Acceptance criteria

- A published style guide exists and is linked from `CONTRIBUTING`/docs.
- Its checkable rules are enforced by qmllint/CI, not just prose.
- A new component added by following the guide passes lint + smoke test
  with no reviewer nits on convention.
