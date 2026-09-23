# Media Handling

## Source Media

The web app has two media patterns:

- Instagram reels and TikTok videos, both with durable self-hosted thumbnails in `public/thumbs`

The iOS app copies the thumbnails referenced by `exercises.json` (1,405 files) into `OTFExercises/Resources/thumbs` and resolves `/thumbs/<id>.jpg` paths from the app bundle. Since the 2026-09-23 sync, TikTok demos show real thumbnails instead of the category placeholder. `ExerciseDataTests.testEveryVideoThumbnailIsBundledIncludingTikTok` guards this.

## Native Presentation

Exercise cards and detail pages show local thumbnails when available. When no local thumbnail exists, the app shows a native category placeholder instead of a broken image.

## Video Links

The source app uses browser-only TikTok and Instagram embeds. The iOS app does not use web views or broken embed scripts. It presents:

- source badges
- creator attribution
- description preview
- local thumbnail or fallback
- `Watch on Instagram` / `Watch on TikTok` system links
- creator profile links

## Playback Limitation

The source data contains social post URLs, not direct video file URLs. Native `AVPlayer` playback is therefore not appropriate without a direct media stream. Users open the original platform link for playback.

