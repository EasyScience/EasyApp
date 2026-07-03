# I-0032: `EXAMPLES.md` references files that don't exist and a stale PySide pin

- **Status:** open
- **Priority:** Low
- **Area:** docs
- **Targets:** both
- **Found:** 2026-07 GUI base audit (round 2)
- **Related:** I-0019, I-0025; milestone M08

## Problem

`EXAMPLES.md` (the only substantive how-to document) references
repository assets that are not in the repo:

- `EXAMPLES.md:79` — "The initial launch configuration is in the
  `.vscode/launch.json` file, which should be automatically read by VS
  Code" → there is **no `.vscode/` directory**.
- `EXAMPLES.md:162` —
  `![Debug dropdown window](resources/images/vscode_debug.jpg)` → there
  is **no `resources/` directory**; the image link is broken.
- `EXAMPLES.md:47` instructs `pip install 'PySide6>=6.8,<6.9'` while
  `pyproject.toml` requires unpinned `PySide6` and the WASM CI targets
  Qt **6.9** — the pin contradicts both.

(Note: the five example apps themselves — BasicQml, BasicPy,
IntermediatePy, AdvancedPy, BasicC++ — all exist; the drift is in the
referenced assets/pins, not the example set.)

## Impact

- A newcomer following the document hits a missing launch config, a
  broken image, and an out-of-date version pin — small individually, but
  this is the front-door doc.

## Suggested fix

1. Either commit a real `.vscode/launch.json` (with configurations for
   the Python examples) or delete the VS Code launch-config paragraph.
2. Either add the screenshot at the referenced path or drop the image
   reference.
3. Align the PySide6 install instruction with `pyproject.toml` and the
   CI Qt version (state the supported range once, ideally referencing
   the Decision E Qt baseline).
4. Add a docs link-check (e.g. a markdown link checker over `*.md`) to
   CI so broken repo-relative references fail (fits M08 docs work).

## Acceptance criteria

- Every repo-relative path referenced by `EXAMPLES.md` exists (link
  check green in CI).
- The PySide6 version guidance matches `pyproject.toml`/CI.
