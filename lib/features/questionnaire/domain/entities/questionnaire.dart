import 'package:equatable/equatable.dart';

import 'question.dart';

class Questionnaire extends Equatable {
  const Questionnaire({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.questions,
    required this.passingScore,
  });

  final String id;
  final String slug;
  final String title;
  final String description;
  final List<Question> questions;
  final int passingScore;

  @override
  List<Object?> get props => [
    id,
    slug,
    title,
    description,
    questions,
    passingScore,
  ];
}
