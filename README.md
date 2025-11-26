# Project Name
VoiceRecordingApp - small macOS app for voice recording.

## Features
- Voice recording with timer (record/pause/stop)
- Voice playback with timer (play/pause/stop)
- Files persistence

## Architecture
- App is written in CLEAN architecture - the top-level component is Domain which contains business model and use cases, UI and Data layers don't know anything about each other
- SwiftUI/Combine for UI
- Convenient interfaces with async/await and throwing features

## Issues and Tradeoffs (due to tight time constraints)
- Singletons are used throughout the app - no Swift packages and proper DI
- Though interfaces provide convenient error handling errors are not handled perfectly
- MainView is a bit overwhelmed and must be split into several separate views: List, RecordingView, PlaybackView
- Timers are added to RunLoop.main

## Technical configuration
- macOS 12.7.2
- XCode 14.2
- Swift 5.7.2
- Deployment target: macOS 12.0