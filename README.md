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
- Persistence: used CoreData for metadata, real audio files are stored in Sandbox and saved and accessed by their URLs.
- Records from CoreData aren't reloaded after each recording: I optimized this with introducing of local cache of all recordings in Repository which is updated with fresh recording only if saving to CoreData succeeded. Thus we always have the actual list of recordings in local cache and CoreData is loaded only once at application start.

## Issues and Tradeoffs (due to tight time constraints)
- Singletons are used throughout the app - no Swift packages and proper DI
- Though interfaces provide convenient error handling errors are not handled perfectly
- MainView is a bit overwhelmed and must be split into several separate views: List, RecordingView, PlaybackView
- Timers are added to RunLoop.main
- When some flow is activated, e. g., Recording or Playing other UI elements, like List, aren't blocked or hidden so User has to finish the flow and only after that the correct work is guaranteed. These edge cases where not implemented and tested.

## Technical configuration
- macOS 12.7.6
- XCode 14.2
- Swift 5.7.2
- Deployment target: macOS 12.0