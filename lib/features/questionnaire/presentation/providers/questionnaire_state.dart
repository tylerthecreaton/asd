part of 'questionnaire_provider.dart';

class QuestionnaireState {
  const QuestionnaireState({
    required this.questionnaire,
    required this.responses,
    this.latestResult,
    this.isSubmitting = false,
  });

  final Questionnaire? questionnaire;
  final List<response_entity.Response> responses;
  final AssessmentResult? latestResult;
  final bool isSubmitting;

  QuestionnaireState copyWith({
    Questionnaire? questionnaire,
    List<response_entity.Response>? responses,
    AssessmentResult? latestResult,
    bool? isSubmitting,
    bool clearResult = false,
  }) {
    return QuestionnaireState(
      questionnaire: questionnaire ?? this.questionnaire,
      responses: responses ?? this.responses,
      latestResult: clearResult ? null : (latestResult ?? this.latestResult),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
