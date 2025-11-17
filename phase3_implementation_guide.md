# Phase 3 Implementation Guide: Video Analysis Module

This guide provides detailed steps for implementing Phase 3 of the Flutter Autism Screening App, focusing on the video analysis module with camera integration and video recording capabilities.

## Progress Tracker

- [x] Step 1: Set Up Camera and Video Infrastructure
- [x] Step 2: Implement Camera Service
- [x] Step 3: Create Video Recording UI

## Step 1: Set Up Camera and Video Infrastructure

Laid the groundwork for the module with reusable domain models and curated sample content:

- [`lib/features/video_analysis/domain/entities/stimulus_video.dart`](lib/features/video_analysis/domain/entities/stimulus_video.dart)
  - Defines the `StimulusVideo` aggregate (id, title, description, asset path, duration, target behaviors, and `StimulusType`).
- [`lib/features/video_analysis/data/models/stimulus_videos.dart`](lib/features/video_analysis/data/models/stimulus_videos.dart)
  - Provides a static catalog of five guided stimuli that map to the bundled assets under `assets/videos/stimuli/`.
- [`lib/features/video_analysis/domain/entities/video_recording.dart`](lib/features/video_analysis/domain/entities/video_recording.dart)
  - Captures local recording metadata (file path, duration, size, status) so we can persist attempts, retries, and uploads inside the notifier state.

## Step 2: Implement Camera Service

Added [`lib/core/services/camera_service.dart`](lib/core/services/camera_service.dart) to abstract the `camera` plugin lifecycle:

- Caches the available cameras, initializes the current controller, and exposes helpers for the UI to check readiness.
- Provides `switchCamera`, `startRecording`, `stopRecording`, and `dispose` utilities so widgets do not need to manage controllers directly.
- Generates timestamped output paths in the temp directory, ensuring each session stores files predictably across Android, iOS, and desktop.

## Step 3: Create Video Recording UI

Implemented the complete recording experience, tying together the camera preview, stimulus playback, and recording controls:

- [`lib/features/video_analysis/presentation/pages/video_recording_page.dart`](lib/features/video_analysis/presentation/pages/video_recording_page.dart)
  - Hosts the full-screen `CameraPreviewWidget`, instructions overlay, picture-in-picture stimulus video, and `RecordingControls`.
  - Keeps track of recording state, duration timer, and lifecycle events with `WidgetsBindingObserver` so the camera gracefully re-initializes after interruptions.
  - Starts the stimulus playback shortly after a recording begins and persists successful recordings via `VideoAnalysisNotifier` before routing to the preview screen.
- [`lib/features/video_analysis/presentation/widgets/camera_preview.dart`](lib/features/video_analysis/presentation/widgets/camera_preview.dart)
  - Ensures the native camera feed scales edge-to-edge while preserving aspect ratio.
- [`lib/features/video_analysis/presentation/widgets/stimulus_video_player.dart`](lib/features/video_analysis/presentation/widgets/stimulus_video_player.dart)
  - Plays the selected `StimulusVideo` asset with `video_player`, exposing playback controls and a completion callback so the page can hide the overlay automatically.
- [`lib/features/video_analysis/presentation/widgets/recording_controls.dart`](lib/features/video_analysis/presentation/widgets/recording_controls.dart)
  - Provides the centered record/stop button, camera flip shortcut, and a live duration badge that mimics a native recording HUD.

Together these pieces deliver the interactive flow described in the architecture plan while keeping the implementation modular for future reuse (e.g., previews or guided re-recordings).

## Step 4: Create Video Preview Page

- Added [`lib/features/video_analysis/presentation/pages/video_preview_page.dart`](lib/features/video_analysis/presentation/pages/video_preview_page.dart) with a dedicated `VideoPreviewPageArgs` data class to carry the recording path, stimulus id, and capture duration through GoRouter extras.
- The screen renders a looping `VideoPlayerController.file` preview with a scrubbable progress indicator, duration badge, and quick play/pause toggle, all wrapped in a dark-themed layout that mirrors native camera apps.
- Integrated `CustomButton` actions for **Retake** (pop back to the recorder) and **Upload for Analysis** (triggers the Riverpod notifier’s `uploadVideo` workflow and jumps straight to the results route after a successful upload).
- Pulled stimulus metadata via `stimulusVideoProvider` so parents can confirm which exercise they captured before submitting.

## Step 5: Create Video Analysis Results Page

- Introduced [`lib/features/video_analysis/domain/entities/video_analysis_result.dart`](lib/features/video_analysis/domain/entities/video_analysis_result.dart) and expanded the `VideoAnalysisState` to hold an `AsyncValue<VideoAnalysisResult?>`, plus helper logic that synthesizes realistic engagement/responsiveness/sensory scores and recommendations.
- Added [`lib/features/video_analysis/presentation/widgets/analysis_summary.dart`](lib/features/video_analysis/presentation/widgets/analysis_summary.dart) to visualize the risk badge, score cards, detected behaviors, and actionable recommendations in a single reusable widget.
- Built [`lib/features/video_analysis/presentation/pages/video_analysis_results_page.dart`](lib/features/video_analysis/presentation/pages/video_analysis_results_page.dart), which consumes the new Riverpod selector (`videoAnalysisResultsProvider`), surfaces progress/error/empty states, embeds the summary widget, and provides follow-up CTAs (view report, schedule consultation, return home) along with clear medical disclaimers.
- The upload flow from Step 4 now feeds directly into this page—once `VideoPreviewPage` calls `uploadVideo`, the notifier stores the synthesized result and the router navigates to the results screen.

## Step 6: Update Router

- Expanded [`lib/app/router/routes.dart`](lib/app/router/routes.dart) with the full video-analysis flow: intro → recording → preview → results, all wired through GoRouter extras so we can pass the selected stimulus id and preview args without relying on `ModalRoute` globals.
- Added lightweight `_MissingArgumentsPage` fallback to surface a friendly message if a route is hit without the expected payload (useful during development and deeplinking tests).
- Updated `HomePage` cards continue to call `RouteConstants.videoAnalysisIntro`, and every subsequent screen now navigates via `context.push`/`context.go`, keeping navigation consistent across the app.

## Step 7: Add Camera Permissions

- Declared `CAMERA`, `RECORD_AUDIO`, and scoped storage permissions (with appropriate `maxSdkVersion` guards) near the top of [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml) so the recorder can initialize hardware on modern and legacy devices.
- Added the required privacy strings (`NSCameraUsageDescription`, `NSMicrophoneUsageDescription`, `NSPhotoLibraryUsageDescription`) to [`ios/Runner/Info.plist`](ios/Runner/Info.plist), matching the UX copy that explains why each permission is requested when parents hit record.
- With both platforms configured, the new recording + preview flow launches without runtime permission crashes and presents clear context to families.

## Next Steps

Phase 3 now delivers the full video-analysis loop (stimulus selection → recording → preview → upload → results) with the necessary routing and permission scaffolding. The upcoming polish phase should focus on:

1. Hardening analytics & storage (real upload endpoints, retry/backoff, secure storage cleanup).
2. Accessibility and UX refinements (captions on preview/results, haptic guidance during recording, RTL checks).
3. Automated coverage—widget tests for the new pages plus integration flows that simulate a full recording submission.
4. Store readiness: localized permission copy, updated screenshots, and privacy documentation reflecting the camera/video features.

Knocking out these items will get the module production-ready ahead of the final deployment sprint.
