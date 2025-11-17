part of 'questionnaire_provider.dart';

class QuestionnaireState {
  const QuestionnaireState({
    required this.questionnaire,
    required this.responses,
    this.latestResult,
  });

  final Questionnaire? questionnaire;
  final List<response_entity.Response> responses;
  final AssessmentResult? latestResult;

  QuestionnaireState copyWith({
    Questionnaire? questionnaire,
    List<response_entity.Response>? responses,
    AssessmentResult? latestResult,
    bool clearResult = false,
  }) {
    return QuestionnaireState(
      questionnaire: questionnaire ?? this.questionnaire,
      responses: responses ?? this.responses,
      latestResult: clearResult ? null : (latestResult ?? this.latestResult),
    );
  }
}
