# G03-T4: Lift the tutorial/QtTest harness out of the core library

- **Class:** standard
- **Status:** ready
- **Depends:** — (independent of G03-T1..T3; touches only the harness
  files)
- **Issues:**
  [I-0012](../../issues/open/I-0012-qttest-qtmultimedia-in-shipped-lib.md)
- **Anchors:**
  [findings-reusability-python.md §5](../../issues/audit-2026-07/findings-reusability-python.md)

## Goal

The shipped library no longer imports `QtTest` or `QtMultimedia`. The
tutorial/screencast automation (`RemoteController`, `RemotePointer`,
`GuideWindow*`) moves out of the core `Elements`/ `Components` modules —
either into a clearly-separated dev/tooling module or into the consuming
app's test tree.

## Scope

- **In:** relocate `Gui/Elements/RemoteController.qml` (+
  `RemotePointer.qml` if it has no other consumer) out of the shipped
  Elements module; delete the ~200 vendored `qtest_*` compare functions;
  remove the `projectConfig.ci.app.tutorials.*` read; decide (with the
  owner) whether `GuideWindow`/`GuideWindowContainer` (a user-facing
  guided-tour UI, not test-driven) stays — if it stays, it must not
  depend on the harness.
- **Out:** building a replacement in-app tour feature (only if the owner
  asks; then without `QtTest`, per the issue's step 2); the page model
  (G03-T1).

## Plan

Follow
[I-0012 §Suggested fix](../../issues/open/I-0012-qttest-qtmultimedia-in-shipped-lib.md)
steps 1–4. Concretely: create `tools/qml-harness/` (or the consuming
app's tests tree) as the new home; move the files; drop them from
`Elements/qmldir` (or the CMake module list post-G01);
`grep -R "RemoteController\|RemotePointer" src examples` and fix any
dangling references.

## Deliverables

- Core modules free of `QtTest`/`QtMultimedia`; harness relocated with a
  README note on how the screencast tooling is run now; `qmldir`/module
  lists updated.

## Acceptance gates

- `grep -rn "import QtTest\|import QtMultimedia" src/` → nothing.
- The QML smoke-load test (G04-T2, once present) passes without the
  `QtTest`/`QtMultimedia` modules installed; the WASM build does not
  package the harness.
- The example apps run unchanged.

## Review focus

Hidden consumers of `RemoteController` functions (search for
`rc.`/`remoteController` usages in examples and in `easydiffractionbeta`
before deleting anything); `GuideWindow` decision recorded.

## Definition of done

I-0012 acceptance criteria met; `status.yml` updated; issue closed with
a Resolution note.
