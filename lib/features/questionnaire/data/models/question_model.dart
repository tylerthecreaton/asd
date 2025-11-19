import '../../domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.text,
    super.description,
    required super.options,
    required super.correctAnswerIndex,
    required this.backendId,
    this.order,
    super.scoringType = 'binary',
    super.maxPoints = 1,
  });

  final String backendId;
  final int? order;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List<dynamic>? ?? <dynamic>[])
        .map((option) => option.toString())
        .toList(growable: false);
    final externalId = json['externalId'] as String?;
    final backendId = json['id'] as String? ?? externalId ?? '';

    return QuestionModel(
      id: externalId ?? backendId,
      text: json['text'] as String? ?? '',
      description: json['description'] as String?,
      options: options,
      correctAnswerIndex: json['correctAnswerIndex'] as int? ?? 0,
      backendId: backendId,
      order: json['order'] as int?,
      scoringType: json['scoringType'] as String? ?? 'binary',
      maxPoints: json['maxPoints'] as int? ?? 1,
    );
  }
}
