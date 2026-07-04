# Decisions to confirm (owner ratification before Phase I code)

Modelled on crysta's owner-confirmed decision record. These are the
genuine forks the audit surfaced: each changes _how_ the plan is
executed and is cheap to decide now, expensive to reverse after code
lands. The **recommended** option is stated first with rationale; the
owner ratifies (or overrides), then the relevant task's design step
proceeds.

Status key: 🔵 proposed (awaiting owner) · ✅ ratified · ⛔ overridden.

---

## Decision A — Charting library (blocks G02) ✅

**Ratified 2026-07-03 (owner):** **A1 — QtGraphs.** Validate on a
measured 1-D prototype in G02-T1 before committing 2-D/3-D. Rationale:
strategic, WASM-capable, full 1D/2D/3D breadth; aligns with the Qt 6.9
WASM target (Decision E1).

**Question:** what replaces the QtWebEngine/Plotly charts for a stack
that works on desktop **and** WASM?

- **A1 (recommended): QtGraphs** (Qt ≥ 6.7). GPU-accelerated,
  WASM-capable, the strategic successor to Qt Charts + Data
  Visualization; covers 1-D line/scatter, 2-D heatmaps, 3-D surfaces —
  the full breadth the Plotly stack provides. Requires a recent Qt
  (already targeting 6.9 for WASM).
- **A2: Qt Charts** (`QtCharts`). Already partly used here
  (`QtCharts1dBase`), simplest 1-D migration, WASM-capable — but weaker
  2-D/3-D story (pair with Data Visualization) and in maintenance mode
  relative to QtGraphs.
- **A3: custom `QQuickItem`/`ShaderEffect`** for the hot 1-D pattern
  only, if profiling shows QtGraphs/Charts can't hit the live-fit frame
  budget on 10⁴–10⁵ points.

**Recommendation:** A1, validated by a measured 1-D prototype in G02-T1
before committing to 2-D/3-D.

---

## Decision B — Build & distribution model (blocks G01) ✅

**Ratified 2026-07-03 (owner):** **B1 — dual build, one source tree.**
CMake `qt_add_qml_module` is the source of truth for C++/WASM (generated
manifests, compiled QML); PySide6 keeps interpreting the same raw `.qml`
for desktop-Python. Ship a wheel (desktop) + a CMake package (C++/WASM).
Rationale: keeps the working desktop path untouched while giving the web
target a real, drift-proof build.

**Question:** how do desktop-Python and C++/WASM consume the QML?

- **B1 (recommended): dual build, one source tree.** CMake
  `qt_add_qml_module` is the source of truth (module identity, generated
  resources, compiled QML) for the C++/WASM path; PySide6 keeps
  interpreting the same raw `.qml` for the desktop-Python path.
  Distribute a Python wheel (desktop) **and** a CMake package
  (C++/WASM).
- **B2: CMake-only.** Everything (including the PySide app) consumes the
  CMake-built module. Cleaner single path, but forces the desktop-Python
  app onto compiled modules and a heavier build for a currently-simple
  `pip install`.
- **B3: keep interpreted-only** and just repair the hand `.qrc`.
  Rejected — this is how I-0001 happened; it does not deliver compiled
  QML or drift-proof manifests.

**Recommendation:** B1. Keeps the working PySide path untouched while
giving the web target a real, generated, compiled build.

---

## Decision C — Template framing (affects G04, feeds `edi`) 🔵

**Question:** the repo is scaffolded from a generic Python-lib template
(I-0018); how do we add QML-native tooling?

- **C1 (recommended): add a `qml`/GUI variant to
  `easyscience/templates`** and re-derive, so QML
  linting/format/test/CMake are first-class and `edi` inherits them.
- **C2: bolt QML tooling onto the current answers** without changing the
  template. Faster now, but the gap recurs in the next repo.

**Recommendation:** C1 if the template is actively maintained (it is:
`_commit: v0.11.0`); otherwise C2 with a tracked follow-up to upstream
it.

---

## Decision D — How far to split app-specific screens out of the library (affects G03) 🔵

**Question:** beyond the seams (page model, `ApplicationInfo`, updater),
how aggressively do we move diffraction-specific _screens_ (e.g.
`ProjectDescriptionDialog`, report pipeline) out of the library?

- **D1 (recommended): seams now, screens incrementally.** Land the
  injection seams (G03) so the library is _structurally_ generic and
  CI-enforced; move individual app-specific screens to the app
  opportunistically as `edi` needs them, keeping a clearly-marked
  `recipes/` area for shared-but- non-core compositions.
- **D2: hard split now** — move every non-generic screen out in G03.
  Cleaner boundary immediately, but larger churn and risk while the web
  target work is in flight.

**Recommendation:** D1 — get the enforced boundary and the seams first;
relocate screens as a steady follow-through.

---

## Decision E — Minimum supported Qt version 🔵

**Question:** what Qt baseline do we pin?

- **E1 (recommended): Qt 6.8 LTS or 6.9**, matching the WASM CI (already
  6.9) and enabling QtGraphs (Decision A1), `qt_add_qml_module`
  maturity, and `MultiEffect`. Document the support window.
- **E2: a lower 6.x** for broader compatibility — but loses QtGraphs and
  some `qt_add_qml_module` ergonomics.

**Recommendation:** E1 (6.9 for WASM parity; 6.8 LTS acceptable if a
stable LTS is preferred and QtGraphs availability is confirmed on it).

---

### How to ratify

For each: set status ✅/⛔, add a one-line rationale + date + owner, and
(if overridden) the chosen option. The blocked design tasks (G01-T1,
G02-T1, G04-T3, G03) read this file at their design step.
