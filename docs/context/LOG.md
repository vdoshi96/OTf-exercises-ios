# Log

## 2026-05-10

- Initialized a standalone iOS workspace.
- Cloned `vdoshi96/OTf-exercises` into `reference/OTf-exercises` as read-only source material.
- Inspected source routes, components, search/filter logic, exercise data, media, creators, and user-state behavior.
- Wrote `IMPLEMENTATION_PLAN.md` before starting SwiftUI coding.
- Built a native SwiftUI iOS app with bundled exercise data, local thumbnails, native search/filtering, detail pages, and social link media cards.
- Added XCTest coverage for data decoding, filter options, search, filter combinations, and empty results.
- Added XCUITest coverage for directory load, search, filter sheet, detail navigation, and media link controls.
- Verified build and full test scheme with explicit `DEVELOPER_DIR`.

## 2026-06-08

- Refreshed the bundled iOS catalogue from website source commit `43beed9`.
- Updated the bundled snapshot to 1,231 grouped exercises and 1,966 videos.
- Polished the SwiftUI directory/detail/media UI, added a branded app icon asset catalog, and moved directory search into persistent content so it remains visible after returning from detail.
- Added UI test coverage for the detail-back search persistence regression.
- Verified simulator build/run, visual QA for directory/search/filter/detail/media flows, 8 passing tests, and signed/installed/launched the app on Vishal's iPhone.
