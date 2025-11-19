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
    this.type = 'standard',
    this.maxScore = 0,
  });

  final String id;
  final String slug;
  final String title;
  final String description;
  final List<Question> questions;
  final int passingScore;
  final String type; // 'standard' or 'qchat'
  final int maxScore;

  @override
  List<Object?> get props => [
    id,
    slug,
    title,
    description,
    questions,
    passingScore,
    type,
    maxScore,
  ];
}
