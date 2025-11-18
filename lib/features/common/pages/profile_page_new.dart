import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../authentication/presentation/providers/providers.dart';
import '../presentation/providers/providers.dart';
import '../presentation/widgets/profile_header.dart';
import '../presentation/widgets/stats_card.dart';
import '../domain/entities/profile_data.dart';

class ProfilePageNew extends ConsumerStatefulWidget {
  const ProfilePageNew({super.key});

  @override
  ConsumerState<ProfilePageNew> createState() => _ProfilePageNewState();
}

class _ProfilePageNewState extends ConsumerState<ProfilePageNew> {
  @override
  void initState() {
    super.initState();
    // Load profile data when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileData = profileState.data;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
              context.push(RouteConstants.settings);
            },
          ),
        ],
      ),
      body: profileState.status == ProfileStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : profileState.status == ProfileStatus.error
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profileState.errorMessage ?? 'เกิดข้อผิดพลาด',
                        style: AppTextStyles.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(profileProvider.notifier).refreshProfile();
                        },
                        child: const Text('ลองใหม่'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(profileProvider.notifier).refreshProfile();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header
                        const ProfileHeader(),
                        
                        const SizedBox(height: 24),
                        
                        // Statistics Section
                        _buildStatisticsSection(profileData),
                        
                        const SizedBox(height: 24),
                        
                        // Quick Actions Section
                        _buildQuickActionsSection(),
                        
                        const SizedBox(height: 24),
                        
                        // Recent Assessments Section
                        _buildRecentAssessmentsSection(profileData),
                        
                        const SizedBox(height: 24),
                        
                        // Settings Section
                        _buildSettingsSection(),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatisticsSection(ProfileData? profileData) {
    if (profileData == null) return const SizedBox.shrink();
    
    final statistics = profileData.statistics;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'ภาพรวมการใช้งาน',
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              StatsCard(
                icon: Icons.assessment,
                value: statistics.totalAssessments.toString(),
                label: 'การประเมินทั้งหมด',
                color: AppColors.primary,
                onTap: () {
                  // Navigate to assessment history page (placeholder for now)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ฟีเจอร์ประวัติการประเมินทั้งหมดจะมาในเร็วๆ นี้')),
                  );
                },
              ),
              const SizedBox(width: 16),
              StatsCard(
                icon: Icons.quiz,
                value: statistics.questionnaireCount.toString(),
                label: 'แบบประเมิน M-CHAT',
                color: AppColors.secondary,
                onTap: () {
                  // Navigate to M-CHAT history page (placeholder for now)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ฟีเจอร์ประวัติการประเมิน M-CHAT จะมาในเร็วๆ นี้')),
                  );
                },
              ),
              const SizedBox(width: 16),
              StatsCard(
                icon: Icons.videocam,
                value: statistics.videoAnalysisCount.toString(),
                label: 'การวิเคราะห์วิดีโอ',
                color: AppColors.info,
                onTap: () {
                  // Navigate to video analysis history page (placeholder for now)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ฟีเจอร์ประวัติการวิเคราะห์วิดีโอจะมาในเร็วๆ นี้')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'การกระทำด่วน',
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildQuickActionCard(
                icon: Icons.quiz,
                title: 'ทำแบบประเมิน',
                subtitle: 'M-CHAT',
                color: AppColors.primary,
                onTap: () {
                  // Navigate to questionnaire intro page
                  context.push(RouteConstants.questionnaireIntro);
                },
              ),
              const SizedBox(width: 16),
              _buildQuickActionCard(
                icon: Icons.videocam,
                title: 'วิเคราะห์วิดีโอ',
                subtitle: 'บันทึกวิดีโอ',
                color: AppColors.secondary,
                onTap: () {
                  // Navigate to video analysis intro page
                  context.push(RouteConstants.videoAnalysisIntro);
                },
              ),
              const SizedBox(width: 16),
              _buildQuickActionCard(
                icon: Icons.person_add,
                title: 'เพิ่มโปรไฟล์เด็ก',
                subtitle: 'จัดการข้อมูล',
                color: AppColors.success,
                onTap: () {
                  // Navigate to add child profile page (placeholder for now)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ฟีเจอร์เพิ่มโปรไฟล์เด็กจะมาในเร็วๆ นี้')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyText1.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodyText2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAssessmentsSection(ProfileData? profileData) {
    if (profileData?.recentAssessments.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'การประเมินล่าสุด',
                style: AppTextStyles.headline3.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full assessment history page (placeholder for now)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ฟีเจอร์ประวัติการประเมินทั้งหมดจะมาในเร็วๆ นี้')),
                  );
                },
                child: const Text('ดูทั้งหมด'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...profileData?.recentAssessments.map((assessment) {
          return _buildAssessmentCard(assessment);
        }) ?? [],
      ],
    );
  }

  Widget _buildAssessmentCard(AssessmentSummary assessment) {
    Color riskColor;
    String riskText;
    
    switch (assessment.riskLevel) {
      case RiskLevel.low:
        riskColor = AppColors.lowRisk;
        riskText = 'ความเสี่ยงต่ำ';
        break;
      case RiskLevel.medium:
        riskColor = AppColors.mediumRisk;
        riskText = 'ความเสี่ยงกลาง';
        break;
      case RiskLevel.high:
        riskColor = AppColors.highRisk;
        riskText = 'ความเสี่ยงสูง';
        break;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                assessment.type == AssessmentType.questionnaire
                    ? Icons.quiz
                    : Icons.videocam,
                color: riskColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assessment.childName ?? 'ไม่ระบุชื่อ',
                    style: AppTextStyles.bodyText1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        assessment.type == AssessmentType.questionnaire
                            ? 'M-CHAT'
                            : 'วิดีโอ',
                        style: AppTextStyles.bodyText2,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: riskColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          riskText,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${assessment.completedAt.day}/${assessment.completedAt.month}/${assessment.completedAt.year}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'การตั้งค่า',
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                icon: Icons.person_outline,
                title: 'แก้ไขโปรไฟล์',
                onTap: () {
                  // Navigate to edit profile page
                  context.push(RouteConstants.editProfile);
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.lock_outline,
                title: 'เปลี่ยนรหัสผ่าน',
                onTap: () {
                  // Navigate to change password page (placeholder for now)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ฟีเจอร์เปลี่ยนรหัสผ่านจะมาในเร็วๆ นี้')),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.notifications_outlined,
                title: 'การแจ้งเตือน',
                onTap: () {
                  // Navigate to notification settings page
                  context.push(RouteConstants.settings);
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.language,
                title: 'ภาษา',
                subtitle: 'ไทย',
                onTap: () {
                  // Navigate to language settings page
                  context.push(RouteConstants.settings);
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.privacy_tip_outlined,
                title: 'นโยบายความเป็นส่วนตัว',
                onTap: () {
                  // Navigate to privacy policy page (placeholder for now)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ฟีเจอร์นโยบายความเป็นส่วนตัวจะมาในเร็วๆ นี้')),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.info_outline,
                title: 'เกี่ยวกับแอป',
                subtitle: 'เวอร์ชัน 1.0.0',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.logout,
                title: 'ออกจากระบบ',
                isDestructive: true,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyText1.copyWith(
          color: isDestructive ? AppColors.error : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.bodyText2,
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เกี่ยวกับแอป'),
        content: const Text(
          'แอปคัดกรองภาวะออทิสติกในเด็กเล็ก\n\n'
          'เวอร์ชัน: 1.0.0\n\n'
          'พัฒนาโดย: ASD Screening Team\n\n'
          'แอปพลิเคชันนี้ใช้สำหรับคัดกรองเบื้องต้นภาวะออทิสติกในเด็กเล็ก '
          'โดยใช้แบบประเมิน M-CHAT และการวิเคราะห์วิดีโอ',
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

  void _showLogoutDialog(BuildContext context) {
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
              // Navigate to login page will be handled by auth state change
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }
}