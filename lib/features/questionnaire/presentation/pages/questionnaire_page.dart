import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:asd/core/constants/route_constants.dart';
import 'package:asd/features/questionnaire/domain/entities/questionnaire.dart';
import 'package:asd/features/questionnaire/domain/entities/response.dart'
    as response_entity;

import '../../../common/widgets/custom_button.dart';
import '../providers/questionnaire_provider.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/question_card.dart';

class QuestionnairePage extends ConsumerStatefulWidget {
  const QuestionnairePage({super.key});

  @override
  ConsumerState<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends ConsumerState<QuestionnairePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int totalQuestions) {
    if (_currentPage < totalQuestions - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitQuestionnaire();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _submitQuestionnaire() async {
    final success = await ref
        .read(questionnaireProvider.notifier)
        .submitQuestionnaire();
    if (success && mounted) {
      context.go(RouteConstants.questionnaireResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionnaireState = ref.watch(questionnaireProvider);

    return questionnaireState.when(
      data: (state) {
        final questionnaire = state.questionnaire;
        if (questionnaire == null) {
          return const Scaffold(
            body: Center(child: Text('Questionnaire not available')),
          );
        }

        final responses = state.responses;
        final questions = questionnaire.questions;

        return Scaffold(
          appBar: AppBar(
            title: Text(questionnaire.title),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: QuestionnaireProgressIndicator(
                currentQuestion: _currentPage + 1,
                totalQuestions: questions.length,
              ),
            ),
          ),
          body: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              response_entity.Response? selectedResponse;
              for (final response in responses) {
                if (response.questionId == question.id) {
                  selectedResponse = response;
                  break;
                }
              }
              final selectedAnswer = selectedResponse?.answerIndex;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuestionCard(
                  question: question,
                  selectedAnswer: selectedAnswer,
                  onAnswerSelected: (answerIndex) {
                    ref
                        .read(questionnaireProvider.notifier)
                        .updateResponse(question.id, answerIndex);
                    setState(() {});
                  },
                ),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: 'Previous',
                  onPressed: _currentPage > 0 ? _previousPage : null,
                  buttonType: ButtonType.outlined,
                ),
                CustomButton(
                  text: _currentPage < questions.length - 1 ? 'Next' : 'Submit',
                  onPressed: _canProceed(questionnaire, _currentPage, responses)
                      ? () => _nextPage(questions.length)
                      : null,
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }

  bool _canProceed(
    Questionnaire questionnaire,
    int currentPage,
    List<response_entity.Response> responses,
  ) {
    final questions = questionnaire.questions;
    if (currentPage >= questions.length) return false;
    final currentQuestionId = questions[currentPage].id;
    return responses.any((r) => r.questionId == currentQuestionId);
  }
}
