import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/providers/preferences_providers.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Load remembered email
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefsStorage = ref.read(preferencesStorageProvider);
      final rememberedEmail = prefsStorage.getRememberedEmail();
      if (rememberedEmail != null && rememberedEmail.isNotEmpty) {
        _emailController.text = rememberedEmail;
        setState(() {
          _rememberMe = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Clear previous error
      ref.read(authProvider.notifier).clearError();

      await ref.read(authProvider.notifier).login(email, password);

      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.isAuthenticated) {
          // Save or clear remembered email
          final prefsStorage = ref.read(preferencesStorageProvider);
          if (_rememberMe) {
            await prefsStorage.saveRememberedEmail(email);
          } else {
            await prefsStorage.clearRememberedEmail();
          }

          context.go(RouteConstants.home);
        } else if (authState.errorMessage != null) {
          _showErrorSnackBar(authState.errorMessage!);
        }
      }
    }
  }

  void _handleForgotPassword() {
    // TODO: Implement forgot password flow
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('รีเซ็ตรหัสผ่าน'),
        content: const Text(
          'ฟีเจอร์นี้จะพร้อมใช้งานเร็วๆ นี้\nกรุณาติดต่อผู้ดูแลระบบหากต้องการรีเซ็ตรหัสผ่าน',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.05),
                  AppColors.background,
                  AppColors.secondary.withValues(alpha: 0.03),
                ],
              ),
            ),
          ),
          // Floating Decorations
          Positioned(
            top: 100,
            left: 50,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 200,
            right: 80,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      // Greeting Text
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(-20 * (1 - value), 0),
                              child: child,
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.headline1.copyWith(
                              fontSize: 28,
                              height: 1.3,
                              color: Colors.grey[900],
                            ),
                            children: const [
                              TextSpan(
                                text: 'Welcome Back,\n',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: 'this is your login page',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Login Form
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email Field
                              AuthTextField(
                                controller: _emailController,
                                label: 'อีเมล',
                                hint: 'กรอกอีเมลของคุณ',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email_outlined),
                                validator: Validators.validateEmail,
                              ),

                              const SizedBox(height: 16),

                              // Password Field
                              AuthTextField(
                                controller: _passwordController,
                                label: 'รหัสผ่าน',
                                hint: 'กรอกรหัสผ่านของคุณ',
                                obscureText: _obscurePassword,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: Validators.validatePassword,
                              ),

                              const SizedBox(height: 8),

                              // Remember Me & Forgot Password
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                          activeColor: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'จดจำฉันไว้',
                                        style: AppTextStyles.bodyText2.copyWith(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: _handleForgotPassword,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'ลืมรหัสผ่าน?',
                                      style: AppTextStyles.bodyText2.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Login Button
                              AuthButton(
                                text: 'เข้าสู่ระบบ',
                                onPressed: _handleLogin,
                                isLoading: authState.isLoading,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Register Link
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 10 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ยังไม่มีบัญชี? ',
                                style: AppTextStyles.bodyText1.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push(RouteConstants.register);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'สมัครสมาชิก',
                                  style: AppTextStyles.bodyText1.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
