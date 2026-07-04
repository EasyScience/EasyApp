# G08-T1: Gallery example — every component rendered, doubling as a visual smoke test

- **Class:** standard
- **Status:** blocked (wants the G04-T2 smoke enumerator to share its
  component list; runs best on the post-G03 decoupled base)
- **Depends:** G04-T2, G03
- **Issues:**
  [I-0025](../../issues/open/I-0025-no-component-docs-gallery.md)
  (gallery half)
- **Anchors:**
  [modern-qt-guidelines.md §9](../../design/modern-qt-guidelines.md)

## Goal

`examples/Gallery` — a small app that renders **every** `Element` and
`Component` (grouped by module, light + dark toggle, interactive where
meaningful). It is both the living documentation a junior agent browses
("what exists, what does it look like, what's its name") and a visual
smoke surface run in CI.

## Scope

- **In:** the Gallery app (pages per module: Elements / Components /
  Charts / Style tokens — the token page shows the
  `Colors`/`Sizes`/`Fonts` values live); auto-enumeration where possible
  (share the G04-T2 component list so new components appear
  automatically or fail a completeness check); a CI job that launches it
  offscreen and asserts a clean load; wire `python -m EasyApplication`
  (G06-T1) to open it once it exists.
- **Out:** per-component prose documentation (G08-T2); screenshot-diff
  visual regression (worthwhile follow-up — note it, don't build it
  here).

## Plan

1. Scaffold `examples/Gallery` on the decoupled base (own page model:
   one page per module).
2. Elements page: a grid of every Element with a label; interactive
   states demoed (enabled/ disabled/checked). Components page:
   representative instantiations (window furniture shown in-place or via
   screenshots where a full-window component can't nest). Charts page:
   the G02 façade types with sample data. Style page: token
   swatches/values.
3. Completeness check: compare the gallery's component list against the
   module file list (same enumeration as G04-T2's smoke); fail CI if a
   new component isn't represented.
4. CI: run offscreen, assert no QML errors (reuse the smoke harness).

## Deliverables

- `examples/Gallery`; the completeness check; the CI job; a docs page
  linking to it with a screenshot.

## Acceptance gates

- The gallery renders every Element + Component (completeness check
  green), light + dark.
- CI loads it headlessly with zero QML errors/warnings.
- Adding a new Element without a gallery entry fails the completeness
  check (prove once, revert).

## Review focus

That the completeness check enumerates (not hand-lists); dark-theme
rendering actually inspected; the gallery itself follows the style guide
(it will be copied as the reference).

## Definition of done

I-0025's gallery half delivered (issue closes with G08-T2); `status.yml`
updated.
