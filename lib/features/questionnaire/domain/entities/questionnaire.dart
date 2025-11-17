import 'package:equatable/equatable.dart';

import 'question.dart';

class Questionnaire extends Equatable {
  const Questionnaire({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.passingScore,
  });

  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final int passingScore;

  @override
  List<Object?> get props => [id, title, description, questions, passingScore];
}
