import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('เงื่อนไขการใช้งาน'),
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
                    icon: Icons.handshake_outlined,
                    iconColor: AppColors.primary,
                    title: '1. การยอมรับเงื่อนไข',
                    content: _buildAcceptanceContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.app_settings_alt_outlined,
                    iconColor: AppColors.secondary,
                    title: '2. คำอธิบายบริการ',
                    content: _buildServiceDescriptionContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.account_circle_outlined,
                    iconColor: AppColors.info,
                    title: '3. บัญชีผู้ใช้',
                    content: _buildUserAccountContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.rule_outlined,
                    iconColor: AppColors.warning,
                    title: '4. ข้อกำหนดการใช้งาน',
                    content: _buildUsageRulesContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.copyright_outlined,
                    iconColor: AppColors.success,
                    title: '5. ทรัพย์สินทางปัญญา',
                    content: _buildIntellectualPropertyContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.warning_amber_outlined,
                    iconColor: AppColors.error,
                    title: '6. การจำกัดความรับผิด',
                    content: _buildLiabilityContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.medical_information_outlined,
                    iconColor: AppColors.info,
                    title: '7. ข้อจำกัดทางการแพทย์',
                    content: _buildMedicalDisclaimerContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.block_outlined,
                    iconColor: AppColors.error,
                    title: '8. การยกเลิกบัญชี',
                    content: _buildTerminationContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.edit_note_outlined,
                    iconColor: AppColors.warning,
                    title: '9. การเปลี่ยนแปลงเงื่อนไข',
                    content: _buildChangesContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.gavel_outlined,
                    iconColor: AppColors.primary,
                    title: '10. กฎหมายที่ใช้บังคับ',
                    content: _buildGoverningLawContent(),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.contact_support_outlined,
                    iconColor: AppColors.success,
                    title: '11. ติดต่อเรา',
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
          colors: [
            AppColors.secondary,
            AppColors.secondary.withValues(alpha: 0.8),
          ],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.article,
            size: 64,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 16),
          Text(
            'เงื่อนไขการให้บริการ',
            textAlign: TextAlign.center,
            style: AppTextStyles.headline2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'กรุณาอ่านและทำความเข้าใจก่อนใช้งาน',
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

  Widget _buildAcceptanceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'การใช้งานแอปพลิเคชันคัดกรองภาวะออทิสติกในเด็กเล็ก ("แอป") '
          'ถือว่าคุณได้อ่าน เข้าใจ และยอมรับที่จะปฏิบัติตามเงื่อนไขการให้บริการนี้ '
          'หากคุณไม่ยอมรับเงื่อนไขเหล่านี้ กรุณาหยุดการใช้งานแอปทันที',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'การใช้งานแอปนี้แสดงว่าคุณยอมรับเงื่อนไขทั้งหมด',
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

  Widget _buildServiceDescriptionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'แอปพลิเคชันของเราให้บริการเครื่องมือคัดกรองเบื้องต้นสำหรับภาวะออทิสติก '
          'ในเด็กเล็กโดยใช้:',
        ),
        const SizedBox(height: 8),
        _buildBulletPoint('แบบประเมิน Q-CHAT สำหรับเด็กอายุ 18-24 เดือน'),
        _buildBulletPoint('การวิเคราะห์วิดีโอพฤติกรรมของเด็ก'),
        _buildBulletPoint('การแสดงผลและติดตามประวัติการประเมิน'),
        _buildBulletPoint('คำแนะนำเบื้องต้นจากผลการคัดกรอง'),
      ],
    );
  }

  Widget _buildUserAccountContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('การสร้างบัญชี'),
        _buildParagraph(
          'คุณต้องสร้างบัญชีผู้ใช้เพื่อใช้งานบริการบางส่วนของแอป '
          'คุณต้องให้ข้อมูลที่ถูกต้องและเป็นปัจจุบัน',
        ),
        const SizedBox(height: 12),
        _buildSubsectionTitle('ความรับผิดชอบของผู้ใช้'),
        _buildBulletPoint('รักษาความลับของรหัสผ่านและข้อมูลบัญชี'),
        _buildBulletPoint('แจ้งเราทันทีหากพบการใช้งานที่ไม่ได้รับอนุญาต'),
        _buildBulletPoint('รับผิดชอบการกระทำทั้งหมดภายใต้บัญชีของคุณ'),
        _buildBulletPoint('ให้ข้อมูลที่ถูกต้องและเป็นจริง'),
      ],
    );
  }

  Widget _buildUsageRulesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph('คุณตกลงที่จะ:'),
        const SizedBox(height: 8),
        _buildBulletPoint('ใช้แอปเพื่อวัตถุประสงค์ที่ถูกกฎหมายเท่านั้น'),
        _buildBulletPoint(
          'ไม่กระทำการใดๆ ที่อาจทำให้แอปหรือเซิร์ฟเวอร์เสียหาย',
        ),
        _buildBulletPoint('ไม่พยายามเข้าถึงระบบโดยไม่ได้รับอนุญาต'),
        _buildBulletPoint('ไม่แชร์ข้อมูลที่ละเมิดลิขสิทธิ์หรือผิดกฎหมาย'),
        _buildBulletPoint('ไม่ใช้แอปในทางที่ผิดหรือหลอกลวง'),
      ],
    );
  }

  Widget _buildIntellectualPropertyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'เนื้อหาทั้งหมดในแอป รวมถึงข้อความ กราฟิก โลโก้ ไอคอน ภาพ วิดีโอ '
          'และซอफต์แวร์ เป็นทรัพย์สินของเราหรือผู้ให้อนุญาต และได้รับการคุ้มครอง'
          'ภายใต้กฎหมายทรัพย์สินทางปัญญา',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.copyright, color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ห้ามคัดลอก ดัดแปลง หรือเผยแพร่เนื้อหาโดยไม่ได้รับอนุญาต',
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

  Widget _buildLiabilityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'แอปนี้ให้บริการ "ตามสภาพ" และ "ตามที่มีอยู่" เราไม่รับประกันว่า:',
        ),
        const SizedBox(height: 8),
        _buildBulletPoint('บริการจะไม่มีข้อผิดพลาดหรือหยุดชะงัก'),
        _buildBulletPoint('ข้อมูลจะถูกต้องและเชื่อถือได้ 100%'),
        _buildBulletPoint('ผลลัพธ์จะตรงกับการวินิจฉัยทางการแพทย์'),
        const SizedBox(height: 12),
        _buildParagraph(
          'เราไม่รับผิดชอบต่อความเสียหายใดๆ ที่เกิดจากการใช้งานแอป '
          'รวมถึงแต่ไม่จำกัดเพียงความเสียหายทางตรง ทางอ้อม หรือเป็นผลสืบเนื่อง',
        ),
      ],
    );
  }

  Widget _buildMedicalDisclaimerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber, color: AppColors.error, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'คำเตือนสำคัญ',
                      style: AppTextStyles.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'แอปนี้ไม่ใช่เครื่องมือวินิจฉัยโรค และไม่สามารถทดแทนการตรวจวินิจฉัยโดยแพทย์ผู้เชี่ยวชาญ',
                style: AppTextStyles.bodyText2.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildParagraph(
          'ผลการคัดกรองจากแอปเป็นเพียงข้อมูลเบื้องต้นเท่านั้น '
          'หากผลการคัดกรองแสดงความเสี่ยง กรุณาปรึกษาแพทย์หรือนักจิตวิทยา'
          'ที่มีความเชี่ยวชาญด้านพัฒนาการเด็กเพื่อการประเมินและวินิจฉัยที่ถูกต้อง',
        ),
      ],
    );
  }

  Widget _buildTerminationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('เราสามารถยกเลิกบัญชีของคุณได้หาก:'),
        _buildBulletPoint('คุณละเมิดเงื่อนไขการให้บริการ'),
        _buildBulletPoint('คุณใช้บริการในทางที่ผิดกฎหมายหรือหลอกลวง'),
        _buildBulletPoint('คุณไม่ใช้งานบัญชีเป็นระยะเวลานาน'),
        const SizedBox(height: 12),
        _buildSubsectionTitle('คุณสามารถยกเลิกบัญชีได้:'),
        _buildBulletPoint('โดยการลบบัญชีผ่านการตั้งค่าในแอป'),
        _buildBulletPoint('โดยการติดต่อทีมสนับสนุนของเรา'),
        const SizedBox(height: 12),
        _buildParagraph(
          'เมื่อบัญชีถูกยกเลิก ข้อมูลของคุณจะถูกจัดการตามนโยบายความเป็นส่วนตัว',
        ),
      ],
    );
  }

  Widget _buildChangesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'เราขอสงวนสิทธิ์ในการเปลี่ยนแปลงหรือปรับปรุงเงื่อนไขการให้บริการนี้ '
          'ได้ตลอดเวลา การเปลี่ยนแปลงที่สำคัญจะแจ้งให้คุณทราบล่วงหน้า:',
        ),
        const SizedBox(height: 8),
        _buildBulletPoint('ผ่านการแจ้งเตือนในแอป'),
        _buildBulletPoint('ผ่านอีเมลที่ลงทะเบียนไว้'),
        _buildBulletPoint('ผ่านการแสดงหน้าต่างแจ้งเตือนเมื่อเปิดแอป'),
        const SizedBox(height: 12),
        _buildParagraph(
          'การใช้งานแอปต่อไปหลังจากมีการเปลี่ยนแปลงเงื่อนไข '
          'ถือว่าคุณยอมรับเงื่อนไขใหม่',
        ),
      ],
    );
  }

  Widget _buildGoverningLawContent() {
    return _buildParagraph(
      'เงื่อนไขการให้บริการนี้อยู่ภายใต้บังคับและตีความตามกฎหมายของประเทศไทย '
      'ข้อพิพาทใดๆ ที่เกิดขึ้นจากหรือเกี่ยวข้องกับเงื่อนไขนี้ '
      'จะอยู่ภายใต้เขตอำนาจของศาลไทย',
    );
  }

  Widget _buildContactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'หากคุณมีคำถามเกี่ยวกับเงื่อนไขการให้บริการ กรุณาติดต่อเราได้ที่:',
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
                  'เงื่อนไขฉบับนี้มีผลบังคับใช้ตั้งแต่\n21 พฤศจิกายน 2568',
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
