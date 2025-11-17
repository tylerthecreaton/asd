import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:asd/core/constants/route_constants.dart';

import '../../../common/widgets/custom_button.dart';
import '../providers/questionnaire_provider.dart';

class QuestionnaireIntroPage extends ConsumerWidget {
  const QuestionnaireIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionnaireAsync = ref.watch(questionnaireProvider);
    final questionnaire = questionnaireAsync.value?.questionnaire;

    return Scaffold(
      appBar: AppBar(
        title: Text(questionnaire?.title ?? 'M-CHAT Questionnaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionnaire?.title ?? 'M-CHAT',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              questionnaire?.description ??
                  'Modified Checklist for Autism in Toddlers (M-CHAT) helps screen early ASD indicators.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _buildInstruction(
              context,
              'Answer each question about your child\'s typical behavior.',
            ),
            _buildInstruction(
              context,
              'Select the option that best describes how your child behaves most of the time.',
            ),
            _buildInstruction(
              context,
              'If you need to leave, your progress is saved for this session.',
            ),
            const Spacer(),
            CustomButton(
              text: 'Start Questionnaire',
              width: double.infinity,
              onPressed: () async {
                await ref
                    .read(questionnaireProvider.notifier)
                    .resetQuestionnaire();
                if (context.mounted) {
                  context.go(RouteConstants.questionnaire);
                }
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Back to Home',
              buttonType: ButtonType.text,
              width: double.infinity,
              onPressed: () => context.go(RouteConstants.home),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
