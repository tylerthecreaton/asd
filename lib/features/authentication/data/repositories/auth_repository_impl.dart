import 'package:dartz/dartz.dart';

import 'package:asd/core/errors/exceptions.dart';
import 'package:asd/core/errors/failures.dart';
import 'package:asd/core/network/network_info.dart';
import 'package:asd/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:asd/features/authentication/domain/entities/user.dart';
import 'package:asd/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signIn(email, password);
        return Right(user);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Authentication failed'),
        );
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, User>> signUp(
    String email,
    String password,
    String? name,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(email, password, name);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'Registration failed'));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'Failed to sign out'));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to reset password'),
        );
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to get current user'),
      );
    }
  }

  @override
  Stream<Either<Failure, User?>> get authStateChanges {
    return remoteDataSource.authStateChanges.map(
      (user) => Right<Failure, User?>(user),
    );
  }
}
