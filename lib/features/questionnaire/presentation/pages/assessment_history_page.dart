import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../common/widgets/recent_assessment_item.dart';
import '../providers/assessment_history_provider.dart';

class AssessmentHistoryPage extends ConsumerWidget {
  const AssessmentHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessmentHistoryAsync = ref.watch(assessmentHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('ประวัติการประเมิน', style: AppTextStyles.headline3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: assessmentHistoryAsync.when(
        data: (assessments) {
          if (assessments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ยังไม่มีประวัติการประเมิน',
                    style: AppTextStyles.bodyText1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: assessments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final assessment = assessments[index];
              final title =
                  assessment.questionnaireTitle ?? 'แบบประเมิน Q-CHAT-10';

              return RecentAssessmentItem(
                title: title,
                date: _formatDate(assessment.completedAt),
                status: assessment.riskLevel.name,
                icon: Icons.quiz,
                onTap: () {
                  context.push(
                    RouteConstants.questionnaireResults,
                    extra: assessment,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'เกิดข้อผิดพลาดในการโหลดข้อมูล',
            style: AppTextStyles.bodyText1.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year + 543}';
  }
}
