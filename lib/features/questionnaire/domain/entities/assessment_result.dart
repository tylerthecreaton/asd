import 'package:equatable/equatable.dart';

enum RiskLevel { low, medium, high }

class AssessmentResult extends Equatable {
  const AssessmentResult({
    required this.id,
    required this.questionnaireId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.riskLevel,
    required this.flaggedBehaviors,
    required this.completedAt,
    required this.recommendations,
  });

  final String id;
  final String questionnaireId;
  final String userId;
  final int score;
  final int totalQuestions;
  final RiskLevel riskLevel;
  final List<String> flaggedBehaviors;
  final DateTime completedAt;
  final Map<String, dynamic> recommendations;

  @override
  List<Object?> get props => [
    id,
    questionnaireId,
    userId,
    score,
    totalQuestions,
    riskLevel,
    flaggedBehaviors,
    completedAt,
    recommendations,
  ];
}
