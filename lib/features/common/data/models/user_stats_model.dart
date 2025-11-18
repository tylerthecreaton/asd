import '../../domain/entities/profile_data.dart';

class UserStatsModel {
  const UserStatsModel({
    required this.totalAssessments,
    required this.questionnaireCount,
    required this.videoAnalysisCount,
    this.lastAssessmentDate,
    this.latestRiskLevel,
    required this.riskDistribution,
  });

  final int totalAssessments;
  final int questionnaireCount;
  final int videoAnalysisCount;
  final DateTime? lastAssessmentDate;
  final RiskLevel? latestRiskLevel;
  final RiskLevelDistribution riskDistribution;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    final statsJson = json['stats'] as Map<String, dynamic>? ?? json;
    final riskDistJson =
        statsJson['riskDistribution'] as Map<String, dynamic>? ?? {};

    final lastDateStr = statsJson['lastAssessmentDate'] as String?;
    final riskLevelStr = statsJson['latestRiskLevel'] as String?;

    return UserStatsModel(
      totalAssessments: statsJson['totalAssessments'] as int? ?? 0,
      questionnaireCount: statsJson['questionnaireCount'] as int? ?? 0,
      videoAnalysisCount: statsJson['videoAnalysisCount'] as int? ?? 0,
      lastAssessmentDate: lastDateStr != null
          ? DateTime.tryParse(lastDateStr)
          : null,
      latestRiskLevel: _parseRiskLevel(riskLevelStr),
      riskDistribution: RiskLevelDistribution(
        lowRiskCount: riskDistJson['lowRiskCount'] as int? ?? 0,
        mediumRiskCount: riskDistJson['mediumRiskCount'] as int? ?? 0,
        highRiskCount: riskDistJson['highRiskCount'] as int? ?? 0,
      ),
    );
  }

  static RiskLevel? _parseRiskLevel(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'low':
        return RiskLevel.low;
      case 'medium':
      case 'moderate':
        return RiskLevel.medium;
      case 'high':
        return RiskLevel.high;
      default:
        return null;
    }
  }

  UserStatistics toUserStatistics() {
    return UserStatistics(
      totalAssessments: totalAssessments,
      questionnaireCount: questionnaireCount,
      videoAnalysisCount: videoAnalysisCount,
      lastAssessmentDate: lastAssessmentDate,
      latestRiskLevel: latestRiskLevel ?? RiskLevel.low,
      monthlyStats: const [],
      riskDistribution: riskDistribution,
    );
  }
}
