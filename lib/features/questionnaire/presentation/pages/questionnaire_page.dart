import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

class _QuestionnairePageState extends ConsumerState<QuestionnairePage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  Timer? _autoSaveTimer;
  int _secondsElapsed = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showValidationMessage = false;
  bool _showAutoSaveIndicator = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initAnimations();
    _loadSavedProgress();
    _startAutoSave();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _saveProgress();
    });
  }

  Future<void> _saveProgress() async {
    try {
      const storage = FlutterSecureStorage();
      final questionnaireState = ref.read(questionnaireProvider);
      
      if (questionnaireState is AsyncData) {
        final state = questionnaireState.value;
        if (state != null && state.questionnaire != null) {
          final questionnaireId = state.questionnaire!.id;
          final responsesJson = state.responses.map((r) => r.toJson()).toList();
          
          await storage.write(
            key: 'questionnaire_$questionnaireId',
            value: jsonEncode(responsesJson),
          );
          await storage.write(
            key: 'questionnaire_${questionnaireId}_page',
            value: _currentPage.toString(),
          );
          await storage.write(
            key: 'questionnaire_${questionnaireId}_time',
            value: _secondsElapsed.toString(),
          );
          
          if (mounted) {
            setState(() {
              _showAutoSaveIndicator = true;
            });
            
            // Hide auto-save indicator after 2 seconds
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _showAutoSaveIndicator = false;
                });
              }
            });
          }
        }
      }
    } catch (e) {
      // Handle error silently for now
      debugPrint('Error saving progress: $e');
    }
  }

  Future<void> _loadSavedProgress() async {
    try {
      const storage = FlutterSecureStorage();
      final questionnaireState = ref.read(questionnaireProvider);
      
      if (questionnaireState is AsyncData) {
        final state = questionnaireState.value;
        if (state != null && state.questionnaire != null) {
          final questionnaireId = state.questionnaire!.id;
          final savedPageStr = await storage.read(key: 'questionnaire_${questionnaireId}_page');
          final savedTimeStr = await storage.read(key: 'questionnaire_${questionnaireId}_time');
          
          if (savedPageStr != null && savedTimeStr != null) {
            final savedPage = int.tryParse(savedPageStr) ?? 0;
            final savedTime = int.tryParse(savedTimeStr) ?? 0;
            
            setState(() {
              _secondsElapsed = savedTime;
            });
            
            // We'll restore the page after a short delay to ensure everything is loaded
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted && savedPage > 0) {
                _pageController.animateToPage(
                  savedPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                setState(() {
                  _currentPage = savedPage;
                });
              }
            });
          }
        }
      }
    } catch (e) {
      // Handle error silently for now
      debugPrint('Error loading progress: $e');
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    _autoSaveTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _saveProgress(); // Save progress when disposing
    super.dispose();
  }

  void _nextPage(int totalQuestions, List<response_entity.Response> responses, Questionnaire questionnaire) {
    if (!_canProceed(questionnaire, _currentPage, responses)) {
      setState(() {
        _showValidationMessage = true;
      });
      // Hide validation message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showValidationMessage = false;
          });
        }
      });
      return;
    }
    
    setState(() {
      _showValidationMessage = false;
    });
    
    if (_currentPage < totalQuestions - 1) {
      _fadeController.reverse().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
        _fadeController.forward();
      });
    } else {
      _submitQuestionnaire();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _fadeController.reverse().then((_) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
        _fadeController.forward();
      });
      setState(() {
        _showValidationMessage = false;
      });
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

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text('ออกจากแบบสอบถาม'),
              ],
            ),
            content: const Text(
              'คุณต้องการออกจากแบบสอบถามหรือไม่? คำตอบทั้งหมดจะไม่ถูกบันทึก',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ยกเลิก',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(RouteConstants.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ออก',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
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
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _showExitConfirmationDialog();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 20,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(_secondsElapsed),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Enhanced progress indicator at the top of the body
              QuestionnaireProgressIndicator(
                currentQuestion: _currentPage + 1,
                totalQuestions: questions.length,
              ),
              
              // Validation message
              if (_showValidationMessage)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_outlined,
                           color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'กรุณาเลือกคำตอบก่อนดำเนินการต่อ',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // PageView for questions with animation
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: PageView.builder(
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
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Encouragement message for last question
                if (_currentPage == questions.length - 1)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.celebration_outlined,
                             color: Colors.green.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'เกือบเสร็จแล้ว! กดส่งคำตอบเพื่อดูผลลัพธ์',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'ย้อนกลับ',
                      onPressed: _currentPage > 0 ? _previousPage : null,
                      buttonType: ButtonType.outlined,
                      icon: const Icon(Icons.arrow_back, size: 18),
                    ),
                    CustomButton(
                      text: _currentPage < questions.length - 1 ? 'ถัดไป' : 'ส่งคำตอบ',
                      onPressed: () => _nextPage(questions.length, responses, questionnaire),
                      icon: _currentPage < questions.length - 1
                          ? const Icon(Icons.arrow_forward, size: 18)
                          : const Icon(Icons.check_circle, size: 18),
                    ),
                  ],
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
