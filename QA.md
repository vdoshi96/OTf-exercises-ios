# QA

## Environment

- Date: 2026-05-10
- Xcode: 26.4.1, build 17E202
- Simulator runtime: iOS 26.4.1 available through Xcode
- Verified with explicit `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`

## Commands Run

Build:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild build \
  -project OTFExercises.xcodeproj \
  -scheme OTFExercises \
  -destination 'id=0A503FC2-C839-4E93-B5CF-7109171F9FD4' \
  -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO
```

Full tests:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild test \
  -project OTFExercises.xcodeproj \
  -scheme OTFExercises \
  -destination 'id=6E343165-9BEA-40D4-8A90-0C95C2F1BB64' \
  -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO
```

## Results

- Build succeeded.
- Unit tests passed: 5 tests.
- UI tests passed: 2 tests.
- Full scheme test result: `** TEST SUCCEEDED **`.

## Verified Flows

- App launches in simulator.
- Exercise list loads real data.
- Search returns matching exercise results.
- Filter sheet opens and applies category filters.
- Exercise detail page opens from a directory card.
- Detail page shows metadata, creator attribution, thumbnails/fallbacks, and video link controls.
- Empty search state is covered by unit test.

## Notes

XcodeBuildMCP could not list simulators because the global `xcode-select` points to Command Line Tools. Shell commands succeeded by setting `DEVELOPER_DIR` explicitly.

No backend credentials or secrets are required.

