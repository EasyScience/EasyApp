# Roadmap

The development plan to turn `gui-components` into a solid, robust,
sustainable, maintainable GUI base for **desktop (PySide6)** and **web
(WASM/C++)**, ready for `enhantica/edi` to build on. Three phases, nine
milestones, one-session tasks — modelled on the
[crysta roadmap](https://github.com/enhantica/crysta).

**Status legend:** ✅ done · 🚧 active · 🗓 planned (priority 5/5 highest
… 1/5 lowest).

> [`status.yml`](status.yml) is the single source of truth; the tables
> here mirror it (add a generator hook later, cf. crysta's
> `roadmap_hook.py`). Task packets live in [`tasks/`](tasks/index.md).
> Every task carries one or more [issues](../issues/index.md).

## Guiding principles (from the audit)

1. **Unbreak before improve.** The web target is broken (I-0001/2/3);
   Phase I restores it and removes the _class_ of "manifest drift" bugs
   by moving to a real module build — not by patching the hand-written
   `.qrc`.
2. **Decouple before extend.** `edi` cannot adopt the base while
   EasyDiffraction is compiled into it (G03); decoupling is a Phase-I
   gate, not a nicety.
3. **Gate the actual product.** Today CI checks the Python shell, not
   the QML. Phase II makes `qmllint`/`qmlformat`/Qt Quick Test required
   so the hardening can't regress.
4. **Preserve the design system.** The Style tokens, Elements/Components
   layering, theming, and animations are good — keep them; the work is
   hardening + decoupling, not a rewrite.

## Milestones

| #   | Milestone                                     | Phase | Prio | Depends            | Bundles (issues)                                       |
| --- | --------------------------------------------- | ----- | ---- | ------------------ | ------------------------------------------------------ |
| G01 | Web/WASM revival + CMake module build         | I     | 5    | —                  | I-0004, I-0009, I-0001, I-0020, I-0013, I-0005, I-0033 |
| G02 | Render everywhere (charts & settings on WASM) | I     | 5    | G01                | I-0002, I-0016, I-0003                                 |
| G03 | Decouple the library from EasyDiffraction     | I     | 5    | —                  | I-0006, I-0022, I-0007, I-0008, I-0012                 |
| G04 | QML tooling & test pyramid                    | II    | 4    | G01                | I-0026, I-0021, I-0010, I-0018                         |
| G05 | Modern-Qt migration                           | II    | 3    | G04                | I-0011, I-0023, I-0028, I-0024, I-0031                 |
| G06 | Packaging & distribution                      | II    | 3    | G01                | I-0014, I-0015, I-0027                                 |
| G07 | i18n & accessibility                          | III   | 2    | G03                | I-0017, I-0029                                         |
| G08 | Docs, component gallery & style guide         | III   | 3    | G04                | I-0025, I-0030, I-0019, I-0032                         |
| G09 | edi handoff readiness                         | III   | 3    | G02, G03, G05, G08 | (forward-looking)                                      |

## Sequence & dependencies

```
Phase I (parallelisable, all priority 5):
  G01 ─┬─► G02 ─────────────┐
       │                    │
  G03 ─┼────────────────────┼─► G09  (edi handoff)
       │                    │
       └─► G04 ─► G05 ──────┤
                 │          │
           G06 ──┘   G08 ───┘
  G07 depends on G03; G08 depends on G04
```

- **Start G01 and G03 in parallel** — they don't conflict (G01 is
  build/CMake/CI; G03 is decoupling QML/Python). Both are prerequisites
  for a base `edi` can use.
- **G02 needs G01** (charts move as modules migrate to CMake).
- **G04 needs G01** (qmllint needs proper modules) and unlocks
  **G05/G08**.
- The **critical path to "edi can start its WASM surface"** is G01 → G02
  (web renders) plus G03 (decoupled). Everything else hardens quality
  and can follow.

## crysta ↔ gui-components ↔ edi bindings

`edi` is the product monorepo (desktop app + WASM app + shared session
layer). This base feeds its front-ends:

| edi surface              | Consumes from here                             | Ready after                   |
| ------------------------ | ---------------------------------------------- | ----------------------------- |
| Desktop app (QML/PySide) | `EasyApplication.Gui.*` modules, Style tokens  | G03 (decoupled) + G04 (gated) |
| Web app (WASM/C++)       | Same QML modules via CMake `qt_add_qml_module` | G01 + G02 (renders on WASM)   |
| Shared session layer     | Settings/theme/page-model/undo seams           | G03 + G09                     |

## How a task is run

See [process/operator-playbook.md](../process/operator-playbook.md). In
short: pick a `ready` task from [`tasks/index.md`](tasks/index.md); it
names its issues, plan, deliverables, and acceptance gates; implement;
make the acceptance gates (build + lint + tests) green; update
`status.yml` and close the carried issues.
