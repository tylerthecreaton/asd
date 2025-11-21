import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('นโยบายความเป็นส่วนตัว'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            _buildHeaderBanner(),

            const SizedBox(height: 24),

            // Content Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSection(
                    icon: Icons.info_outline,
                    iconColor: AppColors.info,
                    title: 'บทนำ',
                    content: _buildIntroContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.badge_outlined,
                    iconColor: AppColors.primary,
                    title: '1. ข้อมูลที่เราเก็บรวบรวม',
                    content: _buildDataCollectionContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.drive_file_rename_outline,
                    iconColor: AppColors.secondary,
                    title: '2. วัตถุประสงค์การใช้ข้อมูล',
                    content: _buildPurposeContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.security,
                    iconColor: AppColors.success,
                    title: '3. การรักษาความปลอดภัย',
                    content: _buildSecurityContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.share_outlined,
                    iconColor: AppColors.warning,
                    title: '4. การแบ่งปันข้อมูล',
                    content: _buildSharingContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.verified_user_outlined,
                    iconColor: AppColors.info,
                    title: '5. สิทธิของคุณ',
                    content: _buildRightsContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.schedule,
                    iconColor: AppColors.primary,
                    title: '6. การเก็บรักษาข้อมูล',
                    content: _buildRetentionContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.child_care,
                    iconColor: AppColors.secondary,
                    title: '7. การใช้งานของเด็ก',
                    content: _buildChildrenContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.update,
                    iconColor: AppColors.warning,
                    title: '8. การเปลี่ยนแปลงนโยบาย',
                    content: _buildChangesContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.contact_support_outlined,
                    iconColor: AppColors.success,
                    title: '9. ติดต่อเรา',
                    content: _buildContactContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildUpdateInfo(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.privacy_tip,
            size: 64,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 16),
          Text(
            'ความเป็นส่วนตัวของคุณ\nคือสิ่งสำคัญของเรา',
            textAlign: TextAlign.center,
            style: AppTextStyles.headline2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'เราปกป้องข้อมูลของคุณด้วยมาตรฐานสากล',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText1.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.headline3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Section Content
            Padding(padding: const EdgeInsets.all(16), child: content),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroContent() {
    return _buildParagraph(
      'แอปพลิเคชันคัดกรองภาวะออทิสติกในเด็กเล็ก (ต่อไปนี้เรียกว่า "แอป") '
      'ให้ความสำคัญกับความเป็นส่วนตัวของผู้ใช้งาน เรามุ่งมั่นที่จะปกป้อง'
      'ข้อมูลส่วนบุคคลของคุณและเด็กของคุณตามมาตรฐานสากลและกฎหมายคุ้มครอง'
      'ข้อมูลส่วนบุคคล นโยบายความเป็นส่วนตัวฉบับนี้จะอธิบายถึงวิธีการที่เรา'
      'เก็บรวบรวม ใช้ และปกป้องข้อมูลของคุณ',
    );
  }

  Widget _buildDataCollectionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('1.1 ข้อมูลส่วนบุคคล'),
        _buildBulletPoint('ชื่อ-นามสกุล ของผู้ปกครองและเด็ก'),
        _buildBulletPoint('อีเมล'),
        _buildBulletPoint('เบอร์โทรศัพท์'),
        _buildBulletPoint('ข้อมูลวันเกิดของเด็ก'),
        const SizedBox(height: 16),
        _buildSubsectionTitle('1.2 ข้อมูลการประเมิน'),
        _buildBulletPoint('คำตอบจากแบบประเมิน Q-CHAT'),
        _buildBulletPoint('วิดีโอที่บันทึกเพื่อการวิเคราะห์'),
        _buildBulletPoint('ผลลัพธ์การประเมินและคะแนนความเสี่ยง'),
        _buildBulletPoint('ประวัติการคัดกรองทั้งหมด'),
        const SizedBox(height: 16),
        _buildSubsectionTitle('1.3 ข้อมูลการใช้งาน'),
        _buildBulletPoint('เวลาและวันที่การใช้งาน'),
        _buildBulletPoint('ฟีเจอร์ที่ใช้งาน'),
        _buildBulletPoint('ข้อมูลอุปกรณ์และระบบปฏิบัติการ'),
      ],
    );
  }

  Widget _buildPurposeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph('เราใช้ข้อมูลของคุณเพื่อ:'),
        const SizedBox(height: 8),
        _buildBulletPoint('ให้บริการคัดกรองและประเมินภาวะออทิสติก'),
        _buildBulletPoint('บันทึกและติดตามประวัติการประเมิน'),
        _buildBulletPoint('วิเคราะห์วิดีโอและให้ผลลัพธ์การประเมิน'),
        _buildBulletPoint('ปรับปรุงและพัฒนาแอปพลิเคชัน'),
        _buildBulletPoint('ส่งการแจ้งเตือนและอัปเดตที่สำคัญ'),
        _buildBulletPoint(
          'วิจัยและพัฒนาเครื่องมือคัดกรอง (เฉพาะข้อมูลที่ไม่สามารถระบุตัวตน)',
        ),
      ],
    );
  }

  Widget _buildSecurityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'เราใช้มาตรการรักษาความปลอดภัยที่เหมาะสมเพื่อปกป้องข้อมูลของคุณ:',
        ),
        const SizedBox(height: 8),
        _buildBulletPoint('เข้ารหัสข้อมูลทั้งในการส่งและการจัดเก็บ (SSL/TLS)'),
        _buildBulletPoint('เก็บข้อมูลบนเซิร์ฟเวอร์ที่มีความปลอดภัยสูง'),
        _buildBulletPoint('จำกัดการเข้าถึงข้อมูลเฉพาะบุคลากรที่ได้รับอนุญาต'),
        _buildBulletPoint('สำรองข้อมูลอย่างสม่ำเสมอ'),
        _buildBulletPoint('ลบข้อมูลอัตโนมัติตามระยะเวลาที่กำหนด'),
      ],
    );
  }

  Widget _buildSharingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'เราจะไม่แบ่งปันข้อมูลส่วนบุคคลของคุณกับบุคคลที่สาม ยกเว้น:',
        ),
        const SizedBox(height: 8),
        _buildBulletPoint('เมื่อได้รับความยินยอมจากคุณอย่างชัดเจน'),
        _buildBulletPoint('เมื่อกฎหมายกำหนดให้ต้องเปิดเผย'),
        _buildBulletPoint(
          'เพื่อวัตถุประสงค์ทางการแพทย์หรือการวิจัย (เฉพาะข้อมูลที่ไม่สามารถระบุตัวตน)',
        ),
        _buildBulletPoint(
          'ให้กับผู้ให้บริการที่จำเป็นต่อการทำงานของแอป (เช่น cloud hosting) '
          'ภายใต้สัญญารักษาความลับ',
        ),
      ],
    );
  }

  Widget _buildRightsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph('คุณมีสิทธิ์ในการ:'),
        const SizedBox(height: 8),
        _buildBulletPoint('เข้าถึงและขอสำเนาข้อมูลส่วนบุคคลของคุณ'),
        _buildBulletPoint('แก้ไขข้อมูลที่ไม่ถูกต้อง'),
        _buildBulletPoint('ลบข้อมูลของคุณ (Right to be Forgotten)'),
        _buildBulletPoint('ถอนความยินยอมการใช้ข้อมูล'),
        _buildBulletPoint('ขอให้หยุดการประมวลผลข้อมูลบางประเภท'),
        _buildBulletPoint('โอนย้ายข้อมูลของคุณ'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.info, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'หากต้องการใช้สิทธิดังกล่าว กรุณาติดต่อเราตามช่องทางที่ระบุไว้ด้านล่าง',
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRetentionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph('เราจะเก็บรักษาข้อมูลของคุณตามระยะเวลาที่จำเป็น:'),
        const SizedBox(height: 8),
        _buildHighlightBullet(
          icon: Icons.person_outline,
          title: 'ข้อมูลส่วนบุคคล',
          description:
              'ตลอดระยะเวลาที่คุณใช้งานแอป และอีก 2 ปีหลังจากยุติการใช้งาน',
        ),
        _buildHighlightBullet(
          icon: Icons.assessment_outlined,
          title: 'ประวัติการประเมิน',
          description: '3 ปี หรือจนกว่าคุณจะขอให้ลบ',
        ),
        _buildHighlightBullet(
          icon: Icons.videocam_outlined,
          title: 'วิดีโอที่บันทึก',
          description:
              '30 วัน หรือจนกว่าคุณจะขอให้ลบ (ลบโดยอัตโนมัติหลัง 30 วัน)',
        ),
        _buildHighlightBullet(
          icon: Icons.science_outlined,
          title: 'ข้อมูลการวิจัย',
          description:
              'ข้อมูลที่ไม่สามารถระบุตัวตนสำหรับการวิจัย: ไม่จำกัดระยะเวลา',
        ),
      ],
    );
  }

  Widget _buildChildrenContent() {
    return _buildParagraph(
      'แอปนี้ออกแบบมาสำหรับผู้ปกครองในการคัดกรองภาวะออทิสติกในเด็ก '
      'ผู้ปกครองต้องเป็นผู้ให้ความยินยอมในการเก็บรวบรวมข้อมูลของเด็ก '
      'และมีหน้าที่รับผิดชอบในการจัดการข้อมูลดังกล่าว',
    );
  }

  Widget _buildChangesContent() {
    return _buildParagraph(
      'เราอาจปรับปรุงนโยบายความเป็นส่วนตัวนี้เป็นครั้งคราว '
      'การเปลี่ยนแปลงที่สำคัญจะแจ้งให้คุณทราบผ่านแอปหรืออีเมล '
      'ก่อนมีผลบังคับใช้อย่างน้อย 30 วัน',
    );
  }

  Widget _buildContactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'หากคุณมีคำถามหรือข้อสงสัยเกี่ยวกับนโยบายความเป็นส่วนตัวนี้ '
          'หรือต้องการใช้สิทธิของคุณ กรุณาติดต่อเราได้ที่:',
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          icon: Icons.email_outlined,
          color: AppColors.primary,
          title: 'อีเมล',
          value: 'support@asdscreening.com',
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          icon: Icons.phone_outlined,
          color: AppColors.secondary,
          title: 'โทรศัพท์',
          value: '02-XXX-XXXX',
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          icon: Icons.location_on_outlined,
          color: AppColors.info,
          title: 'ที่อยู่',
          value: 'ทีมพัฒนาแอปคัดกรองภาวะออทิสติก\nกรุงเทพมหานคร ประเทศไทย',
        ),
      ],
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: AppTextStyles.bodyText1.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyText1.copyWith(
        height: 1.7,
        color: AppColors.textPrimary,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyText1.copyWith(
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightBullet({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyText1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.info.withValues(alpha: 0.15),
            AppColors.info.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.calendar_today, color: AppColors.info, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'อัปเดตล่าสุด',
                  style: AppTextStyles.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'นโยบายฉบับนี้มีผลบังคับใช้ตั้งแต่\n21 พฤศจิกายน 2568',
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
