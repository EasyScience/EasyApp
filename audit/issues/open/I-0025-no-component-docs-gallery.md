# I-0025: No component documentation or gallery — docs are near-empty

- **Status:** open
- **Priority:** Medium
- **Area:** docs
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0030; milestone G08

## Problem

For a library whose entire value is its ~90 QML components, the
documentation is effectively empty: `docs/docs/user-guide/index.md` is
**11 words**, `docs/docs/api-reference/index.md` is **11 words**,
`docs/docs/introduction/index.md` ~230 words. There is:

- no catalog of what components exist (`Elements`, `Components`,
  `Charts`, `Style` tokens),
- no per-component API (properties, signals, usage snippet),
- no visual gallery / live examples,
- no guidance on the layering (when to use an `Element` vs a
  `Component`).

The `EXAMPLES.md` explains how to _run_ the example apps but not what
the library _offers_.

## Impact

- The junior agents who will implement `edi` have no reference for the
  building blocks; they will re-discover the API by reading source (as
  this audit had to), or reinvent components.
- Onboarding and reuse are slow; the base does not "sell" its own
  components.

## Suggested fix

1. **Generate a component catalog.** One page per module listing each
   type with its public properties/signals and a minimal usage snippet.
   Where possible auto-extract from the QML (doc comments) so it can't
   rot.
2. **Add a live gallery example** — a small app (`examples/Gallery`)
   that renders every `Element` and `Component` in light/dark, doubling
   as a visual smoke test (ties to I-0010).
3. Document the **Style tokens** (`Colors`, `Sizes`, `Fonts`, `Times`)
   as the design-system reference.
4. Point the mkdocs build at the catalog/gallery; wire this `audit/`
   base into the docs nav so the audit/roadmap render alongside.
5. Establish a doc-comment convention for QML in the style guide
   (I-0030).

## Acceptance criteria

- A browsable catalog documents every `Elements/*` and `Components/*`
  type with properties and a snippet.
- A `Gallery` example renders all components and is run in CI as a smoke
  test.
- The `audit/` base is reachable from the published docs.
