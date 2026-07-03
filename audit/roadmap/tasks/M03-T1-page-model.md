# M03-T1: Data-driven app bar / page model — drop the app-specific page enums

- **Class:** design (define the page-model API) → then standard
- **Status:** ready
- **Depends:** — (coordinate with M03-T2)
- **Issues:**
  [I-0006](../../issues/open/I-0006-app-specifics-baked-into-library.md)
- **Anchors:**
  [findings-reusability-python.md §1](../../issues/audit-2026-07/findings-reusability-python.md),
  [architecture-target.md](../../design/architecture-target.md)

## Goal

Make the app bar and content area **data-driven** so the library holds
no named pages. The consuming app (beta / `edi`) supplies a list of
pages (title, icon, component/loader); the library renders tabs and
swaps content from that model. Remove `AppBarIndexEnum` and
`ParamNameFormats` from `Gui/Globals/Vars.qml`.

## Scope

- **In:** a page-model API (e.g. a `pages` list/`ListModel` property on
  `Components.ApplicationWindow`, each entry
  `{ title, icon, source|component, enabled }`);
  `AppBarCentralTabs`/`ContentArea` render from it; the current index
  becomes a plain int bound to the model length; delete the two enums
  from `Vars`.
- **Out:** moving diffraction-specific _screens_ into the app (that can
  follow); `ApplicationInfo` injection (M03-T2); the settings namespace
  (M02-T3).

## Plan

1. Define the page entry shape and add a `pages` property (required) on
   `Components.ApplicationWindow` (or a dedicated `AppShell`).
2. Rewrite `AppBarCentralTabs` to instantiate a tab per `pages` entry
   (Repeater over the model), and `ContentArea`/`ContentPage` to load
   `pages[currentIndex].source/component`.
3. Replace `EaGlobals.Vars.appBarCurrentIndex` + `AppBarIndexEnum` usage
   with a neutral `currentPageIndex` (0..pages.length-1). Delete
   `AppBarIndexEnum` and `ParamNameFormats` from `Vars.qml`.
4. Update the example app(s) to declare their own pages via the model
   (Home/Project/… become the _app's_ data, not the library's).
5. Add a CI grep gate: no app/page names (`Sample`, `Experiment`,
   `Analysis`, `Summary` as page enums) or `EasyDiffraction` literals in
   `src/` (shared with M03-T2).

## Deliverables

- Page-model API on the app shell; data-driven
  `AppBarCentralTabs`/`ContentArea`; `Vars.qml` enum-free; example app
  declaring its own pages.

## Acceptance gates

- `Vars.qml` contains no page enum and no param-name-format enum.
- An example app renders its own set of pages purely from the model;
  changing the model changes the tabs with no library edit.
- `grep -Rin "easydiffraction" src/` → nothing (CI-enforced).

## Test brief

Smoke: the shell renders N tabs for an N-entry page model and switches
content on tab change. A second example with different pages proves
genericity.

## Review focus

No named-page leakage back into the library; icons/titles come from the
model; index bounds safe when the model is empty/changes.

## Definition of done

I-0006 (page-taxonomy half) met; `status.yml` M03-T1 → done. The
product-name half closes with M03-T2.
