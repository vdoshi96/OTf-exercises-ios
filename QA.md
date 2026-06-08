# QA

## Environment

- Date: 2026-06-08
- Xcode: 26.5, build 17F42
- Simulator: iPhone 17 Pro, iOS 26.5, `03B7D471-F406-489C-A454-8840EBE42F70`
- Device: Vishal's iPhone, iPhone 15 Pro Max, `00008130-001075EA2E43001C`
- Verified with explicit `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`
- Source catalogue commit: `43beed9` from `reference/OTf-exercises`

## Commands Run

Simulator launch:

```bash
XcodeBuildMCP build_run_sim extraArgs=["CODE_SIGNING_ALLOWED=NO"]
```

Full tests:

```bash
XcodeBuildMCP test_sim extraArgs=["CODE_SIGNING_ALLOWED=NO"]
```

Physical-device signing, install, and launch:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild build \
  -project OTFExercises.xcodeproj \
  -scheme OTFExercises \
  -destination 'id=00008130-001075EA2E43001C' \
  -derivedDataPath build/DerivedData \
  -allowProvisioningUpdates \
  -allowProvisioningDeviceRegistration \
  DEVELOPMENT_TEAM=PY5P84CUHB

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcrun devicectl device install app \
  --device 00008130-001075EA2E43001C \
  build/DerivedData/Build/Products/Debug-iphoneos/OTFExercises.app

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcrun devicectl device process launch \
  --device 00008130-001075EA2E43001C \
  com.vdoshi.OTFExercises
```

## Results

- Simulator build, install, and launch succeeded.
- Unit tests passed: 6 tests.
- UI tests passed: 2 tests.
- Full test result: 8 passed, 0 failed.
- Device build signed with the Apple Development identity and provisioning profile for `com.vdoshi.OTFExercises`.
- Device install succeeded.
- Device launch succeeded for `com.vdoshi.OTFExercises`.
- Bundled catalogue decodes with 1,231 exercises and 1,966 videos.

## Visual QA

- Latest local screenshot evidence is kept in ignored files under `build/screenshots/2026-06-08-*.jpg`.
- Directory screen: hero, stats, persistent search field, filter button, and exercise cards fit on iPhone 17 Pro without overlap.
- Detail round trip: opened an exercise detail, returned to the directory, and confirmed `directorySearchField` remained visible and present in the runtime UI tree.
- Search state: typed `goblet squat`, confirmed 16 matching real catalogue results, stable search/clear/filter controls, and readable compact cards.
- Filter sheet: opened the sheet from the searched state, verified compact-detent chip layout, selected `Lower Body`, and confirmed the active-filter badge/count updated.
- Long-title detail: opened a filtered long-title result and verified the hero title wrapped cleanly.
- Media section: scrolled to the video card and verified thumbnail, source badge, creator metadata, and Instagram/profile controls fit on the narrow simulator.

## Notes

- The disappearing search bar was fixed by replacing the navigation-bar `.searchable` control with a persistent SwiftUI search row in the directory content.
- No `apple.env` credentials were needed during this run; signing used the existing Xcode Apple Development account and provisioning profile.
