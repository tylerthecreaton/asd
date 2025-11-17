# Phase 2 Implementation Guide: Questionnaire Module (M-CHAT)

This guide provides detailed steps for implementing Phase 2 of the Flutter Autism Screening App, focusing on the M-CHAT questionnaire module.

## Progress Tracker

- [x] Step 1: Set Up Authentication Flow
- [x] Step 2: Implement M-CHAT Questionnaire
- [x] Step 3: Create Questionnaire UI
- [x] Step 4: Implement Results Screen
- [x] Step 5: Create PDF Service
- [x] Step 6: Update Router

## Step 1: Set Up Authentication Flow

Create [`lib/features/authentication/domain/entities/user.dart`](lib/features/authentication/domain/entities/user.dart:1):

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, email, name, createdAt, updatedAt];
}
```

Create [`lib/features/authentication/data/models/user_model.dart`](lib/features/authentication/data/models/user_model.dart:1):

```dart
import 'package:asd/features/authentication/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
```

Create [`lib/features/authentication/domain/repositories/auth_repository.dart`](lib/features/authentication/domain/repositories/auth_repository.dart:1):

```dart
import 'package:dartz/dartz.dart';
import 'package:asd/core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp(String email, String password, String? name);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<Either<Failure, User?>> get authStateChanges;
}
```

Create [`lib/features/authentication/data/repositories/auth_repository_impl.dart`](lib/features/authentication/data/repositories/auth_repository_impl.dart:1):

```dart
import 'package:dartz/dartz.dart';
import 'package:asd/core/errors/failures.dart';
import 'package:asd/core/network/network_info.dart';
import 'package:asd/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:asd/features/authentication/data/models/user_model.dart';
import 'package:asd/features/authentication/domain/entities/user.dart';
import 'package:asd/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signIn(email, password);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(const NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password, String? name) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(email, password, name);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(const NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(const NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(const NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, User?>> get authStateChanges {
    return remoteDataSource.authStateChanges.map(
      (user) => Right(user),
    );
  }
}
```

## Step 2: Implement M-CHAT Questionnaire

Create [`lib/features/questionnaire/domain/entities/question.dart`](lib/features/questionnaire/domain/entities/question.dart:1):

```dart
import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String text;
  final String? description;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.id,
    required this.text,
    this.description,
    required this.options,
    required this.correctAnswerIndex,
  });

  @override
  List<Object?> get props => [id, text, description, options, correctAnswerIndex];
}
```

Create [`lib/features/questionnaire/domain/entities/questionnaire.dart`](lib/features/questionnaire/domain/entities/questionnaire.dart:1):

```dart
import 'package:equatable/equatable.dart';
import 'question.dart';

class Questionnaire extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final int passingScore;

  const Questionnaire({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.passingScore,
  });

  @override
  List<Object?> get props => [id, title, description, questions, passingScore];
}
```

Create [`lib/features/questionnaire/domain/entities/response.dart`](lib/features/questionnaire/domain/entities/response.dart:1):

```dart
import 'package:equatable/equatable.dart';

class Response extends Equatable {
  final String questionId;
  final int answerIndex;
  final DateTime answeredAt;

  const Response({
    required this.questionId,
    required this.answerIndex,
    required this.answeredAt,
  });

  @override
  List<Object?> get props => [questionId, answerIndex, answeredAt];
}
```

Create [`lib/features/questionnaire/domain/entities/assessment_result.dart`](lib/features/questionnaire/domain/entities/assessment_result.dart:1):

```dart
import 'package:equatable/equatable.dart';

enum RiskLevel { low, medium, high }

class AssessmentResult extends Equatable {
  final String id;
  final String questionnaireId;
  final String userId;
  final int score;
  final int totalQuestions;
  final RiskLevel riskLevel;
  final List<String> flaggedBehaviors;
  final DateTime completedAt;
  final Map<String, dynamic> recommendations;

  const AssessmentResult({
    required this.id,
    required this.questionnaireId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.riskLevel,
    required this.flaggedBehaviors,
    required this.completedAt,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [
        id,
        questionnaireId,
        userId,
        score,
        totalQuestions,
        riskLevel,
        flaggedBehaviors,
        completedAt,
        recommendations,
      ];
}
```

Create [`lib/features/questionnaire/data/models/mchat_questions.dart`](lib/features/questionnaire/data/models/mchat_questions.dart:1):

```dart
import 'package:asd/features/questionnaire/domain/entities/question.dart';
import 'package:asd/features/questionnaire/domain/entities/questionnaire.dart';

class MChatQuestions {
  static const Questionnaire mchatQuestionnaire = Questionnaire(
    id: 'mchat',
    title: 'M-CHAT',
    description: 'Modified Checklist for Autism in Toddlers',
    questions: [
      Question(
        id: 'q1',
        text: 'Does your child enjoy being swung, bounced on your knee, etc.?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q2',
        text: 'Does your child take interest in other children?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q3',
        text: 'Does your child like climbing on things, such as up stairs?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q4',
        text: 'Does your child enjoy playing peek-a-boo/hide-and-seek?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q5',
        text: 'Does your child ever pretend, for example, to talk on the phone or take care of a doll or pretend other things?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q6',
        text: 'Does your child ever use his/her index finger to point, to ask for something?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q7',
        text: 'Does your child ever use his/her index finger to point, to indicate interest in something?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q8',
        text: 'Can your child play properly with small toys (e.g., cars or bricks) without just mouthing, fiddling, or dropping them?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q9',
        text: 'Does your child ever bring objects over to you (parent) to show you something?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q10',
        text: 'Does your child look you in the eye for more than a second or two?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q11',
        text: 'Does your child ever seem oversensitive to noise? (e.g., plugging ears)',
        options: ['Yes', 'No'],
        correctAnswerIndex: 1, // No is the correct answer
      ),
      Question(
        id: 'q12',
        text: 'Does your child smile in response to your face or your smile?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q13',
        text: 'Does your child imitate you? (e.g., you make a face-will your child imitate it?)',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q14',
        text: 'Does your child respond to his/her name when you call their name?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q15',
        text: 'If you point at a toy across the room, does your child look at it?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q16',
        text: 'Does your child walk?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q17',
        text: 'Does your child look at things you are looking at?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q18',
        text: 'Does your child make unusual finger movements near his/her face?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 1, // No is the correct answer
      ),
      Question(
        id: 'q19',
        text: 'Does your child try to attract your attention to his/her own activity?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q20',
        text: 'Have you ever wondered if your child is deaf?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 1, // No is the correct answer
      ),
      Question(
        id: 'q21',
        text: 'Does your child understand what people say?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q22',
        text: 'Does your child sometimes stare at nothing or wander with no purpose?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 1, // No is the correct answer
      ),
      Question(
        id: 'q23',
        text: 'Does your child look at your face to check your reaction when faced with something unfamiliar?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
    ],
    passingScore: 3, // More than 3 "No" answers indicates risk
  );
}
```

## Step 3: Create Questionnaire UI

Create [`lib/features/questionnaire/presentation/pages/questionnaire_page.dart`](lib/features/questionnaire/presentation/pages/questionnaire_page.dart:1):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/questionnaire_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/progress_indicator.dart';
import '../../../core/constants/route_constants.dart';

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

  void _nextPage() {
    if (_currentPage < ref.read(questionnaireProvider).questionnaire!.questions.length - 1) {
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

  void _submitQuestionnaire() async {
    final success = await ref.read(questionnaireProvider.notifier).submitQuestionnaire();
    if (success && mounted) {
      context.go(RouteConstants.questionnaireResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionnaireState = ref.watch(questionnaireProvider);

    return questionnaireState.when(
      data: (questionnaireState) {
        if (questionnaireState.questionnaire == null) {
          return const Scaffold(
            body: Center(child: Text('Questionnaire not found')),
          );
        }

        final questions = questionnaireState.questionnaire!.questions;
        final responses = questionnaireState.responses;

        return Scaffold(
          appBar: AppBar(
            title: Text(questionnaireState.questionnaire!.title),
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
              final responseIndex = responses.indexWhere(
                (r) => r.questionId == question.id,
              );
              final selectedAnswer = responseIndex != -1
                  ? responses[responseIndex].answerIndex
                  : null;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuestionCard(
                  question: question,
                  selectedAnswer: selectedAnswer,
                  onAnswerSelected: (answerIndex) {
                    ref.read(questionnaireProvider.notifier).updateResponse(
                      question.id,
                      answerIndex,
                    );
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
                  onPressed: _canProceed(_currentPage, responses) ? _nextPage : null,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  bool _canProceed(int currentPage, List<Response> responses) {
    if (currentPage >= responses.length) return false;
    final currentQuestion = ref.read(questionnaireProvider).questionnaire!.questions[currentPage];
    return responses.any((r) => r.questionId == currentQuestion.id);
  }
}
```

Create [`lib/features/questionnaire/presentation/widgets/question_card.dart`](lib/features/questionnaire/presentation/widgets/question_card.dart:1):

```dart
import 'package:flutter/material.dart';
import 'package:asd/features/questionnaire/domain/entities/question.dart';
import '../../../common/widgets/custom_button.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final int? selectedAnswer;
  final Function(int) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _selectedAnswer = widget.selectedAnswer;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${widget.question.id.substring(1)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.question.text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (widget.question.description != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.question.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 32),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.question.options.length,
            itemBuilder: (context, index) {
              final option = widget.question.options[index];
              final isSelected = _selectedAnswer == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CustomButton(
                  text: option,
                  onPressed: () {
                    setState(() {
                      _selectedAnswer = index;
                    });
                    widget.onAnswerSelected(index);
                  },
                  buttonType: isSelected
                      ? ButtonType.elevated
                      : ButtonType.outlined,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

Create [`lib/features/questionnaire/presentation/widgets/progress_indicator.dart`](lib/features/questionnaire/presentation/widgets/progress_indicator.dart:1):

```dart
import 'package:flutter/material.dart';

class QuestionnaireProgressIndicator extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;

  const QuestionnaireProgressIndicator({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentQuestion / totalQuestions;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '$currentQuestion of $totalQuestions',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
```

## Step 4: Implement Results Screen

Create [`lib/features/questionnaire/presentation/pages/results_page.dart`](lib/features/questionnaire/presentation/pages/results_page.dart:1):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../providers/questionnaire_provider.dart';
import '../widgets/results_summary.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../core/services/pdf_service.dart';

class QuestionnaireResultsPage extends ConsumerWidget {
  const QuestionnaireResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultState = ref.watch(questionnaireResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(context, ref),
          ),
        ],
      ),
      body: resultState.when(
        data: (result) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResultsSummary(result: result),
                const SizedBox(height: 24),
                _buildDisclaimer(context),
                const SizedBox(height: 24),
                _buildActionButtons(context, ref, result),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading results: $error'),
        ),
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Important Disclaimer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This screening tool is designed for preliminary assessment only and '
              'is not a substitute for professional medical diagnosis. '
              'Please consult with a qualified healthcare professional for a '
              'comprehensive evaluation and diagnosis.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, result) {
    return Column(
      children: [
        CustomButton(
          text: 'Download PDF Report',
          onPressed: () => _downloadPdf(context, ref, result),
          icon: const Icon(Icons.download),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'View Recommendations',
          onPressed: () => _viewRecommendations(context, result),
          buttonType: ButtonType.outlined,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Return to Home',
          onPressed: () => context.go('/home'),
          buttonType: ButtonType.text,
        ),
      ],
    );
  }

  void _downloadPdf(BuildContext context, WidgetRef ref, result) async {
    try {
      final pdfFile = await PdfService.generateQuestionnaireReport(result);
      await Printing.sharePdf(
        bytes: await pdfFile.save(),
        filename: 'asd_screening_results.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }

  void _shareResults(BuildContext context, WidgetRef ref) {
    // Implement sharing functionality
  }

  void _viewRecommendations(BuildContext context, result) {
    // Navigate to recommendations screen
  }
}
```

## Step 5: Create PDF Service

Create [`lib/core/services/pdf_service.dart`](lib/core/services/pdf_service.dart:1):

```dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:asd/features/questionnaire/domain/entities/assessment_result.dart';

class PdfService {
  static Future<pw.Document> generateQuestionnaireReport(AssessmentResult result) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ASD Screening Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: boldFont,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Assessment Date: ${_formatDate(result.completedAt)}',
                style: pw.TextStyle(fontSize: 12, font: font),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Questionnaire: M-CHAT',
                style: pw.TextStyle(fontSize: 12, font: font),
              ),
              pw.SizedBox(height: 20),
              _buildRiskAssessment(result, font, boldFont),
              pw.SizedBox(height: 20),
              _buildScoreSummary(result, font, boldFont),
              pw.SizedBox(height: 20),
              _buildRecommendations(result, font, boldFont),
              pw.SizedBox(height: 30),
              _buildDisclaimer(font),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildRiskAssessment(AssessmentResult result, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _getRiskColor(result.riskLevel),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Risk Assessment',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              font: boldFont,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            _getRiskLevelText(result.riskLevel),
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              font: boldFont,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildScoreSummary(AssessmentResult result, pw.Font font, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Score Summary',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            font: boldFont,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Total Score: ${result.score}/${result.totalQuestions}',
          style: pw.TextStyle(fontSize: 14, font: font),
        ),
        if (result.flaggedBehaviors.isNotEmpty) ...[
          pw.SizedBox(height: 10),
          pw.Text(
            'Flagged Behaviors:',
            style: pw.TextStyle(fontSize: 14, font: boldFont),
          ),
          ...result.flaggedBehaviors.map(
            (behavior) => pw.Text(
              '• $behavior',
              style: pw.TextStyle(fontSize: 12, font: font),
            ),
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildRecommendations(AssessmentResult result, pw.Font font, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Recommendations',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            font: boldFont,
          ),
        ),
        pw.SizedBox(height: 10),
        ...result.recommendations.entries.map(
          (entry) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entry.key,
                style: pw.TextStyle(fontSize: 14, font: boldFont),
              ),
              pw.Text(
                entry.value.toString(),
                style: pw.TextStyle(fontSize: 12, font: font),
              ),
              pw.SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildDisclaimer(pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Disclaimer',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              font: font,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'This screening tool is designed for preliminary assessment only and '
            'is not a substitute for professional medical diagnosis. '
            'Please consult with a qualified healthcare professional for a '
            'comprehensive evaluation and diagnosis.',
            style: pw.TextStyle(fontSize: 10, font: font),
          ),
        ],
      ),
    );
  }

  static PdfColor _getRiskColor(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.low:
        return PdfColors.green;
      case RiskLevel.medium:
        return PdfColors.orange;
      case RiskLevel.high:
        return PdfColors.red;
    }
  }

  static String _getRiskLevelText(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
```

## Step 6: Update Router

Update [`lib/app/router/routes.dart`](lib/app/router/routes.dart:1) to include the questionnaire routes:

```dart
// Add these routes to your existing GoRouter configuration
GoRoute(
  path: RouteConstants.questionnaireIntro,
  name: 'questionnaireIntro',
  builder: (context, state) => const QuestionnaireIntroPage(),
),
GoRoute(
  path: RouteConstants.questionnaire,
  name: 'questionnaire',
  builder: (context, state) => const QuestionnairePage(),
),
GoRoute(
  path: RouteConstants.questionnaireResults,
  name: 'questionnaireResults',
  builder: (context, state) => const QuestionnaireResultsPage(),
),
```

## Next Steps

After completing these steps, you'll have:

1. A complete authentication flow with Supabase integration
2. M-CHAT questionnaire implementation with all 23 questions
3. Interactive questionnaire UI with progress tracking
4. Results screen with risk assessment visualization
5. PDF report generation functionality
6. Proper navigation between all questionnaire screens

The next phase will focus on implementing the video analysis module with camera integration and video recording capabilities.
