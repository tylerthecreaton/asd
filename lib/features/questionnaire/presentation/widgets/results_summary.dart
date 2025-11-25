import 'package:flutter/material.dart';

import 'package:asd/features/questionnaire/domain/entities/assessment_result.dart';

class ResultsSummary extends StatelessWidget {
  const ResultsSummary({super.key, required this.result});

  final AssessmentResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RiskCard(result: result),
        const SizedBox(height: 16),
        _ScoreCard(result: result),
        const SizedBox(height: 16),
        if (result.flaggedBehaviors.isNotEmpty)
          _FlaggedBehaviorsCard(result: result),
        if (result.flaggedBehaviors.isNotEmpty) const SizedBox(height: 16),
        _RecommendationsCard(result: result),
      ],
    );
  }
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.result});

  final AssessmentResult result;

  Color _riskColor(BuildContext context) {
    switch (result.riskLevel) {
      case RiskLevel.low:
        return Colors.green.shade400;
      case RiskLevel.medium:
        return Colors.orange.shade400;
      case RiskLevel.high:
        return Colors.red.shade400;
    }
  }

  String _riskLabel() {
    switch (result.riskLevel) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(context);
    return Card(
      color: color.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: const Icon(Icons.favorite, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Assessment',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _riskLabel(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Completed on ${_formatDate(result.completedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.result});

  final AssessmentResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Calculate max possible score (totalQuestions * 1 for binary Q-CHAT)
    final maxScore = result.totalQuestions;
    final percentage = ((result.score / maxScore) * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Score', style: theme.textTheme.titleSmall),
                  Text(
                    '${result.score}/$maxScore',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Risk thresholds: Low (0-3), Medium (4-6), High (7-10)',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _ScoreBadge(
                  label: 'Score',
                  value: result.score,
                  color: _getScoreColor(result.score),
                ),
                const SizedBox(height: 8),
                _ScoreBadge(
                  label: 'Percentage',
                  value: percentage,
                  color: Colors.blue,
                  suffix: '%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 3) return Colors.green;
    if (score <= 6) return Colors.orange;
    return Colors.red;
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({
    required this.label,
    required this.value,
    required this.color,
    this.suffix = '',
  });

  final String label;
  final int value;
  final Color color;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$value$suffix',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _FlaggedBehaviorsCard extends StatelessWidget {
  const _FlaggedBehaviorsCard({required this.result});

  final AssessmentResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flagged Behaviors',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...result.flaggedBehaviors.map(
              (behavior) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        behavior,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard({required this.result});

  final AssessmentResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...result.recommendations.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Check if value is a list (nextSteps)
                    if (entry.value is List)
                      ...(entry.value as List).map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 16)),
                              Expanded(
                                child: Text(
                                  item.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
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
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
