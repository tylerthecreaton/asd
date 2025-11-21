import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_dependencies.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: 'กรุณากรอกอีเมลและรหัสผ่าน',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.signIn(email.trim(), password);

    result.fold(
      (failure) {
        String errorMessage = 'เข้าสู่ระบบไม่สำเร็จ';

        // Parse error message for better user experience
        if (failure.message.toLowerCase().contains('invalid credentials')) {
          errorMessage = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
        } else if (failure.message.toLowerCase().contains('network') ||
            failure.message.toLowerCase().contains('connection')) {
          errorMessage =
              'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาลองใหม่อีกครั้ง';
        } else if (failure.message.toLowerCase().contains('unauthorized')) {
          errorMessage = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
        } else if (failure.message.isNotEmpty) {
          errorMessage = failure.message;
        }

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: errorMessage,
        );
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    if (email.trim().isEmpty || password.isEmpty || fullName.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: 'กรุณากรอกข้อมูลให้ครบถ้วน',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.signUp(
      email.trim(),
      password,
      fullName.trim(),
    );

    result.fold(
      (failure) {
        String errorMessage = 'สมัครสมาชิกไม่สำเร็จ';

        // Parse error message for better user experience
        if (failure.message.toLowerCase().contains('already registered') ||
            failure.message.toLowerCase().contains('conflict') ||
            failure.message.toLowerCase().contains('already exists')) {
          errorMessage = 'อีเมลนี้ถูกใช้งานแล้ว กรุณาใช้อีเมลอื่น';
        } else if (failure.message.toLowerCase().contains('network') ||
            failure.message.toLowerCase().contains('connection')) {
          errorMessage =
              'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาลองใหม่อีกครั้ง';
        } else if (failure.message.toLowerCase().contains('validation') ||
            failure.message.toLowerCase().contains('invalid')) {
          errorMessage = 'ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบและลองใหม่อีกครั้ง';
        } else if (failure.message.isNotEmpty) {
          errorMessage = failure.message;
        }

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: errorMessage,
        );
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> restoreSession() async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: failure.message,
        );
      },
      (user) {
        if (user != null) {
          state = state.copyWith(
            isAuthenticated: true,
            user: user,
            errorMessage: null,
          );
        }
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.signOut();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (_) {
        state = const AuthState();
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'กรุณากรอกข้อมูลให้ครบถ้วน',
      );
      return false;
    }

    if (newPassword != confirmPassword) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'รหัสผ่านใหม่ไม่ตรงกัน',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.changePassword(
      currentPassword,
      newPassword,
      confirmPassword,
    );

    return result.fold(
      (failure) {
        String errorMessage = 'เปลี่ยนรหัสผ่านไม่สำเร็จ';

        if (failure.message.toLowerCase().contains('incorrect') ||
            failure.message.toLowerCase().contains('wrong')) {
          errorMessage = 'รหัสผ่านปัจจุบันไม่ถูกต้อง';
        } else if (failure.message.toLowerCase().contains('network') ||
            failure.message.toLowerCase().contains('connection')) {
          errorMessage =
              'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาลองใหม่อีกครั้ง';
        } else if (failure.message.isNotEmpty) {
          errorMessage = failure.message;
        }

        state = state.copyWith(isLoading: false, errorMessage: errorMessage);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, errorMessage: null);
        return true;
      },
    );
  }
}

/// Provider for authentication
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
