import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/constants/route_constants.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoSaveEnabled = true;
  String _selectedLanguage = 'th';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('การตั้งค่า'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // General Settings
            _buildSection(
              title: 'การตั้งค่าทั่วไป',
              items: [
                _SwitchTile(
                  icon: Icons.save_outlined,
                  title: 'บันทึกอัตโนมัติ',
                  subtitle: 'บันทึกข้อมูลอัตโนมัติขณะทำแบบประเมิน',
                  value: _autoSaveEnabled,
                  onChanged: (value) {
                    setState(() => _autoSaveEnabled = value);
                  },
                ),
                _SettingsTile(
                  icon: Icons.language,
                  title: 'ภาษา',
                  subtitle: _selectedLanguage == 'th' ? 'ไทย' : 'English',
                  onTap: () {
                    _showLanguageDialog();
                  },
                ),
              ],
            ),

            // Notification Settings
            _buildSection(
              title: 'การแจ้งเตือน',
              items: [
                _SwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'เปิดการแจ้งเตือน',
                  subtitle: 'รับการแจ้งเตือนจากแอปพลิเคชัน',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
                _SwitchTile(
                  icon: Icons.volume_up_outlined,
                  title: 'เสียงแจ้งเตือน',
                  subtitle: 'เปิดเสียงเมื่อมีการแจ้งเตือน',
                  value: _soundEnabled,
                  onChanged: _notificationsEnabled
                      ? (value) {
                          setState(() => _soundEnabled = value);
                        }
                      : null,
                ),
                _SwitchTile(
                  icon: Icons.vibration,
                  title: 'การสั่น',
                  subtitle: 'เปิดการสั่นเมื่อมีการแจ้งเตือน',
                  value: _vibrationEnabled,
                  onChanged: _notificationsEnabled
                      ? (value) {
                          setState(() => _vibrationEnabled = value);
                        }
                      : null,
                ),
              ],
            ),

            // Video Settings
            _buildSection(
              title: 'การตั้งค่าวิดีโอ',
              items: [
                _SettingsTile(
                  icon: Icons.video_settings,
                  title: 'คุณภาพวิดีโอ',
                  subtitle: 'HD (720p)',
                  onTap: () {
                    _showVideoQualityDialog();
                  },
                ),
                _SettingsTile(
                  icon: Icons.folder_outlined,
                  title: 'ตำแหน่งบันทึกวิดีโอ',
                  subtitle: 'ที่เก็บข้อมูลภายใน',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
              ],
            ),

            // Privacy Settings
            _buildSection(
              title: 'ความเป็นส่วนตัว',
              items: [
                _SettingsTile(
                  icon: Icons.lock_outline,
                  title: 'ความเป็นส่วนตัว',
                  subtitle: 'จัดการข้อมูลส่วนตัวของคุณ',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
                _SettingsTile(
                  icon: Icons.delete_outline,
                  title: 'ล้างข้อมูลแคช',
                  subtitle: 'ลบข้อมูลชั่วคราวทั้งหมด',
                  onTap: () {
                    _showClearCacheDialog();
                  },
                ),
              ],
            ),

            // About
            _buildSection(
              title: 'เกี่ยวกับ',
              items: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'เวอร์ชัน',
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'เงื่อนไขการใช้งาน',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์กำลังพัฒนา')),
                    );
                  },
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'นโยบายความเป็นส่วนตัว',
                  onTap: () {
                    context.push(RouteConstants.privacyPolicy);
                  },
                ),
              ],
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เลือกภาษา'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('ไทย'),
              value: 'th',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }

  void _showVideoQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คุณภาพวิดีโอ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('SD (480p)'),
              subtitle: const Text('คุณภาพต่ำ, ใช้พื้นที่น้อย'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('HD (720p)'),
              subtitle: const Text('คุณภาพปานกลาง (แนะนำ)'),
              trailing: const Icon(Icons.check, color: AppColors.primary),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Full HD (1080p)'),
              subtitle: const Text('คุณภาพสูง, ใช้พื้นที่มาก'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ล้างข้อมูลแคช'),
        content: const Text(
          'คุณต้องการล้างข้อมูลแคชทั้งหมดใช่หรือไม่?\n\n'
          'การดำเนินการนี้จะลบข้อมูลชั่วคราวทั้งหมด',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ล้างข้อมูลแคชเรียบร้อยแล้ว'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('ล้างข้อมูล'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
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

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyText1),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }
}
