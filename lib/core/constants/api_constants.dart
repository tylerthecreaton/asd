class ApiConstants {
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000/api',
  );

  static const String videoAnalysisBaseUrl = String.fromEnvironment(
    'VIDEO_ANALYSIS_BASE_URL',
    defaultValue: backendBaseUrl,
  );

  static const String authLoginPath = '/auth/login';
  static const String authRegisterPath = '/auth/register';
  static const String authProfilePath = '/auth/me';
  static const String authStatsPath = '/auth/stats';

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
