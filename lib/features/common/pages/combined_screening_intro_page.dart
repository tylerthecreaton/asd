import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../widgets/custom_button.dart';

class CombinedScreeningIntroPage extends StatelessWidget {
  const CombinedScreeningIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การคัดกรองแบบรวม'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Hero Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.secondary.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.quiz,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.add,
                              size: 32,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.videocam,
                              size: 48,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'การคัดกรองแบบรวม',
                          style: AppTextStyles.headline2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'การคัดกรองที่รวมระหว่าง Q-CHAT และวิเคราะห์วิดีโอ '
                          'เพื่อให้ผลการประเมินที่แม่นยำและครบถ้วนมากขึ้น',
                          style: AppTextStyles.bodyText1.copyWith(height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ใช้เวลาประมาณ 25 นาที',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // What's Included Section
                Text(
                  'ขั้นตอนการคัดกรอง',
                  style: AppTextStyles.headline3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                _buildStepCard(
                  context,
                  stepNumber: '1',
                  icon: Icons.quiz,
                  iconColor: AppColors.primary,
                  title: 'แบบประเมิน Q-CHAT-10',
                  description:
                      'ตอบคำถาม 10 ข้อเกี่ยวกับพฤติกรรมและการสื่อสารของเด็ก',
                  duration: '~10 นาที',
                ),

                const SizedBox(height: 12),

                _buildStepCard(
                  context,
                  stepNumber: '2',
                  icon: Icons.videocam,
                  iconColor: AppColors.secondary,
                  title: 'วิเคราะห์วิดีโอ',
                  description:
                      'บันทึกวิดีโอขณะเด็กดูวิดีโอกระตุ้นและวิเคราะห์พฤติกรรม',
                  duration: '~15 นาที',
                ),

                const SizedBox(height: 12),

                _buildStepCard(
                  context,
                  stepNumber: '3',
                  icon: Icons.analytics,
                  iconColor: AppColors.info,
                  title: 'ผลการประเมินรวม',
                  description:
                      'รับผลการประเมินจากทั้ง 2 เครื่องมือคัดกรองพร้อมกัน',
                  duration: 'ทันที',
                ),

                const SizedBox(height: 32),

                // Important Notes
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ข้อควรรู้',
                              style: AppTextStyles.bodyText2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.info,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '• กรุณาเตรียมเวลาประมาณ 25-30 นาที\n'
                              '• ควรอยู่ในสภาพแวดล้อมที่เหมาะสม\n'
                              '• สามารถหยุดพักได้ระหว่างขั้นตอน',
                              style: AppTextStyles.caption.copyWith(
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                CustomButton(
                  text: 'เริ่มการคัดกรอง',
                  width: double.infinity,
                  onPressed: () {
                    // Navigate to Q-CHAT first
                    context.push(RouteConstants.questionnaireIntro);
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                CustomButton(
                  text: 'กลับหน้าหลัก',
                  buttonType: ButtonType.outlined,
                  width: double.infinity,
                  onPressed: () {
                    context.pop();
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context, {
    required String stepNumber,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String duration,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: AppTextStyles.headline3.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: iconColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.bodyText1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: AppTextStyles.bodyText2.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.textDisabled,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      duration,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
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
}
