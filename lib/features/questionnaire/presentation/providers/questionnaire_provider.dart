import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../questionnaire/domain/entities/assessment_result.dart';
import '../../../questionnaire/domain/entities/questionnaire.dart';
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
