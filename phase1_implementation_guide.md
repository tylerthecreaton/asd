# Phase 1 Implementation Guide: Project Setup and Basic UI Structure

This guide provides detailed steps for implementing Phase 1 of the Flutter Autism Screening App.

## Phase 1 Status (2025-11-17)

- [x] Step 1 – Dependencies configured (uses Flutter-pinned `intl 0.20.2`).
- [x] Step 2 – Directory structure created with required stubs.
- [x] Step 3 – Internationalization assets and config added.
- [x] Step 4 – App theme (colors, text styles, theme data) implemented.
- [x] Step 5 – GoRouter setup with dedicated `router.dart` and `routes.dart`.
- [x] Step 6 – Core app entry (`App` widget + `main.dart`) wired to router and l10n.
- [x] Step 7 – Common reusable widgets provided.
- [x] Step 8 – Placeholder pages for splash/onboarding/auth/home available.
- [x] Step 9 – Supabase service (plus storage/notification stubs) configured.

## Step 1: Update pubspec.yaml with Dependencies

First, update your [`pubspec.yaml`](pubspec.yaml:1) file with all the necessary dependencies:

```yaml
name: asd
description: "Flutter app for autism screening in children"
publish_to: "none"

version: 1.0.0+1

environment:
  sdk: ^3.9.2

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
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

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/videos/stimuli/
    - assets/animations/
```

## Step 2: Create Project Directory Structure

Create the following directory structure in your [`lib`](lib:1) folder:

```
lib/
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
│   ├── questionnaire/
│   ├── video_analysis/
│   └── common/
│       ├── widgets/
│       └── providers/
├── generated/
└── l10n/
    ├── app_en.arb
    ├── app_th.arb
    └── l10n.yaml
```

## Step 3: Set Up Internationalization

Create the l10n configuration file [`lib/l10n/l10n.yaml`](lib/l10n/l10n.yaml:1):

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

Create English localization file [`lib/l10n/app_en.arb`](lib/l10n/app_en.arb:1):

```json
{
  "@@locale": "en",
  "appTitle": "ASD Screening",
  "@appTitle": {
    "description": "The title of the application"
  },
  "home": "Home",
  "questionnaire": "Questionnaire",
  "videoAnalysis": "Video Analysis",
  "profile": "Profile",
  "settings": "Settings",
  "login": "Login",
  "register": "Register",
  "email": "Email",
  "password": "Password",
  "confirmPassword": "Confirm Password",
  "forgotPassword": "Forgot Password?",
  "alreadyHaveAccount": "Already have an account?",
  "dontHaveAccount": "Don't have an account?",
  "next": "Next",
  "previous": "Previous",
  "submit": "Submit",
  "cancel": "Cancel",
  "save": "Save",
  "error": "Error",
  "success": "Success",
  "loading": "Loading..."
}
```

Create Thai localization file [`lib/l10n/app_th.arb`](lib/l10n/app_th.arb:1):

```json
{
  "@@locale": "th",
  "appTitle": "การคัดกรอง ASD",
  "home": "หน้าแรก",
  "questionnaire": "แบบสอบถาม",
  "videoAnalysis": "การวิเคราะห์วิดีโอ",
  "profile": "โปรไฟล์",
  "settings": "การตั้งค่า",
  "login": "เข้าสู่ระบบ",
  "register": "สมัครสมาชิก",
  "email": "อีเมล",
  "password": "รหัสผ่าน",
  "confirmPassword": "ยืนยันรหัสผ่าน",
  "forgotPassword": "ลืมรหัสผ่าน?",
  "alreadyHaveAccount": "มีบัญชีอยู่แล้ว?",
  "dontHaveAccount": "ยังไม่มีบัญชี?",
  "next": "ถัดไป",
  "previous": "ก่อนหน้า",
  "submit": "ส่ง",
  "cancel": "ยกเลิก",
  "save": "บันทึก",
  "error": "ข้อผิดพลาด",
  "success": "สำเร็จ",
  "loading": "กำลังโหลด..."
}
```

## Step 4: Create App Theme

Create [`lib/app/theme/colors.dart`](lib/app/theme/colors.dart:1):

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - calming and soft
  static const Color primary = Color(0xFF5E9CFF);
  static const Color primaryVariant = Color(0xFF3B7FDB);
  static const Color secondary = Color(0xFF8B72FF);
  static const Color secondaryVariant = Color(0xFF6B52DF);

  // Background colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF8F9FC);

  // Text colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textDisabled = Color(0xFFA0AEC0);

  // Status colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFF56565);
  static const Color info = Color(0xFF4299E1);

  // Risk assessment colors
  static const Color lowRisk = Color(0xFF48BB78);
  static const Color mediumRisk = Color(0xFFED8936);
  static const Color highRisk = Color(0xFFF56565);
}
```

Create [`lib/app/theme/text_styles.dart`](lib/app/theme/text_styles.dart:1):

```dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}
```

Create [`lib/app/theme/app_theme.dart`](lib/app/theme/app_theme.dart:1):

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textDisabled),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textDisabled),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.headline1,
        displayMedium: AppTextStyles.headline2,
        displaySmall: AppTextStyles.headline3,
        headlineMedium: AppTextStyles.headline4,
        bodyLarge: AppTextStyles.bodyText1,
        bodyMedium: AppTextStyles.bodyText2,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}
```

## Step 5: Set Up Go Router

Create [`lib/core/constants/route_constants.dart`](lib/core/constants/route_constants.dart:1):

```dart
class RouteConstants {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String questionnaireIntro = '/questionnaire/intro';
  static const String questionnaire = '/questionnaire';
  static const String questionnaireResults = '/questionnaire/results';
  static const String videoAnalysisIntro = '/video-analysis/intro';
  static const String videoRecording = '/video-analysis/recording';
  static const String videoPreview = '/video-analysis/preview';
  static const String videoAnalysisResults = '/video-analysis/results';
  static const String profile = '/profile';
  static const String settings = '/settings';
}
```

Create [`lib/app/router/routes.dart`](lib/app/router/routes.dart:1):

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/common/pages/splash_page.dart';
import '../../features/common/pages/home_page.dart';
import '../../features/common/pages/onboarding_page.dart';

final appRouter = GoRouter(
  initialLocation: RouteConstants.splash,
  routes: [
    GoRoute(
      path: RouteConstants.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteConstants.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: RouteConstants.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteConstants.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RouteConstants.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    // Additional routes will be added in subsequent phases
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
```

## Step 6: Create Basic App Structure

Create [`lib/app/app.dart`](lib/app/app.dart:1):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:asd/generated/l10n.dart';
import 'router/routes.dart';
import 'theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'ASD Screening',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('th', ''),
      ],
    );
  }
}
```

Update [`lib/main.dart`](lib/main.dart:1):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
```

## Step 7: Create Common Widgets

Create [`lib/features/common/widgets/app_scaffold.dart`](lib/features/common/widgets/app_scaffold.dart:1):

```dart
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showAppBar;
  final bool extendBodyBehindAppBar;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showAppBar = true,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title ?? ''),
              actions: actions,
            )
          : null,
      body: SafeArea(
        top: !extendBodyBehindAppBar,
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
```

Create [`lib/features/common/widgets/custom_button.dart`](lib/features/common/widgets/custom_button.dart:1):

```dart
import 'package:flutter/material.dart';

enum ButtonType { elevated, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType buttonType;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonType = ButtonType.elevated,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    switch (buttonType) {
      case ButtonType.elevated:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: child,
          ),
        );
      case ButtonType.outlined:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: child,
          ),
        );
      case ButtonType.text:
        return SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            child: child,
          ),
        );
    }
  }
}
```

## Step 8: Create Placeholder Pages

Create [`lib/features/common/pages/splash_page.dart`](lib/features/common/pages/splash_page.dart:1):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  void _navigateToNextPage() {
    // Simulate splash screen delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(RouteConstants.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.child_care,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'ASD Screening',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Create similar placeholder pages for OnboardingPage, LoginPage, RegisterPage, and HomePage.

## Step 9: Set Up Supabase Configuration

Create [`lib/core/services/supabase_service.dart`](lib/core/services/supabase_service.dart:1):

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/api_constants.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      anonKey: ApiConstants.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static SupabaseAuth get auth => client.auth;

  static SupabaseStorage get storage => client.storage;

  static SupabaseDatabase get database => client;
}
```

Create [`lib/core/constants/api_constants.dart`](lib/core/constants/api_constants.dart:1):

```dart
class ApiConstants {
  // Replace with your actual Supabase credentials
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // API endpoints
  static const String videoAnalysisBaseUrl = 'YOUR_VIDEO_ANALYSIS_API_URL';
  static const String analyzeVideoEndpoint = '/api/analyze-video';
  static const String generatePdfEndpoint = '/api/generate-pdf';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
```

## Next Steps

After completing these steps, you'll have:

1. A properly configured Flutter project with all necessary dependencies
2. Internationalization support for Thai and English
3. A consistent theme with calming colors and accessible typography
4. Navigation structure using Go Router
5. Basic reusable UI components
6. Placeholder pages for the main app flow
7. Supabase service configuration ready for authentication and data storage

The next phase will focus on implementing the authentication flow and then the questionnaire module.
