import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/assessment_result.dart';
import 'questionnaire_dependencies.dart';

final assessmentHistoryProvider = FutureProvider<List<AssessmentResult>>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated) {
    return const [];
  }

  final repository = ref.watch(questionnaireRepositoryProvider);
  final result = await repository.fetchResults();
  return result.fold(
    (failure) => Future.error(failure.message, StackTrace.current),
    (assessments) => assessments,
  );
});
