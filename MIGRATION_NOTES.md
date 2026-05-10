# Migration Notes

## Preserved

- Real exercise dataset from the web app.
- Categories, movement type, muscle groups, equipment, creators, platforms, coaching cues, and video records.
- Directory browsing.
- Search across the same meaningful fields.
- Filters for category, muscle group, equipment, platform, and creator.
- Exercise detail pages.
- Instagram thumbnails that were self-hosted by the web app.
- Original TikTok and Instagram URLs.

## Changed For Native iOS

- Next.js routes became SwiftUI `NavigationStack` screens.
- Web filter panel became a native modal filter sheet.
- Browser search input became SwiftUI `.searchable`.
- Web cards became native tappable directory cards.
- Social embeds became native preview/link cards.
- Tailwind visual styling became system-aware SwiftUI styling that supports light mode, dark mode, and Dynamic Type.

## Not Implemented

- Favorites, saved exercises, account features, and history were not implemented because the source web app does not contain those features.
- Native video playback was not implemented because the source data does not include direct playable media URLs.
- A production App Store signing setup was not configured; Xcode can assign a free developer team when running on a physical device.

## Source Repo Isolation

The web app remains untouched. It was cloned under `reference/OTf-exercises`, which is ignored by this repository.

