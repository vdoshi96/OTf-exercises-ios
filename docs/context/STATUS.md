# Status

## Current Phase

Native SwiftUI implementation complete, search-first UI polished, simulator-verified, and installed on the connected iPhone.

## What Exists

- Web reference cloned into `reference/OTf-exercises`.
- Source app inspected for structure, data model, search, filters, media, and user state.
- `IMPLEMENTATION_PLAN.md` written before coding.
- Standalone Xcode project created at `OTFExercises.xcodeproj`.
- Real JSON data and thumbnails bundled into the iOS app.
- Bundled catalogue synced from website `main` at `4567fd5` on 2026-09-23: 778 exercises, 1,405 videos, and a bundled thumbnail for every video, including TikTok.
- Default browse order matches the web (leading punctuation ignored, digit-led titles last); facet labels match the web (Y-Bell, TRX Straps, BOSU); empty equipment reads "Equipment not specified" rather than implying bodyweight.
- About sheet (toolbar info button) and list/detail footer carry the unofficial-fan-directory disclaimer and link to the web app.
- Portfolio screenshots in `docs/screenshots/`; debug launch arguments stage screens for `simctl` captures.
- Directory UI polished with a persistent prominent custom search field, refreshed cards, filter affordance, detail hero, media cards, and purpose-built app icon.
- App target configured for automatic signing with team `PY5P84CUHB`.
- Unit and UI tests added.
- Deliverable docs added: README, architecture, data model, media handling, QA, and migration notes.

## Verification So Far

- Full test scheme succeeded after the UI polish with 6 unit tests and 2 UI tests.
- Visual QA covered the search-first directory, detail navigation/back, search results, filter sheet, and app icon on iPhone 17 Pro simulator.
- Physical-device build, signing, install, and launch succeeded on Vishal's iPhone.
- 2026-09-23: full scheme passes on iPhone 17 Pro simulator with 9 unit tests and 3 UI tests (plus 1 opt-in walkthrough test, skipped by default).

## Open Items

- Optional: add future favorites only if product scope expands beyond the source web app.
