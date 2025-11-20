import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../authentication/presentation/providers/auth_provider.dart';
import '../../questionnaire/presentation/providers/assessment_history_provider.dart';
import '../widgets/feature_card.dart';
import '../widgets/recent_assessment_item.dart';
import '../widgets/welcome_banner.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.user?.name ?? 'ผู้ใช้งาน';
    final assessmentHistoryAsync = ref.watch(assessmentHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Banner
                WelcomeBanner(
                  userName: userName,
                  onProfileTap: () {
                    context.push(RouteConstants.profile);
                  },
                ),

                const SizedBox(height: 24),

                // Section Title - Features
                Text('เครื่องมือคัดกรอง', style: AppTextStyles.headline3),

                const SizedBox(height: 16),

                // Feature Cards
                FeatureCard(
                  title: 'แบบประเมิน Q-CHAT-10',
                  description:
                      'แบบสอบถามคัดกรองภาวะออทิสติกในเด็กอายุ 16-30 เดือน',
                  icon: Icons.quiz,
                  iconColor: AppColors.primary,
                  onTap: () {
                    context.push(RouteConstants.questionnaireIntro);
                  },
                  badge: 'ใช้เวลา 10 นาที',
                ),

                const SizedBox(height: 16),

                FeatureCard(
                  title: 'วิเคราะห์วิดีโอ',
                  description:
                      'บันทึกและวิเคราะห์พฤติกรรมของเด็กผ่านการดูวิดีโอกระตุ้น',
                  icon: Icons.videocam,
                  iconColor: AppColors.secondary,
                  onTap: () {
                    context.push(RouteConstants.videoAnalysisIntro);
                  },
                  badge: 'ใช้เวลา 15 นาที',
                ),

                const SizedBox(height: 32),

                // Section Title - Recent Assessments
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('การประเมินล่าสุด', style: AppTextStyles.headline3),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to assessment history
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                        );
                      },
                      child: Text(
                        'ดูทั้งหมด',
                        style: AppTextStyles.bodyText2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                assessmentHistoryAsync.when(
                  data: (assessments) {
                    if (assessments.isEmpty) {
                      return _buildEmptyAssessments(context);
                    }
                    return Column(
                      children: assessments.take(3).map((assessment) {
                        final title =
                            assessment.questionnaireTitle ??
                            'แบบประเมิน Q-CHAT-10';
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
                      }).toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => _buildAssessmentsError(context),
                ),

                const SizedBox(height: 32),

                // Quick Actions Section
                Text('การดำเนินการด่วน', style: AppTextStyles.headline3),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.settings,
                        label: 'ตั้งค่า',
                        onTap: () {
                          context.push(RouteConstants.settings);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.help_outline,
                        label: 'ช่วยเหลือ',
                        onTap: () {
                          _showHelpDialog(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.logout,
                        label: 'ออกจากระบบ',
                        color: AppColors.error,
                        onTap: () {
                          _showLogoutDialog(context, ref);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ช่วยเหลือ'),
        content: const Text(
          'แอปพลิเคชันนี้ใช้สำหรับคัดกรองภาวะออทิสติกในเด็กเล็ก\n\n'
          '1. แบบประเมิน Q-CHAT-10: ตอบคำถาม 10 ข้อเกี่ยวกับพฤติกรรมและการสื่อสารของเด็ก\n\n'
          '2. วิเคราะห์วิดีโอ: บันทึกวิดีโอขณะเด็กดูวิดีโอกระตุ้น\n\n'
          'หากต้องการความช่วยเหลือเพิ่มเติม กรุณาติดต่อผู้ดูแลระบบ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go(RouteConstants.login);
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAssessments(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ยังไม่มีผลการประเมิน',
              style: AppTextStyles.bodyText1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'เริ่มทำแบบประเมิน Q-CHAT-10 เพื่อดูผลลัพธ์ล่าสุดของคุณ',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentsError(BuildContext context) {
    return Card(
      color: AppColors.error.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'ไม่สามารถโหลดประวัติการประเมินได้',
                style: AppTextStyles.bodyText2.copyWith(color: AppColors.error),
              ),
            ),
          ],
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

/// Quick action button widget
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primary;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: buttonColor),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: buttonColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
