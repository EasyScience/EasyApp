# Milestones

A **milestone** is a single coherent, externally-checkable deliverable
that bundles several issues into one capability, with a hard definition
of done. Milestones are **stabilise-first**: correctness and the broken
web target come before polish. They sit above the
[issues](../issues/index.md) (the individual findings) and the
[roadmap](../roadmap/index.md) (the ordered plan);
[`status.yml`](../roadmap/status.yml) is authoritative for status.

## Milestones

| #                                    | Milestone                                     | Phase | Bundles                                    | Status    | Definition of done (short)                                               |
| ------------------------------------ | --------------------------------------------- | ----- | ------------------------------------------ | --------- | ------------------------------------------------------------------------ |
| [01](01-wasm-revival-cmake.md)       | Web/WASM revival + CMake module build         | I     | I-0004, 0009, 0001, 0020, 0013, 0005, 0033 | 🗓 planned | WASM app builds from a generated manifest; CI gates it                   |
| [02](02-render-everywhere.md)        | Render everywhere (charts & settings on WASM) | I     | I-0002, 0016, 0003                         | 🗓 planned | 1-D/2-D/3-D charts + settings work on desktop **and** WASM; no WebEngine |
| [03](03-decouple-easydiffraction.md) | Decouple the library from EasyDiffraction     | I     | I-0006, 0022, 0007, 0008, 0012             | 🗓 planned | No product literals / page enums / updater in the library core           |
| 04                                   | QML tooling & test pyramid                    | II    | I-0026, 0021, 0010, 0018                   | 🗓 planned | `qmllint`/`qmlformat`/Qt Quick Test required in CI                       |
| 05                                   | Modern-Qt migration                           | II    | I-0011, 0023, 0028, 0024, 0031             | 🗓 planned | No private-API reliance; unversioned imports; HiDPI clean; no `eval`     |
| 06                                   | Packaging & distribution                      | II    | I-0014, 0015, 0027                         | 🗓 planned | Dual distribution defined+working; fonts/deps pruned                     |
| 07                                   | i18n & accessibility                          | III   | I-0017, 0029                               | 🗓 planned | User text translatable; one wired translator; a11y roles                 |
| 08                                   | Docs, component gallery & style guide         | III   | I-0025, 0030, 0019, 0032                   | 🗓 planned | Gallery + catalog + enforced style guide published                       |
| 09                                   | edi handoff readiness                         | III   | —                                          | 🗓 planned | Semver + shared-session seam + beta→components migration guide           |

A milestone is **done** when its definition of done holds and every
bundled issue meets its acceptance criteria (moved to `issues/closed/`).
Phase I (G01–G03) is the gate for `edi` to begin its own surfaces; Phase
II/III harden and document.

## Phase I is the critical path

The audit's headline is that the **web target is broken and the library
is entangled with EasyDiffraction**. Nothing else matters until those
are fixed, so all three Phase-I milestones are priority 5 and should run
first (G01 ∥ G03, then G02). Detailed pages:
[G01](01-wasm-revival-cmake.md) · [G02](02-render-everywhere.md) ·
[G03](03-decouple-easydiffraction.md). Phase II/III milestones follow
the same page format when they become active.
