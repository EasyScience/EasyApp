# G08-T2: Component catalog docs + knowledge base wired into the site

- **Class:** standard
- **Status:** draft (promote once G08-T1 exists to screenshot from)
- **Depends:** G08-T1
- **Issues:**
  [I-0025](../../issues/open/I-0025-no-component-docs-gallery.md)
  (catalog half)
- **Anchors:** `docs/mkdocs.yml` (nav currently: Introduction /
  Installation & Setup / User Guide / API Reference — the latter two are
  ~11 words each)

## Goal

A browsable catalog: one docs page per module listing every public type
with its properties, signals, and a minimal usage snippet (plus a
gallery screenshot where it helps). The `audit/` base (issues, roadmap,
design) is reachable from the published site. The near-empty user-guide/
api-reference stubs are replaced.

## Scope

- **In:** per-module catalog pages (Elements, Components, Charts, Style
  tokens, Globals seams); extraction tooling — prefer generating the
  property/signal tables from the QML (a small parser or `qmldom`-based
  script) so the catalog can't rot; mkdocs nav rework (Catalog / Style
  tokens / Guides / Knowledge); wire `audit/` into the nav (or publish
  it as a section, crysta-style); a QML doc-comment convention added to
  the style guide.
- **Out:** the gallery app (G08-T1); tutorial-style guides beyond one
  "build a small app on the base" walkthrough.

## Plan

1. Write the extractor (type → properties/signals with types and
   defaults where declarable); generate into
   `docs/docs/catalog/<module>.md` at docs-build time (mkdocs hook, like
   crysta's roadmap hook).
2. Hand-write the per-type one-line description + snippet blocks (these
   live in QML doc comments so they version with the code).
3. Rework `mkdocs.yml` nav; add the `audit/` section; fix the stub
   pages.
4. Add a docs link-check to CI (also serves I-0032).

## Deliverables

- The extractor + mkdocs hook; catalog pages for all modules; new nav
  with `audit/` wired; the link-check.

## Acceptance gates

- Every public type in every module appears in the catalog with ≥
  properties table + snippet (completeness checked by the extractor
  against the module lists).
- `mkdocs build` green; knowledge pages render; link-check green.
- A doc comment added to a QML file appears in the built catalog (prove
  the pipeline).

## Review focus

Generated-vs-hand-written boundaries are clear (regeneration must not
eat hand-written prose); the extractor handles singletons and attached
properties sanely or skips them explicitly.

## Definition of done

I-0025 closed (with G08-T1); `status.yml` updated.
