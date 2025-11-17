import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';
import 'auth_dependencies.dart';

/// Authentication provider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  // Mock users database (กำหนดไว้ล่วงหน้า)
  static const Map<String, Map<String, String>> _mockUsers = {
    'admin@test.com': {
      'password': 'admin123',
      'name': 'ผู้ดูแลระบบ',
      'id': '1',
    },
    'user@test.com': {
      'password': 'user1234',
      'name': 'ผู้ใช้งานทั่วไป',
      'id': '2',
    },
    'test@example.com': {
      'password': '12345678',
      'name': 'ทดสอบระบบ',
      'id': '3',
    },
  };

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // ตรวจสอบว่า email และ password ไม่ว่างเปล่า
      if (email.trim().isEmpty || password.isEmpty) {
        throw Exception('กรุณากรอกอีเมลและรหัสผ่าน');
      }

      // ตรวจสอบว่ามี user นี้ในระบบหรือไม่
      final userData = _mockUsers[email.trim().toLowerCase()];

      if (userData == null) {
        throw Exception('ไม่พบผู้ใช้งานนี้ในระบบ');
      }

      // ตรวจสอบรหัสผ่าน
      if (userData['password'] != password) {
        throw Exception('รหัสผ่านไม่ถูกต้อง');
      }

      // สร้าง User object
      final user = User(
        id: userData['id']!,
        email: email.trim().toLowerCase(),
        name: userData['name'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Login สำเร็จ
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // ตรวจสอบว่าข้อมูลครบถ้วน
      if (email.trim().isEmpty || password.isEmpty || fullName.trim().isEmpty) {
        throw Exception('กรุณากรอกข้อมูลให้ครบถ้วน');
      }

      // ตรวจสอบว่า email ซ้ำหรือไม่
      if (_mockUsers.containsKey(email.trim().toLowerCase())) {
        throw Exception('อีเมลนี้ถูกใช้งานแล้ว');
      }

      // สร้าง User object สำหรับผู้ใช้ใหม่
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email.trim().toLowerCase(),
        name: fullName.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Registration สำเร็จ - auto login
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _authRepository.signOut();
      
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (_) {
          state = const AuthState();
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for authentication
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
