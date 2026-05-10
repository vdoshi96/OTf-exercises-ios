# OTF Exercises iOS

Native SwiftUI iPhone app for browsing the OTF Exercise Directory from the reference web app at `https://github.com/vdoshi96/OTf-exercises`.

The original web repo is cloned only under `reference/OTf-exercises` for inspection and is ignored by this repository.

## What Is Included

- SwiftUI app target: `OTFExercises`
- Unit test target: `OTFExercisesTests`
- UI test target: `OTFExercisesUITests`
- Real bundled exercise data: `OTFExercises/Resources/exercises.json`
- Real bundled Instagram thumbnails: `OTFExercises/Resources/thumbs`

## Requirements

- Xcode 26.4.1 or newer compatible Xcode
- iOS 17.0+ deployment target
- An iPhone simulator or device

This machine currently has Xcode installed at `/Applications/Xcode.app`, while `xcode-select` points at Command Line Tools. Use `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` for command-line builds unless you change the global developer directory.

## Run In Xcode

1. Open `OTFExercises.xcodeproj`.
2. Select the `OTFExercises` scheme.
3. Select an iPhone simulator.
4. Press Run.

For a physical device, select your Apple Developer team in Xcode signing settings if Xcode prompts for it.

## Build And Test From Terminal

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild test \
  -project OTFExercises.xcodeproj \
  -scheme OTFExercises \
  -destination 'platform=iOS Simulator,name=iPhone 17e' \
  -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO
```

If that simulator name is unavailable, run:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl list devices available
```

Then replace the destination with a booted simulator id, for example `-destination 'id=<SIMULATOR_UUID>'`.

## Runtime Behavior

The app is offline-first for directory browsing because the web app data is static JSON. Social demo buttons open the original TikTok or Instagram URLs with system link handling.

