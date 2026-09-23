# QA

## 2026-09-23 — catalogue sync and portfolio polish

- Simulator: iPhone 17 Pro, `42143A89-D5C8-4CA5-B718-F8DB902441F3`
- Source catalogue: web `main` at `4567fd5` (778 exercises, 1,405 videos)

```bash
xcodebuild test \
  -project OTFExercises.xcodeproj \
  -scheme OTFExercises \
  -destination 'id=42143A89-D5C8-4CA5-B718-F8DB902441F3' \
  -derivedDataPath /tmp/otf-ios-dd \
  CODE_SIGNING_ALLOWED=NO
```

- Unit tests: 9 passed (data decoding, thumbnail coverage for all 1,405 videos including 431 TikTok, facet labels, URL policy, search, filters, browse order, empty state).
- UI tests: 3 passed (directory + search, filter + detail + media, About disclaimer), 1 opt-in walkthrough skipped.
- Visual QA was done with `simctl` screenshots of the directory, `squat` search, filter sheet, exercise detail, and About sheet. The captures are in `docs/screenshots/`.

## 2026-06-08 — previous run

### Environment

- Date: 2026-06-08
- Xcode: 26.5, build 17F42
- Simulator: iPhone 17 Pro, iOS 26.5, `03B7D471-F406-489C-A454-8840EBE42F70`
- Device: Vishal's iPhone, iPhone 15 Pro Max, `00008130-001075EA2E43001C`
- Verified with explicit `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`
- Source catalogue commit: `43beed9` from `reference/OTf-exercises`

### Commands Run

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

### Results

- Simulator build, install, and launch succeeded.
- Unit tests passed: 6 tests.
- UI tests passed: 2 tests.
- Full test result: 8 passed, 0 failed.
- Device build signed with the Apple Development identity and provisioning profile for `com.vdoshi.OTFExercises`.
- Device install succeeded.
- Device launch succeeded for `com.vdoshi.OTFExercises`.
- Bundled catalogue decodes with 1,231 exercises and 1,966 videos.

### Visual QA

- Latest local screenshot evidence is kept in ignored files under `build/screenshots/2026-06-08-*.jpg`.
- App icon evidence is kept in ignored file `build/screenshots/2026-06-08-app-icon.png`.
- Directory screen: top stats/hero panel removed; persistent search field is the primary first control and exercise cards begin immediately below the result count.
- Detail round trip: opened an exercise detail, returned to the directory, and confirmed `directorySearchField` remained visible and present in the runtime UI tree.
- Search state: typed `goblet squat`, confirmed 16 matching real catalogue results, stable search/clear/filter controls, and readable compact cards.
- Filter sheet: opened the sheet from the larger search row and verified compact-detent chip layout remained readable.
- App icon: generated a purpose-built OTF-inspired orange/black exercise-search icon through subagent work and verified all required AppIcon PNG dimensions.

### Notes

- The disappearing search bar remains fixed by using a persistent SwiftUI search row in the directory content.
- No `apple.env` credentials were needed during this run; signing used the existing Xcode Apple Development account and provisioning profile.
- Xcode emitted stale-keychain warnings for unrelated saved account entries during physical-device build, but the build still signed successfully with the working Apple Development identity.
