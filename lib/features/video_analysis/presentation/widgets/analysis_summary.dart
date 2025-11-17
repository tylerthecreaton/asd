import 'package:flutter/material.dart';

import '../../domain/entities/stimulus_video.dart';
import '../../domain/entities/video_analysis_result.dart';

class AnalysisSummary extends StatelessWidget {
  const AnalysisSummary({super.key, required this.result, this.stimulusVideo});

  final VideoAnalysisResult result;
  final StimulusVideo? stimulusVideo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RiskBadge(result: result),
        const SizedBox(height: 16),
        if (stimulusVideo != null) ...[
          Text(stimulusVideo!.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(stimulusVideo!.description, style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
        ],
        _ScoreCard(
          label: 'Overall Score',
          score: result.overallScore,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ScoreCard(
                label: 'Engagement',
                score: result.engagementScore,
                color: Colors.orange,
                dense: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ScoreCard(
                label: 'Responsiveness',
                score: result.responsivenessScore,
                color: Colors.green,
                dense: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ScoreCard(
                label: 'Sensory',
                score: result.sensoryScore,
                color: Colors.purple,
                dense: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Detected Behaviors', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: result.detectedBehaviors
              .map(
                (behavior) => Chip(
                  label: Text(behavior.replaceAll('_', ' ')),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Text('Recommendations', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        ...result.recommendations.map(
          (recommendation) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Summary', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(result.summary, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.result});

  final VideoAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(result.riskLevel);
    final text = result.riskLevel.name.toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: const Icon(Icons.shield, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Risk Level', style: Theme.of(context).textTheme.bodySmall),
              Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Generated ${_formatTimestamp(result.analyzedAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _riskColor(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return Colors.green;
      case RiskLevel.moderate:
        return Colors.orange;
      case RiskLevel.high:
        return Colors.red;
    }
  }

  static String _formatTimestamp(DateTime dateTime) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} $hours:$minutes';
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.score,
    required this.color,
    this.dense = false,
  });

  final String label;
  final double score;
  final Color color;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(dense ? 12 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            '${(score * 100).toStringAsFixed(0)}%',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: score.clamp(0, 1),
              minHeight: dense ? 6 : 10,
              color: color,
              backgroundColor: color.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
