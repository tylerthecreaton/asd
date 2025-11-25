import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:asd/core/constants/route_constants.dart';
import 'package:asd/l10n/app_localizations.dart';

import '../../../common/widgets/custom_button.dart';
import '../providers/questionnaire_provider.dart';

class QuestionnaireIntroPage extends ConsumerWidget {
  const QuestionnaireIntroPage({super.key, this.fromCombinedScreening = false});

  final bool fromCombinedScreening;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final questionnaireAsync = ref.watch(questionnaireProvider);
    final theme = Theme.of(context);

    return questionnaireAsync.when(
      data: (state) {
        final questionnaire = state.questionnaire;
        return Scaffold(
          appBar: AppBar(
            title: Text(questionnaire?.title ?? l10n.questionnaireIntroTitle),
            backgroundColor: theme.appBarTheme.backgroundColor,
            foregroundColor: theme.appBarTheme.foregroundColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'รีเฟรช',
                onPressed: () => ref
                    .read(questionnaireProvider.notifier)
                    .reloadQuestionnaire(),
              ),
            ],
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
                              questionnaire?.type.contains('qchat') ?? false
                                  ? Icons.quiz_outlined
                                  : Icons.assignment,
                              size: 64,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              questionnaire?.title ??
                                  l10n.questionnaireIntroTitle,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              questionnaire?.description ??
                                  l10n.questionnaireIntroDescription,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (questionnaire?.type.contains('qchat') ??
                                false) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: theme.colorScheme.primary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'ระดับความเสี่ยง: Low (0-3), Medium (4-6), High (7-10)',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'คำแนะนำในการทำแบบสอบถาม',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildInstructionCard(
                            context,
                            l10n.instruction1,
                            Icons.looks_one,
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionCard(
                            context,
                            l10n.instruction2,
                            Icons.looks_two,
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionCard(
                            context,
                            l10n.instruction3,
                            Icons.looks_3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: l10n.startQuestionnaire,
                      width: double.infinity,
                      onPressed: () async {
                        await ref
                            .read(questionnaireProvider.notifier)
                            .resetQuestionnaire();
                        if (context.mounted) {
                          context.go(
                            RouteConstants.questionnaire,
                            extra: fromCombinedScreening
                                ? {'fromCombinedScreening': true}
                                : null,
                          );
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
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'ไม่สามารถโหลดแบบสอบถามได้',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'ลองอีกครั้ง',
                  onPressed: () => ref
                      .read(questionnaireProvider.notifier)
                      .reloadQuestionnaire(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard(
    BuildContext context,
    String text,
    IconData iconData,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              child: Icon(iconData, color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
