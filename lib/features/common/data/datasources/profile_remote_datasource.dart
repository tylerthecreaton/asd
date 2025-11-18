import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../authentication/data/models/user_model.dart';
import '../models/user_stats_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({String? name});
  Future<UserStatsModel> getUserStats();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.authProfilePath,
      );
      final userJson = response.data?['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw const ServerException(message: 'User profile not available');
      }
      return UserModel.fromJson(userJson);
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (_) {
      throw const ServerException(message: 'Failed to load profile');
    }
  }

  @override
  Future<UserModel> updateProfile({String? name}) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        ApiConstants.authProfilePath,
        data: {'name': name},
      );
      final userJson = response.data?['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw const ServerException(message: 'Failed to update profile');
      }
      return UserModel.fromJson(userJson);
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (_) {
      throw const ServerException(message: 'Unable to update profile');
    }
  }

  @override
  Future<UserStatsModel> getUserStats() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.authStatsPath,
      );
      if (response.data == null) {
        throw const ServerException(message: 'Stats not available');
      }
      return UserStatsModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw ServerException(message: _resolveErrorMessage(error));
    } catch (_) {
      throw const ServerException(message: 'Failed to load statistics');
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
}
