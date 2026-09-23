# Sources

## Web Reference

- URL: `https://github.com/vdoshi96/OTf-exercises`
- Local checkout used for syncs: `../OTf-exercises` (or an ignored `reference/OTf-exercises` clone)
- Purpose: read-only reference for data, behavior, filters, routes, and media.

## Key Files Inspected

- `src/data/exercises.json`: static grouped exercise data.
- `src/lib/types.ts`: source data interfaces and category labels.
- `src/lib/search.ts`: Fuse.js search keys and filter logic.
- `src/app/page.tsx`: directory route, stats, search, filters, result count.
- `src/app/exercise/[id]/page.tsx`: detail page metadata and video library.
- `src/components/*`: search bar, filter panel, exercise card/grid, social embeds.
- `public/thumbs`: self-hosted Instagram and TikTok thumbnails.

## Data Snapshot

- Synced from web `main` at `4567fd5` on 2026-09-23.
- 778 grouped exercises.
- 1,405 videos (974 Instagram, 431 TikTok), 1,405 bundled thumbnails.
- Categories in use: cardio, core, full_body, lower_body, mobility, upper_body.
- Platforms: instagram, tiktok.
- Creators: Coach Rudy, Austin Hendrickson (Trainingtall).
