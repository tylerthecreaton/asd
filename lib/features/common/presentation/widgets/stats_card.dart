import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

class StatsCard extends ConsumerStatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const StatsCard({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  ConsumerState<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends ConsumerState<StatsCard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _counterController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    _counterAnimation = IntTween(begin: 0, end: int.tryParse(widget.value) ?? 0)
        .animate(
          CurvedAnimation(
            parent: _counterController,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _scaleController.forward();
    _counterController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.color ?? AppColors.primary;

    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _scaleController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(widget.icon, size: 32, color: cardColor),
                          const SizedBox(height: 12),
                          AnimatedBuilder(
                            animation: _counterController,
                            builder: (context, child) {
                              return Text(
                                _counterAnimation.value.toString(),
                                style: AppTextStyles.headline3.copyWith(
                                  color: cardColor,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.label,
                            style: AppTextStyles.bodyText2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _counterController.dispose();
    super.dispose();
  }
}
