# I-0018: Repo scaffolded from a generic Python-library template — the root cause of the tooling gaps

- **Status:** open
- **Priority:** Medium (root-cause; enables many others)
- **Area:** process
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0004, I-0010, I-0026, I-0027; milestone G04; evidence
  [findings-governance-ci.md](../audit-2026-07/findings-governance-ci.md)

## Problem

`.copier-answers.yml` shows the repo was generated from
`gh:easyscience/templates` with `template_type: lib` /
`project_type: lib` — a **generic Python-library** template. Everything
downstream reflects that framing rather than "Qt/QML component library":

- Tooling is 100% Python: `ruff`, `pydoclint`, `interrogate` (docstring
  coverage), `radon`, `pytest`, versioningit, mkdocstrings. **Zero** QML
  tooling (no `qmllint`, `qmlformat`, `qmltestrunner`, no CMake).
- `numpy` is a default scientific-lib dependency (I-0027), irrelevant to
  QML.
- QML/fonts/HTML are treated as inert _package data_ inside a wheel — so
  the actual product (the QML) has no lint, no format, no test, no type
  registration.
- Docstring coverage, DOI, and PyPI machinery are emphasised; a
  component gallery / QML API docs are absent (I-0025).

This is not a bug in any one file; it is the framing that produced the
whole class of gaps.

## Impact

- The project's quality gates check the _thin Python shell_ and ignore
  the _thick QML core_. CI is green while the QML/web build is broken
  (I-0001).
- `edi` risks inheriting the same template framing.

## Suggested fix

1. Treat this as an explicit decision (see
   [decisions-to-confirm.md](../../design/decisions-to-confirm.md)):
   either extend the `easyscience/templates` with a **`qml`/GUI
   variant**, or layer QML-specific tooling on top of the current
   answers.
2. Add the missing QML-native gates (these are their own issues):
   CMake/`qt_add_qml_module` (I-0004), `qmllint`+`qmlformat` (I-0026),
   Qt Quick Test (I-0010).
3. Re-evaluate the Python-library assumptions: is `numpy` needed
   (I-0027)? is docstring-coverage the right primary metric for a QML
   lib? Point the docs build at a component gallery (I-0025).
4. Keep what genuinely helps (ruff/format for the Python backend,
   versioningit, pre-commit harness) — but make it un-manual (I-0026)
   and add the QML equivalents.

## Acceptance criteria

- The chosen approach (template variant vs. bolt-on) is recorded in
  `decisions-to-confirm.md`.
- CI and pre-commit run QML lint/format/test in addition to the Python
  checks.
- The template-origin decision is reflected back into
  `easyscience/templates` if a GUI variant is chosen, so `edi` inherits
  it.
