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
- Removed the top directory stats panel, made the persistent search row the primary first-screen control, and replaced the app icon with a subagent-generated OTF-inspired exercise-search icon.
- Re-verified simulator build/run, search/detail-back visual QA, filter sheet visual QA, 8 passing tests, and signed/installed/launched the updated app on Vishal's iPhone.

## 2026-09-23

- Synced the bundled catalogue with web `main` (`4567fd5`): 778 exercises and 1,405 videos. Copied the 1,405 referenced thumbnails (610 added, 440 no longer referenced removed), so TikTok demos now show real thumbnails.
- Matched the web directory: default alphabetical browse order that ignores leading punctuation and lists digit-led titles last, web facet labels, and "Equipment not specified" in place of the implicit "Bodyweight" fallback.
- Added an About sheet and footer with the unofficial fan directory disclaimer and a link to https://o-tf-exercises.vercel.app.
- Polish: the hero and video thumbnails now have fixed aspect ratios (previously a portrait thumbnail stretched the hero to full height), the demo-count badge uses text so it no longer doubles the thumbnail's play glyph, the Lower Body badge has higher contrast, the search placeholder no longer truncates, and scrolling dismisses the keyboard.
- Added tests for thumbnail coverage, browse order, facet labels, and the About disclaimer. Updated count assertions. Result: 12 passed, 1 opt-in walkthrough skipped.
- Captured portfolio screenshots and a walkthrough recording with `simctl`, using debug launch arguments and the opt-in walkthrough UI test.
- Rewrote README for a public audience.
