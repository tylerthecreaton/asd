import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/constants/route_constants.dart';
// import '../../authentication/presentation/providers/providers.dart';
import '../presentation/providers/providers.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final profileData = ref.read(profileProvider).data;
    final user = profileData?.user;

    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('อัปเดตโปรไฟล์สำเร็จ'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileData = profileState.data;
    final user = profileData?.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('แก้ไขโปรไฟล์'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isUpdating ? null : _saveProfile,
            child: _isUpdating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'บันทึก',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: profileState.status == ProfileStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture Section
                    _buildProfilePictureSection(user),

                    const SizedBox(height: 32),

                    // Name Field
                    Text(
                      'ชื่อ',
                      style: AppTextStyles.bodyText1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'กรอกชื่อของคุณ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกชื่อ';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Email Field
                    Text(
                      'อีเมล',
                      style: AppTextStyles.bodyText1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'กรอกอีเมลของคุณ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        }
                        // Simple email validation
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'กรุณากรอกอีเมลให้ถูกต้อง';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Account Information
                    _buildAccountInfoSection(user),

                    const SizedBox(height: 32),

                    // Danger Zone
                    _buildDangerZone(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfilePictureSection(user) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: const Icon(Icons.person, size: 60, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ฟีเจอร์เปลี่ยนรูปโปรไฟล์จะมาในเร็วๆ นี้'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('เปลี่ยนรูปโปรไฟล์'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection(user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลบัญชี',
              style: AppTextStyles.headline3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('รหัสผู้ใช้', user?.id ?? 'ไม่ระบุ'),
            const SizedBox(height: 12),
            _buildInfoRow(
              'วันที่สร้างบัญชี',
              user?.createdAt != null
                  ? '${user!.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'
                  : 'ไม่ระบุ',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'อัปเดตล่าสุด',
              user?.updatedAt != null
                  ? '${user!.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year}'
                  : 'ไม่ระบุ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTextStyles.bodyText2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Text(': '),
        Expanded(child: Text(value, style: AppTextStyles.bodyText2)),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'โซนอันตราย',
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.lock, color: AppColors.error),
              title: const Text('เปลี่ยนรหัสผ่าน'),
              subtitle: const Text('เปลี่ยนรหัสผ่านของคุณ'),
              onTap: () {
                // Navigate to change password page
                context.push(RouteConstants.changePassword);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: AppColors.error),
              title: const Text('ลบบัญชี'),
              subtitle: const Text('ลบบัญชีและข้อมูลทั้งหมดถาวร'),
              onTap: () {
                _showDeleteAccountDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลบบัญชี'),
        content: const Text(
          'การดำเนินการนี้ไม่สามารถย้อนกลับได้\\n\\n'
          'คุณต้องการลบบัญชีและข้อมูลทั้งหมดหรือไม่?',
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
                  content: Text('ฟีเจอร์ลบบัญชีจะมาในเร็วๆ นี้'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('ลบบัญชี'),
          ),
        ],
      ),
    );
  }
}
