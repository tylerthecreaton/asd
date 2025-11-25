import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../questionnaire/domain/entities/assessment_result.dart';
import '../../../questionnaire/domain/entities/questionnaire.dart';
import '../../../questionnaire/domain/entities/question.dart';
import '../../../questionnaire/domain/entities/response.dart'
    as response_entity;
import '../../../questionnaire/domain/repositories/questionnaire_repository.dart';
import 'questionnaire_dependencies.dart';

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
  static const String _defaultQuestionnaireIdentifier =
      AppConstants.defaultQuestionnaireSlug;

  QuestionnaireRepository get _repository =>
      ref.read(questionnaireRepositoryProvider);

  @override
  Future<QuestionnaireState> build() async {
    final questionnaire = await _loadQuestionnaire();
    return QuestionnaireState(
      questionnaire: questionnaire,
      responses: const [],
      latestResult: null,
    );
  }

  void updateResponse(String questionId, int answerIndex, {int? points}) {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedResponses = List<response_entity.Response>.from(
      currentState.responses,
    );
    final responseIndex = updatedResponses.indexWhere(
      (r) => r.questionId == questionId,
    );

    // Calculate points based on scoring type if not provided
    final calculatedPoints =
        points ?? _calculatePoints(questionId, answerIndex, currentState);

    final updatedResponse = response_entity.Response(
      questionId: questionId,
      answerIndex: answerIndex,
      answeredAt: DateTime.now(),
      points: calculatedPoints,
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

  int _calculatePoints(
    String questionId,
    int answerIndex,
    QuestionnaireState currentState,
  ) {
    final questionnaire = currentState.questionnaire;
    if (questionnaire == null) return 0;

    Question? question;
    try {
      question = questionnaire.questions.firstWhere((q) => q.id == questionId);
    } catch (e) {
      // Question not found, return 0
      return 0;
    }

    if (question.scoringType == 'qchat_standard') {
      // Q-CHAT Standard scoring: index 0 (ไม่ใช่) = 1 point (risk)
      return answerIndex == 0 ? 1 : 0;
    } else if (question.scoringType == 'qchat_reverse') {
      // Q-CHAT Reverse scoring: index 1 (ใช่) = 1 point (risk)
      return answerIndex == 1 ? 1 : 0;
    } else if (question.scoringType == 'qchat') {
      // Legacy Q-CHAT scoring (for backward compatibility)
      return answerIndex == 0 ? 1 : 0;
    } else {
      // Standard binary scoring
      return answerIndex != question.correctAnswerIndex ? 1 : 0;
    }
  }

  Future<void> resetQuestionnaire() async {
    final currentState = state.value;
    if (currentState == null) {
      state = const AsyncValue.loading();
      final questionnaire = await _loadQuestionnaire();
      state = AsyncValue.data(
        QuestionnaireState(
          questionnaire: questionnaire,
          responses: const [],
          latestResult: null,
        ),
      );
      return;
    }

    state = AsyncValue.data(
      QuestionnaireState(
        questionnaire: currentState.questionnaire,
        responses: const [],
        latestResult: null,
      ),
    );
  }

  Future<Either<Failure, AssessmentResult>> submitQuestionnaire() async {
    final currentState = state.value;
    if (currentState == null || currentState.questionnaire == null) {
      return const Left(ValidationFailure('แบบประเมินไม่พร้อมใช้งาน'));
    }
    final questionnaire = currentState.questionnaire!;
    if (currentState.responses.length < questionnaire.questions.length) {
      return const Left(ValidationFailure('กรุณาตอบคำถามให้ครบทุกข้อ'));
    }

    _setSubmitting(true);

    final identifier = questionnaire.slug.isNotEmpty
        ? questionnaire.slug
        : questionnaire.id;

    // Submit responses with calculated points
    final result = await _repository.submitResponses(
      identifier: identifier,
      responses: currentState.responses,
    );

    return result.fold(
      (failure) {
        _setSubmitting(false);
        return Left(failure);
      },
      (assessment) {
        state = AsyncValue.data(
          currentState.copyWith(latestResult: assessment, isSubmitting: false),
        );
        return Right(assessment);
      },
    );
  }

  Future<void> reloadQuestionnaire() async {
    state = const AsyncValue.loading();
    final questionnaire = await _loadQuestionnaire();
    state = AsyncValue.data(
      QuestionnaireState(
        questionnaire: questionnaire,
        responses: const [],
        latestResult: null,
      ),
    );
  }

  Future<Questionnaire> _loadQuestionnaire() async {
    final result = await _repository.fetchQuestionnaire(
      _defaultQuestionnaireIdentifier,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (questionnaire) => questionnaire,
    );
  }

  void _setSubmitting(bool value) {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncValue.data(currentState.copyWith(isSubmitting: value));
  }
}
