import 'package:equatable/equatable.dart';

class Question extends Equatable {
  const Question({
    required this.id,
    required this.text,
    this.description,
    required this.options,
    required this.correctAnswerIndex,
    this.scoringType = 'binary',
    this.maxPoints = 1,
  });

  final String id;
  final String text;
  final String? description;
  final List<String> options;
  final int correctAnswerIndex;
  final String scoringType; // 'binary' or 'qchat'
  final int maxPoints;

  @override
  List<Object?> get props => [
    id,
    text,
    description,
    options,
    correctAnswerIndex,
    scoringType,
    maxPoints,
  ];
}
