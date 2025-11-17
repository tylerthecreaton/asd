import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_constants.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/common/pages/home_page.dart';
import '../../features/common/pages/onboarding_page.dart';
import '../../features/common/pages/profile_page.dart';
import '../../features/common/pages/settings_page.dart';
import '../../features/common/pages/splash_page.dart';
import '../../features/questionnaire/presentation/pages/questionnaire_intro_page.dart';
import '../../features/questionnaire/presentation/pages/questionnaire_page.dart';
import '../../features/questionnaire/presentation/pages/results_page.dart';
import '../../features/video_analysis/presentation/pages/video_analysis_intro_page.dart';
import '../../features/video_analysis/presentation/pages/video_analysis_results_page.dart';
import '../../features/video_analysis/presentation/pages/video_preview_page.dart';
import '../../features/video_analysis/presentation/pages/video_recording_page.dart';

final List<GoRoute> appRoutes = [
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
  GoRoute(
    path: RouteConstants.profile,
    name: 'profile',
    builder: (context, state) => const ProfilePage(),
  ),
  GoRoute(
    path: RouteConstants.settings,
    name: 'settings',
    builder: (context, state) => const SettingsPage(),
  ),
  GoRoute(
    path: RouteConstants.questionnaireIntro,
    name: 'questionnaireIntro',
    builder: (context, state) => const QuestionnaireIntroPage(),
  ),
  GoRoute(
    path: RouteConstants.questionnaire,
    name: 'questionnaire',
    builder: (context, state) => const QuestionnairePage(),
  ),
  GoRoute(
    path: RouteConstants.questionnaireResults,
    name: 'questionnaireResults',
    builder: (context, state) => const QuestionnaireResultsPage(),
  ),
  GoRoute(
    path: RouteConstants.videoAnalysisIntro,
    name: 'videoAnalysisIntro',
    builder: (context, state) => const VideoAnalysisIntroPage(),
  ),
  GoRoute(
    path: RouteConstants.videoRecording,
    name: 'videoRecording',
    builder: (context, state) {
      final stimulusId = state.extra as String?;
      if (stimulusId == null) {
        return const _MissingArgumentsPage();
      }
      return VideoRecordingPage(stimulusVideoId: stimulusId);
    },
  ),
  GoRoute(
    path: RouteConstants.videoPreview,
    name: 'videoPreview',
    builder: (context, state) {
      final args = state.extra as VideoPreviewPageArgs?;
      if (args == null) {
        return const _MissingArgumentsPage();
      }
      return VideoPreviewPage(args: args);
    },
  ),
  GoRoute(
    path: RouteConstants.videoAnalysisResults,
    name: 'videoAnalysisResults',
    builder: (context, _) => const VideoAnalysisResultsPage(),
  ),
  // Additional routes will be added in subsequent phases
];

Widget buildRouteErrorPage(BuildContext context, GoRouterState state) {
  return Scaffold(body: Center(child: Text('Page not found: ${state.uri}')));
}

class _MissingArgumentsPage extends StatelessWidget {
  const _MissingArgumentsPage();

  static const String _message = 'Required data not found.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
