# G08-T4: Branding & docs-drift cleanup

- **Class:** mechanical
- **Status:** ready
- **Depends:** — (independent; coordinate with G01-T4 which fixes the
  `.pro` path)
- **Issues:**
  [I-0019](../../issues/open/I-0019-stale-easyapp-branding.md),
  [I-0032](../../issues/open/I-0032-examples-md-missing-assets.md)
- **Anchors:**
  [findings-governance-ci.md §Hygiene, §EXAMPLES.md drift](../../issues/audit-2026-07/findings-governance-ci.md)

## Goal

No stale `EasyApp` identity anywhere in `examples/` (SPDX headers, dead
GitHub links), and `EXAMPLES.md` only references things that exist
(launch config, images, correct PySide guidance).

## Scope

- **In:** the I-0019 steps (normalise SPDX via
  `tools/license_headers.py` extended to `examples/`; fix the
  `github.com/EasyScience/EasyApp` link; header check in CI for
  examples) and the I-0032 steps (commit or drop the
  `.vscode/launch.json` reference; fix/drop the missing screenshot;
  align the PySide6 version guidance with pyproject/Decision E; docs
  link-check — shared with G08-T2, wire it in whichever lands first).
- **Out:** the `.pro`/`.qrc` path fixes (G01-T4); rewriting EXAMPLES.md
  content beyond the drift fixes.

## Plan

Follow
[I-0019 §Suggested fix](../../issues/open/I-0019-stale-easyapp-branding.md)
1–4 and
[I-0032 §Suggested fix](../../issues/open/I-0032-examples-md-missing-assets.md)
1–4. For the launch-config decision: committing a real
`.vscode/launch.json` with per-example configurations is the better
option (the examples exist to be run) — ask the owner only if VS Code
support is to be dropped entirely.

## Deliverables

- Normalised headers; fixed links; a working (or removed) VS Code launch
  story; aligned version text; the link-check + header-check gates.

## Acceptance gates

- I-0019 acceptance verbatim
  (`grep -Rn "EasyApp\b" examples/ | grep -v EasyApplication` → ∅;
  header check green over examples).
- I-0032 acceptance verbatim (every repo-relative reference in
  EXAMPLES.md exists; version guidance consistent).

## Review focus

The SPDX normalisation doesn't clobber third-party attribution
(JsonListModel's KDAB/Goessner headers, font licenses — those are _not_
project headers).

## Definition of done

I-0019 + I-0032 closed; `status.yml` updated.
