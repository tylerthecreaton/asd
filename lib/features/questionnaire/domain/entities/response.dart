import 'package:equatable/equatable.dart';

class Response extends Equatable {
  const Response({
    required this.questionId,
    required this.answerIndex,
    required this.answeredAt,
    this.points = 0,
  });

  final String questionId;
  final int answerIndex;
  final DateTime answeredAt;
  final int points;

  @override
  List<Object?> get props => [questionId, answerIndex, answeredAt, points];
  
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answerIndex': answerIndex,
      'answeredAt': answeredAt.toIso8601String(),
      'points': points,
    };
  }
  
  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      questionId: json['questionId'],
      answerIndex: json['answerIndex'],
      answeredAt: DateTime.parse(json['answeredAt']),
      points: json['points'] ?? 0,
    );
  }
}
