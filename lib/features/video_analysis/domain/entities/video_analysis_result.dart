import 'package:equatable/equatable.dart';

enum RiskLevel { low, moderate, high }

class VideoAnalysisResult extends Equatable {
  const VideoAnalysisResult({
    required this.id,
    required this.stimulusVideoId,
    required this.overallScore,
    required this.engagementScore,
    required this.responsivenessScore,
    required this.sensoryScore,
    required this.riskLevel,
    required this.detectedBehaviors,
    required this.recommendations,
    required this.summary,
    required this.analyzedAt,
  });

  final String id;
  final String stimulusVideoId;
  final double overallScore;
  final double engagementScore;
  final double responsivenessScore;
  final double sensoryScore;
  final RiskLevel riskLevel;
  final List<String> detectedBehaviors;
  final List<String> recommendations;
  final String summary;
  final DateTime analyzedAt;

  @override
  List<Object?> get props => [
    id,
    stimulusVideoId,
    overallScore,
    engagementScore,
    responsivenessScore,
    sensoryScore,
    riskLevel,
    detectedBehaviors,
    recommendations,
    summary,
    analyzedAt,
  ];
}
