import 'package:flutter/material.dart';

import 'package:asd/features/questionnaire/domain/entities/question.dart';

import '../../../common/widgets/custom_button.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.selectedAnswer,
  });

  final Question question;
  final int? selectedAnswer;
  final ValueChanged<int> onAnswerSelected;

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
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedAnswer != widget.selectedAnswer) {
      _selectedAnswer = widget.selectedAnswer;
    }
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
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (widget.question.description != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.question.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: widget.question.options.length,
            itemBuilder: (context, index) {
              final option = widget.question.options[index];
              final isSelected = _selectedAnswer == index;
              
              // Calculate points for Q-CHAT questions
              String pointsText = '';
              if (widget.question.scoringType == 'qchat') {
                pointsText = ' (${index} คะแนน)';
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CustomButton(
                  text: '$option$pointsText',
                  width: double.infinity,
                  buttonType: isSelected
                      ? ButtonType.elevated
                      : ButtonType.outlined,
                  onPressed: () {
                    setState(() {
                      _selectedAnswer = index;
                    });
                    widget.onAnswerSelected(index);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
