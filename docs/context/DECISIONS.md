# Decisions

## 2026-05-10: Static Bundle Data

Use the web app's static `src/data/exercises.json` as the iOS bundle data source. The source app has no runtime backend dependency, so a local bundle-backed repository is the most faithful native mapping.

## 2026-05-10: Native Social Media Handling

Do not embed TikTok or Instagram web widgets in SwiftUI. The web app relies on browser-only scripts and embeds; the iOS app will show bundled thumbnails where available and open original social URLs through system link handling.

## 2026-05-10: No Favorites in Initial App

The source web app does not implement favorites, saved exercises, history, or user-specific state. The iOS app will not present those as completed features.

