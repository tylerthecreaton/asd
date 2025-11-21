import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signIn(String email, String password);
  Future<AuthResponseModel> signUp(String email, String password, String? name);
  Future<UserModel> getCurrentUser();
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthResponseModel> signIn(String email, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.authLoginPath,
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException(message: 'Empty response from /auth/login');
      }
      return AuthResponseModel.fromJson(data);
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (error) {
      throw const ServerException(message: 'Unexpected error during sign in');
    }
  }

  @override
  Future<AuthResponseModel> signUp(
    String email,
    String password,
    String? name,
  ) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.authRegisterPath,
        data: {
          'email': email,
          'password': password,
          if (name != null && name.isNotEmpty) 'name': name,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException(
          message: 'Empty response from /auth/register',
        );
      }
      return AuthResponseModel.fromJson(data);
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (error) {
      throw const ServerException(message: 'Unexpected error during sign up');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.authProfilePath,
      );
      final data = response.data;
      final userJson = data?['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw const ServerException(message: 'User profile not available');
      }
      return UserModel.fromJson(userJson);
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (error) {
      throw const ServerException(message: 'Failed to load user profile');
    }
  }

  String _resolveErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }
    return error.message ?? 'Network error';
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      await _apiClient.post(
        ApiConstants.authChangePasswordPath,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (error) {
      throw const ServerException(
        message: 'Unexpected error during password change',
      );
    }
  }
}
