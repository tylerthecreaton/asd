import 'dart:io';

class ApiConstants {
  static String get backendBaseUrl {
    const envUrl = String.fromEnvironment('BACKEND_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:4000/api';
    }
    return 'http://127.0.0.1:4000/api';
  }

  static String get videoAnalysisBaseUrl {
    const envUrl = String.fromEnvironment('VIDEO_ANALYSIS_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    return backendBaseUrl;
  }

  static const String authLoginPath = '/auth/login';
  static const String authRegisterPath = '/auth/register';
  static const String authProfilePath = '/auth/me';
  static const String authStatsPath = '/auth/stats';
  static const String authChangePasswordPath = '/auth/change-password';

  static const String questionnairesPath = '/questionnaires';
  static String questionnaireDetailPath(String identifier) =>
      '$questionnairesPath/$identifier';
  static String questionnaireSubmissionPath(String identifier) =>
      '${questionnaireDetailPath(identifier)}/submissions';

  static const String resultsPath = '/results';
  static String resultDetailPath(String id) => '$resultsPath/$id';

  static const String analyzeVideoEndpoint = '/api/analyze-video';
  static const String generatePdfEndpoint = '/api/generate-pdf';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
