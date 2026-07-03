# I-0012: `RemoteController.qml` pulls `QtTest` + `QtMultimedia` into the shipped library

- **Status:** open
- **Priority:** Medium
- **Area:** qml
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0007, I-0010; milestone M03

## Problem

`Gui/Elements/RemoteController.qml` is a "guided tutorial / screencast"
automation harness that is part of the **shipped** component library.
It:

- `import QtTest` and instantiates `TestUtil`, `TestResult`, `TestEvent`
  — the **Qt Quick Test** module — in production UI, to synthesize
  mouse/keyboard events and grab screenshots;
- `import QtMultimedia` for spoken narration (`Audio`);
- **vendors ~200 lines** of Qt's private
  `qtest_compareInternal`/`qtest_typeof` comparison code copy-pasted
  from the Qt sources;
- reads `EaGlobals.Vars.projectConfig.ci.app.tutorials.video.fps` — more
  app/CI-specific config leaking into the library (see I-0006).

## Impact

- The runtime now depends on `QtTest` and `QtMultimedia` just to render
  normal UI — extra modules to deploy, and on **WASM** `QtTest`-driven
  event injection and `QtMultimedia` audio are not
  appropriate/available, so this element is dead weight or a load error
  on the web target.
- Vendored private test code is unmaintainable and can desync from Qt.
- A test/automation concern living in the product library blurs the line
  the whole audit is trying to draw (generic UI vs app/tooling).

## Suggested fix

1. **Move the tutorial/screencast harness out of the core library** into
   a dev/tooling module or into the consuming app's test tree — it is
   not a UI building block.
2. If an in-app "guided tour" feature is genuinely wanted, reimplement
   it **without `QtTest`**: drive the pointer with normal QML animations
   and `QPointer`/`MouseArea`, not synthetic test events; make audio
   narration optional and desktop-only.
3. Delete the vendored `qtest_*` comparison functions.
4. Ensure nothing in the shipped `Elements/`/`Components/` imports
   `QtTest`.

## Acceptance criteria

- `grep -R "import QtTest" src/` returns nothing in the shipped library.
- The WASM and desktop smoke test (I-0010) loads the full `Elements` set
  without needing the `QtTest`/`QtMultimedia` modules.
- Any retained "guided tour" feature is opt-in and does not import
  `QtTest`.
