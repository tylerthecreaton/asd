import 'package:equatable/equatable.dart';

class Question extends Equatable {
  const Question({
    required this.id,
    required this.text,
    this.description,
    required this.options,
    required this.correctAnswerIndex,
  });

  final String id;
  final String text;
  final String? description;
  final List<String> options;
  final int correctAnswerIndex;

  @override
  List<Object?> get props => [
    id,
    text,
    description,
    options,
    correctAnswerIndex,
  ];
}
