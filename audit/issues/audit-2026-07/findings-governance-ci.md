# Findings — Governance, CI, tooling, docs, i18n

Backs **I-0010, I-0014, I-0017, I-0018, I-0019, I-0021, I-0025, I-0026,
I-0030**.

## Tests (I-0010)

Entire suite is placeholders:

```
tests/unit/test_dummy.py
tests/functional/test_dummy.py
tests/integration/fitting/test_dummy.py
tests/integration/scipp-analysis/test_dummy.py
```

**Zero** real assertions; **zero** QML tests (no Qt Quick Test /
`qmltestrunner`, no smoke-load). `fitting`/`scipp-analysis` are leftover
science-app scaffolding. `pixi run test` → only `unit-tests` (dummy).
`pyproject.toml` `fail_under = 0`. This is why I-0001 shipped green.

## CI / pre-commit gates (I-0026, I-0018)

- `.pre-commit-config.yaml`: every hook is `stages: [manual]` → nothing
  runs on commit/push automatically. Hooks are Python-only
  (pyproject-check, license-check, ruff lint/format, pydoclint,
  prettier, unit-tests). **No `qmllint`, no `qmlformat`, no QML tests.**
  `prettier` covers JSON/MD/YAML, not `.qml`.
- `.github/workflows/test.yml`: Python-only
  (`PY_VERSIONS: '3.12 3.14'`), runs `pytest` (dummy). No QML lint/test,
  no build of the actual GUI, no WASM (that's the dispatch-only
  `wasm.yml`, I-0005). 15+ workflows exist (docs, coverage, pypi,
  backmerge, security, dashboard…) — mature **Python-package**
  governance, zero **QML** governance.
- **Root cause (I-0018):** `.copier-answers.yml` → `template_type: lib`,
  `project_type: lib`, `_src_path: gh:easyscience/templates`. The repo
  is a **generic Python-library** scaffold: ruff, pydoclint, interrogate
  (docstring coverage), radon, versioningit, mkdocstrings, DOI, PyPI —
  all Python-lib concerns; QML/fonts/HTML treated as inert package data.
  The gates check the thin Python shell, not the thick QML core.

## Packaging entry point (I-0014)

`pixi.toml`: `EasyApplication = 'python -m EasyApplication'`, but no
`src/EasyApplication/ __main__.py` exists (`__init__.py` is an SPDX
header only) → the shortcut errors. Wheel packaging
(`[tool.hatch.build.targets.wheel] packages=['src/EasyApplication']`)
does ship the non-`.py` files (QML/fonts/HTML) since they are under the
package dir and not gitignored.

## Docs (I-0025)

`docs/docs/user-guide/index.md` = **11 words**; `api-reference/index.md`
= **11 words**; `introduction/index.md` ≈ 230. No component catalog, no
per-type API, no gallery, no layering guide. For a ~90-component library
this is effectively undocumented — junior agents must read source (as
this audit did).

## i18n (I-0017)

`qsTr(` appears in only **8 / 92** QML files → most display text is
hard-coded and untranslatable, despite a translation runtime
(`Translate.py/.js`, `TranslationChange`, retranslate). See also the
half-wired translator (I-0029).

## EXAMPLES.md drift (I-0032, round 2)

All **five** example apps exist on disk (BasicQml, BasicPy,
IntermediatePy, AdvancedPy, BasicC++ — a round-1 listing truncation
initially hid two). But `EXAMPLES.md` references assets that do not:
`:79` a `.vscode/launch.json` (no `.vscode/` dir), `:162` an image
`resources/images/vscode_debug.jpg` (no `resources/` dir), and `:47`
pins `PySide6>=6.8,<6.9` while `pyproject.toml` is unpinned and the WASM
CI targets Qt 6.9.

## Hygiene (I-0019, I-0021)

- `console.log/debug/error` in **18** QML files (several commented);
  singletons `console.debug` on every property change; `print()`
  debugging in `RemoteController.qml`.
- Stale `EasyApp` branding across `examples/`: SPDX
  `2024 EasyApp contributors`, `© … EasyApp project`, live link
  `github.com/EasyScience/EasyApp`, `.pro` `src/EasyApp` path. Copyright
  owner/year inconsistent with library files
  (`2026 EasyScience contributors`).

## Missing durable guidance (I-0030)

Real conventions exist (`Ea*` aliases, Elements/Components split,
`Style` tokens, `Behavior on color { ThemeChange {} }`) but are
**undocumented**. `edi`'s less-advanced implementing agents need an
explicit, enforced QML style guide (naming, layering, modern-Qt rules,
qsTr, testing) — see
[modern-qt-guidelines.md](../../design/modern-qt-guidelines.md).
