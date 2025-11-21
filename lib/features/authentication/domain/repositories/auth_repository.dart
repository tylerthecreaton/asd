import 'package:dartz/dartz.dart';
import 'package:asd/core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp(
    String email,
    String password,
    String? name,
  );
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  );
}
