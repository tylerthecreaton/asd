import 'package:equatable/equatable.dart';

class Response extends Equatable {
  const Response({
    required this.questionId,
    required this.answerIndex,
    required this.answeredAt,
  });

  final String questionId;
  final int answerIndex;
  final DateTime answeredAt;

  @override
  List<Object?> get props => [questionId, answerIndex, answeredAt];
  
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answerIndex': answerIndex,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }
  
  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      questionId: json['questionId'],
      answerIndex: json['answerIndex'],
      answeredAt: DateTime.parse(json['answeredAt']),
    );
  }
}
