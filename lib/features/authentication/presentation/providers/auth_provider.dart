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
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: failure.message,
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
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: failure.message,
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
}

/// Provider for authentication
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
