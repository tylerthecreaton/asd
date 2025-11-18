import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../authentication/presentation/providers/auth_provider.dart';
import '../widgets/feature_card.dart';
import '../widgets/recent_assessment_item.dart';
import '../widgets/welcome_banner.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.user?.name ?? 'ผู้ใช้งาน';

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
                Text(
                  'เครื่องมือคัดกรอง',
                  style: AppTextStyles.headline3,
                ),

                const SizedBox(height: 16),

                // Feature Cards
                FeatureCard(
                  title: 'แบบประเมิน M-CHAT',
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
                    Text(
                      'การประเมินล่าสุด',
                      style: AppTextStyles.headline3,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to assessment history
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ฟีเจอร์กำลังพัฒนา'),
                          ),
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

                // Recent Assessments List (Mock Data)
                RecentAssessmentItem(
                  title: 'แบบประเมิน M-CHAT',
                  date: '15 พ.ย. 2568',
                  status: 'completed',
                  icon: Icons.quiz,
                  onTap: () {
                    // TODO: Navigate to assessment detail
                    context.push(RouteConstants.questionnaireResults);
                  },
                ),

                RecentAssessmentItem(
                  title: 'วิเคราะห์วิดีโอ',
                  date: '12 พ.ย. 2568',
                  status: 'completed',
                  icon: Icons.videocam,
                  onTap: () {
                    // TODO: Navigate to video analysis result
                    context.push(RouteConstants.videoAnalysisResults);
                  },
                ),

                RecentAssessmentItem(
                  title: 'แบบประเมิน M-CHAT',
                  date: '8 พ.ย. 2568',
                  status: 'completed',
                  icon: Icons.quiz,
                  onTap: () {
                    context.push(RouteConstants.questionnaireResults);
                  },
                ),

                const SizedBox(height: 32),

                // Quick Actions Section
                Text(
                  'การดำเนินการด่วน',
                  style: AppTextStyles.headline3,
                ),

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
          '1. แบบประเมิน M-CHAT: ตอบคำถาม 23 ข้อเกี่ยวกับพฤติกรรมของเด็ก\n\n'
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
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: buttonColor,
              ),
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
