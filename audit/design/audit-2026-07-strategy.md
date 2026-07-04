# Strategy & long-term improvements — 2026-07 GUI base audit

The analysis behind the [issue tracker](../issues/index.md) and
[roadmap](../roadmap/index.md): what state the base is in, where it
should go, and the long-term improvements beyond the immediate fixes.
Written to brief the owner and the implementing agents on _why_ the plan
is ordered as it is.

## Executive summary

`gui-components` (`EasyApplication`) is a mature-looking Qt/QML
component library with a genuinely good **visual design system**
(coherent Style tokens, a clean Elements→Components layering, theming
with animated transitions, a broad control set). It works today as the
desktop-Python GUI base for `easydiffractionbeta`.

But measured against the goal — _a solid, robust, sustainable,
maintainable base for a **new** product (`edi`) shipping on **desktop
and web/WASM**_, built by **less-advanced agents** — it has three
structural gaps:

1. **The web/WASM target is broken and architecturally blocked.** The
   C++ build's resource manifest rotted at the
   `EasyApp`→`EasyApplication` rename (I-0001); the charts/report need
   `QtWebEngine`, which does not exist on WASM (I-0002); settings
   persistence throws in the browser (I-0003); and the WASM CI never
   runs, so none of this was caught (I-0005).
2. **It is entangled with EasyDiffraction.** App page names, the product
   name, an auto-updater pointing at EasyDiffraction's servers, and a
   `QtTest`-based tutorial harness are compiled into the "generic"
   library (I-0006, I-0007, I-0012). A second product cannot adopt it
   cleanly.
3. **The engineering foundation is classic-only and ungated.** No
   CMake/`qt_add_qml_module`, no QML linting/formatting, no real tests
   (all `test_dummy.py`), reliance on private Qt internals in 33 files,
   and a repo scaffolded from a generic _Python-library_ template that
   checks the thin Python shell while the thick QML core goes ungated
   (I-0004, I-0009, I-0010, I-0011, I-0018, I-0026).

None of this requires a rewrite. It requires **hardening + decoupling**
on top of the good design system, in a deliberate order: unbreak the web
target on a drift-proof build, decouple from EasyDiffraction, then gate
quality so the hardening sticks.

## The three-phase plan (and why this order)

- **Phase I — Unbreak & stabilise (G01–G03).** Restore the web target on
  a CMake module build that _cannot_ drift (G01), make it actually
  render and persist on WASM (G02), and decouple it from EasyDiffraction
  (G03). After Phase I, `edi` can start building its surfaces on a base
  that builds everywhere and isn't someone else's app. G01 and G03
  parallelise (build vs decoupling).
- **Phase II — Sustainable engineering (G04–G06).** Gate the _actual
  product_: `qmllint`, `qmlformat`, Qt Quick Test required in CI (G04);
  retire private-API reliance and modernise imports (G05); define a real
  distribution model and prune deps/fonts (G06). This is what makes the
  base _maintainable_ by many hands.
- **Phase III — Solid base for edi (G07–G09).** i18n/a11y (G07),
  documentation + a component gallery + an enforced style guide (G08),
  and the `edi` handoff seam + semver (G09). This is what makes the base
  _followable_ by less-advanced agents.

## Long-term improvements (beyond the issue fixes)

These are not individual bugs; they are the direction that keeps the
base healthy for years.

1. **One build system, generated artifacts.** Standardise on CMake
   `qt_add_qml_module` as the source of truth for module identity,
   resources, and compiled QML. Hand-maintained `.qrc`/`.pro` is how
   I-0001 happened; generated manifests make that class of bug
   impossible. Keep the PySide interpreted path as a thin consumer of
   the same source tree (dual distribution — see
   [architecture-target.md](architecture-target.md)).
2. **A stable façade layer for anything platform-divergent.** Charts,
   settings, file dialogs, clipboard, update-check, and audio behave
   differently (or don't exist) on WASM. Put each behind a small QML
   façade with a fixed property API and a target-aware backend, so app
   code is written once and the platform difference lives in one file.
   (G02 does charts + settings; extend the pattern.)
3. **Decoupling by construction, enforced.** The library must contain
   **zero** product literals and **zero** named app pages. Make that a
   CI grep gate, not a convention — so it can't regress as new agents
   contribute. Everything app-specific enters via injected data
   (`ApplicationInfo`, a page model, an optional update service).
4. **Compiled, type-safe QML.** Move from context-property injection
   (`typeof pyX !== "undefined"` in `Vars.qml`) and `var` properties
   toward `required property`, typed properties, and
   `QML_ELEMENT`/singleton registration, so `qmlsc` can compile QML to
   C++ (startup + WASM wins) and `qmllint` can actually check it.
5. **A test pyramid whose base is a smoke-load.** The single
   highest-value test is "does every component instantiate without a QML
   error", run headless in CI on desktop and WASM. It would have caught
   I-0001/I-0013/I-0020 for near-zero cost. Build up from there
   (interactive Qt Quick Test, Python backend units, a visual gallery).
6. **The library documents itself.** A component gallery that renders
   every Element/Component (in light+dark) doubles as living
   documentation _and_ a visual smoke test. Junior agents building `edi`
   should be able to browse "what exists and how to use it" without
   reading source.
7. **Design tokens as a first-class, exportable system.** The Style
   singletons are already a de facto design system; formalise them
   (documented token names, light/dark, the sizing scale) so they can be
   shared with non-Qt surfaces (web docs, marketing) and evolved
   deliberately.
8. **Accessibility and i18n as defaults, not retrofits.** Establish
   `qsTr()`-everywhere and `Accessible` roles as conventions now, while
   the base is ~90 components, rather than across a grown `edi`.
9. **Version and support the base like a product.** Semver, a changelog,
   and a documented support window for Qt versions — so `edi` can pin a
   known-good base and upgrade deliberately.

## What to preserve (do not "improve" away)

- The **Style token system** (`Colors`/`Sizes`/`Fonts`/`Times`) and the
  dark/light palette — it is hand-tuned and coherent.
- The **Elements (primitive) → Components (composed)** layering — it is
  the right shape; just rename the ambiguous base window (I-0028) and
  document it (I-0030).
- The **animated theming/translation transitions**
  (`Behavior on color { ThemeChange {} }`) — a nice touch that gives the
  app polish; keep them target-aware.
- The **breadth of controls** — the library already covers most of what
  an analysis app needs.

## Risks & mitigations

- **Chart migration is the biggest single effort** (10 files + report,
  plus a library choice). De-risk by validating the ratified library
  choice (Decision A: QtGraphs) on a measured 1-D prototype in G02-T1
  before doing 2-D/3-D.
- **CMake migration could disturb the working PySide path.** Mitigate by
  keeping the raw `.qml` in place and treating CMake as an additional
  consumer (dual build), landing modules incrementally (G01-T1 beachhead
  first).
- **Decoupling churns many files.** Mitigate with the smoke-load test
  (G04-T2) landed early so the churn is caught, and CI grep gates so
  decoupling can't silently regress.
- **Less-advanced implementing agents.** Mitigate with explicit task
  packets (done), an enforced style guide (I-0030/G08), and the
  [writing-for-junior-agents](../process/writing-for-junior-agents.md)
  conventions.

## Open decisions (ratify before Phase I code)

See [decisions-to-confirm.md](decisions-to-confirm.md): the chart
library, the build/distribution model, the template framing, and how far
to split app-specific screens out of the library. These change _how_
Phase I is executed and are cheap to decide now, expensive to reverse
later.
