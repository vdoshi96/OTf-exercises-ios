# Project Workflows

## Source Refresh

When updating source data, pull a fresh copy of the web repo into `reference/OTf-exercises`, inspect changes, then migrate only the needed JSON/media into the iOS app. Keep the reference clone ignored and untouched by commits.

## iOS Verification

Set `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` for local Xcode commands because the active developer directory may point at Command Line Tools.

