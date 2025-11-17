import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryVariant],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'ผู้ใช้งาน',
                    style: AppTextStyles.headline2.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? 'user@example.com',
                    style: AppTextStyles.bodyText1.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Profile Options
            _buildSection(
              title: 'ข้อมูลส่วนตัว',
              items: [
                _ProfileItem(
                  icon: Icons.person_outline,
                  title: 'แก้ไขโปรไฟล์',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
                _ProfileItem(
                  icon: Icons.lock_outline,
                  title: 'เปลี่ยนรหัสผ่าน',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
              ],
            ),

            _buildSection(
              title: 'ประวัติการประเมิน',
              items: [
                _ProfileItem(
                  icon: Icons.history,
                  title: 'ประวัติการประเมินทั้งหมด',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
                _ProfileItem(
                  icon: Icons.download,
                  title: 'ดาวน์โหลดรายงาน',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
              ],
            ),

            _buildSection(
              title: 'การตั้งค่า',
              items: [
                _ProfileItem(
                  icon: Icons.settings_outlined,
                  title: 'การตั้งค่าทั่วไป',
                  onTap: () {
                    context.push(RouteConstants.settings);
                  },
                ),
                _ProfileItem(
                  icon: Icons.notifications_outlined,
                  title: 'การแจ้งเตือน',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
                _ProfileItem(
                  icon: Icons.language,
                  title: 'ภาษา',
                  subtitle: 'ไทย',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
              ],
            ),

            _buildSection(
              title: 'เกี่ยวกับ',
              items: [
                _ProfileItem(
                  icon: Icons.info_outline,
                  title: 'เกี่ยวกับแอป',
                  subtitle: 'เวอร์ชัน 1.0.0',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                _ProfileItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'นโยบายความเป็นส่วนตัว',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
                _ProfileItem(
                  icon: Icons.description_outlined,
                  title: 'เงื่อนไขการใช้งาน',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context, ref);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('ออกจากระบบ'),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            title,
            style: AppTextStyles.bodyText2.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เกี่ยวกับแอป'),
        content: const Text(
          'แอปคัดกรองภาวะออทิสติกในเด็ก\n\n'
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
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyText1),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
