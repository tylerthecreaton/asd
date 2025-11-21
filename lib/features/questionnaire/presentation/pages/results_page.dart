import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import 'package:asd/core/constants/route_constants.dart';
import 'package:asd/core/services/pdf_service.dart';
import 'package:asd/features/questionnaire/domain/entities/assessment_result.dart';

import '../../../common/widgets/custom_button.dart';
import '../providers/questionnaire_provider.dart';
import '../widgets/results_summary.dart';

class QuestionnaireResultsPage extends ConsumerWidget {
  const QuestionnaireResultsPage({
    super.key,
    this.initialResult,
    this.fromCombinedScreening = false,
  });

  final AssessmentResult? initialResult;
  final bool fromCombinedScreening;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerResult = ref.watch(questionnaireResultsProvider);
    final resolvedResult = initialResult ?? providerResult.value;
    final resultAsync = initialResult != null
        ? AsyncValue.data(initialResult!)
        : providerResult;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(context, resolvedResult),
          ),
        ],
      ),
      body: resultAsync.when(
        data: (result) {
          if (result == null) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, result),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResultsSummary(result: result),
                      const SizedBox(height: 32),
                      _buildDisclaimer(context),
                      const SizedBox(height: 32),
                      _buildActionButtons(context, ref, result),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading results: $error')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No assessment results available yet.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Complete the questionnaire to view your child\'s assessment summary.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Start Questionnaire',
              onPressed: () => context.go(RouteConstants.questionnaireIntro),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AssessmentResult result) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assessment_rounded,
            size: 64,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 16),
          Text(
            'Assessment Complete',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Here is the summary of the evaluation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Important Disclaimer',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This screening tool is designed for preliminary assessment only and '
            'is not a substitute for professional medical diagnosis. '
            'Please consult with a qualified healthcare professional for a '
            'comprehensive evaluation and diagnosis.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    AssessmentResult result,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Show video analysis button if coming from combined screening
            if (fromCombinedScreening) ...[
              CustomButton(
                text: 'ดำเนินการคัดกรองวิดีโอต่อ',
                icon: const Icon(Icons.videocam),
                onPressed: () =>
                    context.push(RouteConstants.videoAnalysisIntro),
              ),
              const SizedBox(height: 16),
            ],
            CustomButton(
              text: 'Download PDF Report',
              icon: const Icon(Icons.download),
              onPressed: () => _downloadPdf(context, result),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'View Recommendations',
              buttonType: ButtonType.outlined,
              onPressed: () => _viewRecommendations(context, result),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Return to Home',
              buttonType: ButtonType.text,
              onPressed: () => context.go(RouteConstants.home),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPdf(
    BuildContext context,
    AssessmentResult result,
  ) async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) async {
          final pdf = await PdfService.generateQuestionnaireReport(result);
          return pdf.save();
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
      }
    }
  }

  Future<void> _shareResults(
    BuildContext context,
    AssessmentResult? result,
  ) async {
    if (result == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No results available to share.')),
        );
      }
      return;
    }

    try {
      final pdf = await PdfService.generateQuestionnaireReport(result);
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'asd_screening_results.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing PDF: $e')));
      }
    }
  }

  void _viewRecommendations(BuildContext context, AssessmentResult result) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detailed Recommendations',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...result.recommendations.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          // Check if value is a list (nextSteps)
                          if (entry.value is List)
                            ...(entry.value as List).map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  top: 4.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item.toString(),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Text(
                              entry.value.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
