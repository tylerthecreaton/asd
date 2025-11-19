import '../../domain/entities/questionnaire.dart';
import 'question_model.dart';

class QuestionnaireModel extends Questionnaire {
  const QuestionnaireModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.description,
    required super.questions,
    required super.passingScore,
    super.type = 'standard',
    super.maxScore = 0,
  });

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'] as List<dynamic>?;
    final questions = questionsJson == null
        ? <QuestionModel>[]
        : questionsJson
              .map(
                (question) =>
                    QuestionModel.fromJson(question as Map<String, dynamic>),
              )
              .toList(growable: false);

    final id = json['id'] as String? ?? '';
    final slug = json['slug'] as String? ?? id;

    return QuestionnaireModel(
      id: id,
      slug: slug,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      questions: questions,
      passingScore: json['passingScore'] as int? ?? 0,
      type: json['type'] as String? ?? 'standard',
      maxScore: json['maxScore'] as int? ?? 0,
    );
  }
}
