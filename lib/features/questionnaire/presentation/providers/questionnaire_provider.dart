import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../questionnaire/data/models/mchat_questions.dart';
import '../../../questionnaire/domain/entities/assessment_result.dart';
import '../../../questionnaire/domain/entities/questionnaire.dart';
import '../../../questionnaire/domain/entities/response.dart'
    as response_entity;

part 'questionnaire_state.dart';

final questionnaireProvider =
    AutoDisposeAsyncNotifierProvider<
      QuestionnaireController,
      QuestionnaireState
    >(QuestionnaireController.new);

final questionnaireResultsProvider = Provider<AsyncValue<AssessmentResult?>>((
  ref,
) {
  final questionnaireState = ref.watch(questionnaireProvider);
  return questionnaireState.whenData((state) => state.latestResult);
});

class QuestionnaireController
    extends AutoDisposeAsyncNotifier<QuestionnaireState> {
  @override
  Future<QuestionnaireState> build() async {
    return const QuestionnaireState(
      questionnaire: MChatQuestions.questionnaire,
      responses: [],
      latestResult: null,
    );
  }

  void updateResponse(String questionId, int answerIndex) {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedResponses = List<response_entity.Response>.from(
      currentState.responses,
    );
    final responseIndex = updatedResponses.indexWhere(
      (r) => r.questionId == questionId,
    );
    final updatedResponse = response_entity.Response(
      questionId: questionId,
      answerIndex: answerIndex,
      answeredAt: DateTime.now(),
    );

    if (responseIndex == -1) {
      updatedResponses.add(updatedResponse);
    } else {
      updatedResponses[responseIndex] = updatedResponse;
    }

    state = AsyncValue.data(
      currentState.copyWith(
        responses: List.unmodifiable(updatedResponses),
        clearResult: true,
      ),
    );
  }

  Future<void> resetQuestionnaire() async {
    state = const AsyncValue.loading();
    state = const AsyncValue.data(
      QuestionnaireState(
        questionnaire: MChatQuestions.questionnaire,
        responses: [],
        latestResult: null,
      ),
    );
  }

  Future<bool> submitQuestionnaire() async {
    final currentState = state.value;
    if (currentState == null || currentState.questionnaire == null) {
      return false;
    }
    final questionnaire = currentState.questionnaire!;
    if (currentState.responses.length < questionnaire.questions.length) {
      return false;
    }

    final result = _calculateResult(questionnaire, currentState.responses);
    state = AsyncValue.data(currentState.copyWith(latestResult: result));
    return true;
  }

  AssessmentResult _calculateResult(
    Questionnaire questionnaire,
    List<response_entity.Response> responses,
  ) {
    final questions = questionnaire.questions;
    var score = 0;
    final flagged = <String>[];

    for (final question in questions) {
      final response = responses.firstWhere((r) => r.questionId == question.id);
      final isCorrect = response.answerIndex == question.correctAnswerIndex;
      if (!isCorrect) {
        score++;
        flagged.add(question.text);
      }
    }

    final riskLevel = _determineRiskLevel(score);
    final recommendations = _buildRecommendations(riskLevel, flagged);

    return AssessmentResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questionnaireId: questionnaire.id,
      userId: 'anonymous',
      score: score,
      totalQuestions: questions.length,
      riskLevel: riskLevel,
      flaggedBehaviors: flagged,
      completedAt: DateTime.now(),
      recommendations: recommendations,
    );
  }

  RiskLevel _determineRiskLevel(int score) {
    if (score <= 2) {
      return RiskLevel.low;
    } else if (score <= 5) {
      return RiskLevel.medium;
    }
    return RiskLevel.high;
  }

  Map<String, dynamic> _buildRecommendations(
    RiskLevel riskLevel,
    List<String> flaggedBehaviors,
  ) {
    switch (riskLevel) {
      case RiskLevel.low:
        return {
          'Summary': 'Low risk observed. Continue regular monitoring.',
          'Suggested Action':
              'Re-screen in 3 months or sooner if concerns arise.',
        };
      case RiskLevel.medium:
        return {
          'Summary': 'Moderate risk detected.',
          'Suggested Action':
              'Consult a pediatric specialist and consider scheduling a professional screening.',
          'Flagged Behaviors': flaggedBehaviors,
        };
      case RiskLevel.high:
        return {
          'Summary': 'High risk detected for ASD indicators.',
          'Suggested Action':
              'Seek immediate consultation with a developmental pediatrician.',
          'Flagged Behaviors': flaggedBehaviors,
        };
    }
  }
}
