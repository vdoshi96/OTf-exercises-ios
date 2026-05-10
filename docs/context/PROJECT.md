# Project Context

## Intent

Build a polished native iPhone fitness reference app for browsing OTF exercise demos, based on the existing web app at `https://github.com/vdoshi96/OTf-exercises`.

## Confirmed Source Behavior

- Users browse a static exercise directory.
- Users search across exercise name, muscle groups, equipment, creators, creator handles, and coaching cues.
- Users filter by category, muscle group, equipment, platform, and creator.
- Users open exercise detail pages showing metadata, coaching cues, creators, and video/demo links.
- Data is static JSON bundled at build time; there is no backend dependency for app runtime.
- No source favorites, saved exercises, history, or account state were found.

## Constraints

- The original web repo is reference-only and ignored by this new repo.
- The iOS app should be native SwiftUI, not a website wrapper.
- Social embeds should become safe native links/previews because TikTok/Instagram embeds are web-only.

