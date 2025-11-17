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
}
