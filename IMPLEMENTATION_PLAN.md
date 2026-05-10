# OTF Exercises iOS Implementation Plan

## Source App Findings

- Reference repo: `reference/OTf-exercises`, cloned read-only from `https://github.com/vdoshi96/OTf-exercises`.
- Stack: Next.js app router with static `src/data/exercises.json`, Fuse.js client search, filter chips, exercise cards, and detail routes at `/exercise/[id]`.
- Current data snapshot: 1,220 grouped exercises, 1,953 videos, 7 categories, 27 muscle groups, 16 equipment values, 2 creators, TikTok and Instagram sources.
- Media: Instagram thumbnails are self-hosted in `public/thumbs` and referenced as `/thumbs/<shortcode>.jpg`; TikTok videos generally have no local thumbnail. Social video playback is via web embeds in the web app.
- User-specific state: no favorites, saved exercises, history, accounts, or backend state found.

## Native iOS Mapping

1. Create a standalone SwiftUI iOS app in this workspace with `NavigationStack`, `Codable` models, a clean bundle-backed data layer, and value-state search/filtering.
2. Bundle the real `exercises.json` and local thumbnail assets from the reference app. Do not create fake records.
3. Implement a native directory view with `.searchable`, summary stats, clear exercise rows/cards, empty/error/loading states, and a filter sheet.
4. Preserve meaningful filters: category, muscle group, equipment, platform, and multi-select creators.
5. Implement detail pages with exercise metadata, coaching cues, creators, and a native media/link presentation. Avoid web embeds; use bundled thumbnails when available and open original social links safely.
6. Add focused unit tests for data decoding, filter options, search behavior, and filtering.
7. Document architecture, data model, media handling, QA, and migration notes.

## Verification Plan

- Build with Xcode 26.4.1 using `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`.
- Run unit tests on an iPhone simulator.
- Launch the app in a booted simulator and manually verify list loading, search, filters, detail navigation, media/link affordances, and empty states.
- Record limitations, especially social media playback constraints and lack of backend/user-state features in the source app.

