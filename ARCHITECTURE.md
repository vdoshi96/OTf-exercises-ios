# Architecture

## Source Web App Mapping

The web app is a static Next.js app:

- `src/app/page.tsx` maps to `ExerciseDirectoryView`.
- `src/app/exercise/[id]/page.tsx` maps to `ExerciseDetailView`.
- `src/lib/types.ts` maps to `Exercise`, `ExerciseVideo`, `Creator`, `ExerciseCategory`, and `MovementType`.
- `src/lib/search.ts` maps to `ExerciseSearchService` and `ExerciseFilterState`.
- `src/components/FilterPanel.tsx` maps to `FilterSheetView`.
- `src/components/ExerciseCard.tsx` maps to `ExerciseCardView`.
- `InstagramEmbed` and `TikTokEmbed` map to native `VideoPreviewCard` link previews instead of web embeds.

## App Layers

- App entry: `OTFExercisesApp`
- Models: `OTFExercises/Models`
- Data loading: `ExerciseRepository`, which decodes bundled JSON asynchronously
- Search/filter logic: `ExerciseSearchService`
- Directory UI: `ExerciseDirectoryView`
- Detail UI: `ExerciseDetailView`
- Media UI: `ThumbnailView` and `VideoPreviewCard`

## Navigation

The app uses a `NavigationStack` with `Exercise` values as navigation destinations. Directory cards navigate to detail pages natively, with no web routing or web views.

## State

Directory state is local SwiftUI value state:

- `searchText`
- `ExerciseFilterState`
- `ExerciseLoadState`
- filter sheet presentation

The source web app has no favorites, saved state, history, accounts, or backend user state, so no persistence layer was added.

## Error And Empty States

The app includes:

- loading view while the JSON is decoded
- error state if bundled data cannot be read
- empty result state when search/filter combinations return no exercises

