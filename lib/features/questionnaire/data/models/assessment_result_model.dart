import '../../domain/entities/assessment_result.dart';

class AssessmentResultModel extends AssessmentResult {
  AssessmentResultModel({
    required super.id,
    required super.questionnaireId,
    super.questionnaireSlug,
    super.questionnaireTitle,
    required super.userId,
    required super.score,
    required super.totalQuestions,
    required super.riskLevel,
    required super.flaggedBehaviors,
    required super.completedAt,
    required super.recommendations,
  });

  factory AssessmentResultModel.fromJson(Map<String, dynamic> json) {
    final questionnaireJson = json['questionnaire'] as Map<String, dynamic>?;
    final flagged = (json['flaggedBehaviors'] as List<dynamic>? ?? const [])
        .map((entry) => entry.toString())
        .toList(growable: false);
    final recommendationsRaw = json['recommendations'];
    final recommendations = recommendationsRaw is Map<String, dynamic>
        ? Map<String, dynamic>.from(recommendationsRaw)
        : <String, dynamic>{};

    final riskLevelValue = json['riskLevel'] as String?;
    final completedAtString = json['createdAt'] as String?;

    return AssessmentResultModel(
      id: json['id'] as String? ?? '',
      questionnaireId:
          json['questionnaireId'] as String? ??
          (questionnaireJson?['id'] as String?) ??
          '',
      questionnaireSlug: questionnaireJson?['slug'] as String?,
      questionnaireTitle: questionnaireJson?['title'] as String?,
      userId: (json['userId'] as String?) ?? 'anonymous',
      score: json['score'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      riskLevel: _parseRiskLevel(riskLevelValue),
      flaggedBehaviors: flagged,
      completedAt: completedAtString != null
          ? DateTime.tryParse(completedAtString) ?? DateTime.now()
          : DateTime.now(),
      recommendations: recommendations,
    );
  }

  static RiskLevel _parseRiskLevel(String? value) {
    switch (value?.toLowerCase()) {
      case 'low':
        return RiskLevel.low;
      case 'medium':
      case 'moderate':
        return RiskLevel.medium;
      case 'high':
      default:
        return RiskLevel.high;
    }
  }
}
