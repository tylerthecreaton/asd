import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

/// Welcome banner widget for home page
class WelcomeBanner extends StatelessWidget {
  final String userName;
  final VoidCallback? onProfileTap;

  const WelcomeBanner({super.key, required this.userName, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryVariant],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สวัสดี, $userName',
                  style: AppTextStyles.headline3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'ยินดีต้อนรับสู่ระบบคัดกรองออทิสติก',
                  style: AppTextStyles.bodyText2.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
