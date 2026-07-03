# M07-T2: One canonical translator, wired and tested

- **Class:** standard
- **Status:** blocked (needs M07-T1's `.ts` to prove retranslation
  end-to-end)
- **Depends:** M07-T1
- **Issues:**
  [I-0029](../../issues/open/I-0029-translator-wiring-inconsistent.md)
- **Anchors:**
  [findings-reusability-python.md §6](../../issues/audit-2026-07/findings-reusability-python.md)

## Goal

Exactly one canonical translator interface — `languages` (list of
`{code, name}`), `defaultLanguageIndex` (a value),
`selectLanguage(index)` — implemented by the Python (`QTranslator`)
backend for the PySide path, honoured by the QML fallback, consumed
correctly by `PreferencesDialog`, and proven by a runtime language
switch that retranslates visible text. Today the language UI is broken
against **both** implementations (see the issue's evidence).

## Scope

- **In:** the four steps of
  [I-0029 §Suggested fix](../../issues/open/I-0029-translator-wiring-inconsistent.md)
  — define the interface; fix `PreferencesDialog.qml:305-308` (drop the
  `()` call; model from `languages`); delete the `languagesAsXml()`
  relic + the commented `XmlListModel` import; wire the Python
  translator in the example `main.py` as `pyTranslator`; unit +
  functional tests. Ship a second language `.qm` with a handful of
  translated strings purely as the test fixture.
- **Out:** real translation content (community/later); the C++/WASM
  translation loading (note the seam: Qt native `QTranslator` in the C++
  host — document, don't build here).

## Plan

Follow the issue's fix steps 1–4 in order. The functional test: switch
language in `PreferencesDialog`, assert a known `qsTr()` label changes
(uses the retranslate + the `TranslationChange` animation path).

## Deliverables

- Canonical interface documented (style guide/i18n section); fixed
  dialog; wired example; the fixture `.qm`; tests.

## Acceptance gates

- I-0029 acceptance verbatim (one canonical API; runtime switch updates
  visible text — functional-tested; selection logic unit-tested).
- The language ComboBox is populated and functional under the wired
  example (was empty/erroring).

## Review focus

Property-vs-function access on the Python `@Property`s (the original bug
class); behaviour when zero `.qm` files are present (must degrade to
English, no error).

## Definition of done

I-0029 closed; `status.yml` updated.
