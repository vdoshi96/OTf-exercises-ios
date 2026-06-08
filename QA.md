# QA

## Environment

- Date: 2026-06-08
- Xcode: 26.5, build 17F42
- Simulator: iPhone 17 Pro, iOS 26.5, `03B7D471-F406-489C-A454-8840EBE42F70`
- Verified with explicit `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`
- Source catalogue commit: `43beed9` from `reference/OTf-exercises`

## Commands Run

Full tests:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild test \
  -project OTFExercises.xcodeproj \
  -scheme OTFExercises \
  -destination 'id=03B7D471-F406-489C-A454-8840EBE42F70' \
  -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO
```

## Results

- Build succeeded as part of the test scheme.
- Unit tests passed: 6 tests.
- UI tests passed: 2 tests.
- Full scheme test result: `** TEST SUCCEEDED **`.
- Bundled catalogue decodes with 1,231 exercises and 1,966 videos.

## Verified Flows

- App launches in simulator.
- Exercise list loads real data.
- Search returns matching exercise results.
- Filter sheet opens and applies category filters.
- Exercise detail page opens from a directory card.
- Detail page shows metadata, creator attribution, thumbnails/fallbacks, and video link controls.
- Empty search state is covered by unit test.

## Notes

An initial XcodeBuildMCP test run timed out at the tool boundary and exposed stale UI count assertions. After updating those assertions, the direct shell `xcodebuild test` run passed.

No backend credentials or secrets are required.
