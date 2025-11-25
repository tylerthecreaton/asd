import 'package:flutter/material.dart';

class QuestionnaireProgressIndicator extends StatelessWidget {
  const QuestionnaireProgressIndicator({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  final int currentQuestion;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    // Prevent division by zero and handle edge cases
    final progress = totalQuestions > 0
        ? currentQuestion / totalQuestions
        : 0.0;
    final percentage = (progress * 100).round().clamp(0, 100);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ความคืบหน้า',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress dots
          Row(
            children: List.generate(
              totalQuestions,
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < totalQuestions - 1 ? 4 : 0,
                  ),
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: index < currentQuestion
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Step indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ข้อที่ $currentQuestion จาก $totalQuestions',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                _getProgressText(progress),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getProgressText(double progress) {
    if (progress < 0.25) return 'เริ่มต้นดีเลย!';
    if (progress < 0.5) return 'ทำไปได้สวยงาม';
    if (progress < 0.75) return 'เกือบถึงเป้าหมายแล้ว';
    if (progress < 1.0) return 'เกือบเสร็จแล้ว!';
    return 'สำเร็จแล้ว!';
  }
}
