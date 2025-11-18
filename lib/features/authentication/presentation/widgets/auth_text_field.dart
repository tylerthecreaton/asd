import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

/// Reusable text field for authentication forms
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onToggleObscure;
  final bool enabled;
  final int maxLines;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onToggleObscure,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.bodyText1.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          style: AppTextStyles.bodyText1,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyText2.copyWith(
              color: AppColors.textDisabled,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon:
                widget.suffixIcon ??
                (widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null),
            filled: true,
            fillColor: widget.enabled
                ? AppColors.cardBackground
                : AppColors.textDisabled.withValues(alpha: 0.1),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
