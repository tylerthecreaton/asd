import 'package:dartz/dartz.dart';

import 'package:asd/core/errors/exceptions.dart';
import 'package:asd/core/errors/failures.dart';
import 'package:asd/core/network/network_info.dart';
import 'package:asd/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:asd/features/authentication/domain/entities/user.dart';
import 'package:asd/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/services/token_storage.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.tokenStorage,
  });

  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final TokenStorage tokenStorage;

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final AuthResponseModel response = await remoteDataSource.signIn(
          email,
          password,
        );
        await tokenStorage.saveToken(response.token);
        return Right(response.user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Authentication failed'));
      }
    }
    return Left(NetworkFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, User>> signUp(
    String email,
    String password,
    String? name,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final AuthResponseModel response = await remoteDataSource.signUp(
          email,
          password,
          name,
        );
        await tokenStorage.saveToken(response.token);
        return Right(response.user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Registration failed'));
      }
    }
    return Left(NetworkFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    await tokenStorage.clearToken();
    return const Right(null);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    if (!await tokenStorage.hasToken()) {
      return const Right(null);
    }
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get current user'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.changePassword(
        currentPassword,
        newPassword,
        confirmPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to change password'));
    }
  }
}
