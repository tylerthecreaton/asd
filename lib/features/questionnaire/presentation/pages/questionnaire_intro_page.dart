import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:asd/core/constants/route_constants.dart';
import 'package:asd/l10n/app_localizations.dart';

import '../../../common/widgets/custom_button.dart';
import '../providers/questionnaire_provider.dart';

class QuestionnaireIntroPage extends ConsumerWidget {
  const QuestionnaireIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final questionnaireAsync = ref.watch(questionnaireProvider);
    final questionnaire = questionnaireAsync.value?.questionnaire;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(questionnaire?.title ?? l10n.questionnaireIntroTitle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor.withOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header card with icon
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          questionnaire?.title ?? l10n.questionnaireIntroTitle,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          questionnaire?.description ?? l10n.questionnaireIntroDescription,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Instructions section
                Text(
                  'คำแนะนำในการทำแบบสอบถาม',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Instructions list
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildInstructionCard(context, l10n.instruction1, Icons.looks_one),
                      const SizedBox(height: 12),
                      _buildInstructionCard(context, l10n.instruction2, Icons.looks_two),
                      const SizedBox(height: 12),
                      _buildInstructionCard(context, l10n.instruction3, Icons.looks_3),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Action buttons
                CustomButton(
                  text: l10n.startQuestionnaire,
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
                  text: l10n.backToHome,
                  buttonType: ButtonType.text,
                  width: double.infinity,
                  onPressed: () => context.go(RouteConstants.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard(BuildContext context, String text, IconData iconData) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                iconData,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
