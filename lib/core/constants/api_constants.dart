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