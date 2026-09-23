# Project Workflows

## Source Refresh

When updating source data, use an up-to-date checkout of the web repo (read-only), copy `src/data/exercises.json` into `OTFExercises/Resources/`, copy every `/thumbs/*` file it references from `public/thumbs` into `OTFExercises/Resources/thumbs`, and delete thumbnails no longer referenced. Then update the count assertions in `ExerciseDataTests` and `OTFExercisesUITests`.

## iOS Verification

Run `xcodebuild test -project OTFExercises.xcodeproj -scheme OTFExercises -destination 'id=<SIMULATOR_UUID>' -derivedDataPath /tmp/otf-ios-dd CODE_SIGNING_ALLOWED=NO`. If `xcode-select -p` points at Command Line Tools, prefix commands with `DEVELOPER_DIR=<path to Xcode>/Contents/Developer`.

## Screenshots and Walkthrough

Debug builds accept launch arguments for staging screens: `xcrun simctl launch <id> com.vdoshi.OTFExercises -screenshotQuery squat` (also `-screenshotFilters YES`, `-screenshotExercise <id>`, `-screenshotAbout YES`). The paced `testRecordedWalkthrough` UI test runs only with `TEST_RUNNER_OTF_WALKTHROUGH=1` and `-parallel-testing-enabled NO` while `xcrun simctl io <id> recordVideo` captures it.

