# Flutter Autism Screening App - Technical Architecture Plan

## Project Overview
This document outlines the technical architecture for the Flutter application designed for early autism screening in children (ASD). The app will feature two main modules: a questionnaire module based on M-CHAT and a video analysis module.

## Technology Stack

### Frontend (Flutter)
- **Framework**: Flutter (latest stable version)
- **Navigation**: Go Router
- **State Management**: Riverpod
- **UI Library**: Material 3
- **Internationalization**: flutter_localizations and intl
- **Authentication**: Supabase Auth
- **Database**: Supabase PostgreSQL
- **File Storage**: Supabase Storage

### Backend
- **API**: Node.js with Express (for video analysis)
- **Database**: Supabase PostgreSQL
- **File Storage**: Supabase Storage
- **Authentication**: Supabase Auth

## Key Flutter Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Navigation
  go_router: ^12.1.3
  
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # UI
  cupertino_icons: ^1.0.8
  
  # Authentication & Database
  supabase_flutter: ^1.10.25
  
  # Camera & Video
  camera: ^0.10.5+5
  video_player: ^2.8.1
  
  # HTTP & API
  dio: ^5.4.0
  
  # File Handling
  path_provider: ^2.1.1
  file_picker: ^6.1.1
  
  # PDF Generation
  pdf: ^3.10.4
  printing: ^5.11.0
  
  # Security
  flutter_secure_storage: ^9.0.0
  
  # Utilities
  url_launcher: ^6.2.1
  intl: ^0.18.1
  
  # UI Components
  flutter_svg: ^2.0.9
  lottie: ^2.7.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  riverpod_generator: ^2.3.9
  build_runner: ^2.4.7
  custom_lint: ^0.5.7
  riverpod_lint: ^2.3.7
```

## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router/
│   │   ├── router.dart
│   │   └── routes.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── colors.dart
│       └── text_styles.dart
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── route_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── network_info.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── file_utils.dart
│   │   └── validators.dart
│   └── services/
│       ├── supabase_service.dart
│       ├── storage_service.dart
│       └── notification_service.dart
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in.dart
│   │   │       ├── sign_up.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── pages/
│   │       │   ├── sign_in_page.dart
│   │       │   ├── sign_up_page.dart
│   │       │   └── forgot_password_page.dart
│   │       └── widgets/
│   │           ├── sign_in_form.dart
│   │           └── sign_up_form.dart
│   ├── questionnaire/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── questionnaire_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── questionnaire_model.dart
│   │   │   │   ├── question_model.dart
│   │   │   │   └── response_model.dart
│   │   │   └── repositories/
│   │   │       └── questionnaire_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── questionnaire.dart
│   │   │   │   ├── question.dart
│   │   │   │   ├── response.dart
│   │   │   │   └── assessment_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── questionnaire_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_questionnaire.dart
│   │   │       ├── submit_response.dart
│   │   │       └── calculate_risk_assessment.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── questionnaire_provider.dart
│   │       ├── pages/
│   │       │   ├── questionnaire_intro_page.dart
│   │       │   ├── questionnaire_page.dart
│   │       │   └── results_page.dart
│   │       └── widgets/
│   │           ├── question_card.dart
│   │           ├── progress_indicator.dart
│   │           └── results_summary.dart
│   ├── video_analysis/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── video_remote_datasource.dart
│   │   │   │   └── video_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── video_model.dart
│   │   │   │   └── analysis_result_model.dart
│   │   │   └── repositories/
│   │   │       └── video_analysis_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── video.dart
│   │   │   │   ├── stimulus_video.dart
│   │   │   │   └── analysis_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── video_analysis_repository.dart
│   │   │   └── usecases/
│   │   │       ├── record_video.dart
│   │   │       ├── upload_video.dart
│   │   │       └── get_analysis_result.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── video_analysis_provider.dart
│   │       ├── pages/
│   │       │   ├── video_intro_page.dart
│   │       │   ├── recording_page.dart
│   │       │   ├── video_preview_page.dart
│   │       │   └── analysis_results_page.dart
│   │       └── widgets/
│   │           ├── camera_preview.dart
│   │           ├── stimulus_video_player.dart
│   │           ├── recording_controls.dart
│   │           └── video_preview_player.dart
│   └── common/
│       ├── widgets/
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   ├── loading_indicator.dart
│       │   ├── error_widget.dart
│       │   └── app_scaffold.dart
│       └── providers/
│           └── locale_provider.dart
├── generated/
│   └── l10n.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_th.arb
│   └── l10n.yaml
└── assets/
    ├── images/
    ├── videos/
    │   └── stimuli/
    └── animations/
```

## Architecture Patterns

### 1. Clean Architecture
The app follows Clean Architecture principles with clear separation of concerns:
- **Presentation Layer**: UI components and state management
- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources and repositories

### 2. Provider Pattern (Riverpod)
State management using Riverpod with:
- Providers for dependency injection
- StateNotifier for complex state logic
- FutureProvider and StreamProvider for async operations

### 3. Repository Pattern
Abstract repository interfaces in the domain layer with concrete implementations in the data layer.

## Key Features Implementation

### 1. Authentication Flow
- Email/password authentication via Supabase Auth
- Secure session management with flutter_secure_storage
- Password reset functionality

### 2. Questionnaire Module (M-CHAT)
- Interactive questionnaire with progress tracking
- Local storage for incomplete questionnaires
- Risk assessment calculation based on responses
- PDF report generation with results

### 3. Video Analysis Module
- Camera integration for video recording
- Picture-in-picture display for stimulus videos
- Video compression and upload
- Integration with backend analysis API

### 4. Internationalization
- Thai and English language support
- Dynamic language switching
- Localized content for questionnaires and UI

## Security Considerations

1. **Data Encryption**: All sensitive data encrypted at rest and in transit
2. **Authentication**: Secure authentication with Supabase Auth
3. **API Security**: JWT tokens for API authentication
4. **Video Privacy**: Secure video storage with access controls
5. **HIPAA Compliance**: Adherence to healthcare data protection standards

## Performance Optimization

1. **Lazy Loading**: Load content as needed
2. **Image/Video Optimization**: Compression and caching
3. **State Management**: Efficient state updates with Riverpod
4. **Network Optimization**: Request caching and retry mechanisms

## Testing Strategy

1. **Unit Tests**: Business logic and utilities
2. **Widget Tests**: UI components
3. **Integration Tests**: End-to-end user flows
4. **Performance Tests**: Memory and CPU usage

## Deployment

1. **Android**: Google Play Store deployment
2. **iOS**: Apple App Store deployment
3. **CI/CD**: Automated build and release pipeline

## Future Enhancements

1. **Offline Support**: Local database for offline functionality
2. **Push Notifications**: Appointment reminders and updates
3. **Analytics**: User behavior tracking
4. **AI Integration**: Enhanced video analysis capabilities