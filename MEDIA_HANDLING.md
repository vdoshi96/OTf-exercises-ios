# Media Handling

## Source Media

The web app has two media patterns:

- Instagram reels with self-hosted thumbnails in `public/thumbs`
- TikTok links, often without local thumbnails

The iOS app copies `public/thumbs` into `OTFExercises/Resources/thumbs` and resolves `/thumbs/<id>.jpg` paths from the app bundle.

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

