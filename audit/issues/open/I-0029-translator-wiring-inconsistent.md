# I-0029: Two `Translator` implementations with different constructors; the Python one isn't wired

- **Status:** open
- **Priority:** Medium
- **Area:** python
- **Targets:** both
- **Found:** 2026-07 GUI base audit
- **Related:** I-0017; milestone G07

## Problem

There are two different `Translator`s:

- **QML/JS** `Gui/Logic/Translate.js` — `Vars.qml` falls back to
  `new EaLogic.Translate.Translator()` (no args).
- **Python** `Logic/Translate.py` — `class Translator(QObject)` whose
  constructor **requires four args**
  `(app, engine, translations_path, languages)`.

`Vars.translator` picks `pyTranslator` if the host injected one, else
the JS fallback. But the example apps (e.g. `AdvancedPy/main.py`) never
construct/register the Python `Translator`, so the Python path is
effectively unused and untested. The two implementations have
incompatible APIs, so QML written against one won't work against the
other.

**The one consumer proves the break** —
`Components/PreferencesDialog.qml:305-308`:

```qml
model: EaGlobals.Vars.translator.languages
onActivated: EaGlobals.Vars.translator.selectLanguage(currentIndex)
Component.onCompleted: currentIndex = EaGlobals.Vars.translator.defaultLanguageIndex()
```

- Against the **JS fallback**: `Translate.js`'s class has **no
  `languages` member at all** (only a `languagesAsXml()` relic for the
  commented-out `XmlListModel` approach — `PreferencesDialog.qml:6`), so
  the ComboBox model is `undefined` → an empty language selector.
- Against the **Python translator**: `defaultLanguageIndex` is a
  `@Property`, but the QML calls it **as a function**
  (`defaultLanguageIndex()`) → a runtime error.

So the language UI is broken under _both_ resolutions, differently.

Also, `Translate.py.selectDefaultLanguage` calls
`self.selectLanguage(self.defaultLanguageIndex)` passing the property
(works, but subtle) — worth a test to pin behaviour.

## Impact

- i18n is half-connected: the machinery exists but the real (Python)
  translator is never wired, and the only language-selection UI is
  demonstrably broken against both implementations — language switching
  does not work end-to-end today.
- Ambiguity about which `Translator` is canonical blocks the qsTr sweep
  (I-0017) from having a reliable runtime.

## Suggested fix

1. **Pick one canonical translator** (recommend the Python
   `QTranslator`-backed one for the PySide path; for the C++/WASM path
   use Qt's native translation loading). Delete or clearly demote the
   other to avoid two APIs.
2. **Define the canonical interface and make both sides honour it**:
   `languages` (a list of `{code, name}`), `defaultLanguageIndex` (a
   value, not a call), `selectLanguage(index)`. Update
   `PreferencesDialog.qml:305-308` to that interface (drop the `()`
   call; delete the `languagesAsXml()` relic and the commented
   `XmlListModel` import at `PreferencesDialog.qml:6`).
3. Wire it in the example(s): construct the translator in `main.py`,
   register it, and expose it as `pyTranslator` so `Vars.translator`
   resolves to it. Provide a real language switch in the preferences
   dialog and prove retranslate works.
4. Add a unit test for language sorting/selection and a functional test
   that switching language updates a `qsTr()` string.

## Acceptance criteria

- Exactly one translator API is documented as canonical and is wired in
  the example app.
- Switching language at runtime updates visible `qsTr()` text
  (functional test).
- `Translate` language-selection logic has unit tests.
