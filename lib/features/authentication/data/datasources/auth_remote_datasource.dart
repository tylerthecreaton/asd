import 'package:asd/core/errors/exceptions.dart';
import 'package:asd/features/authentication/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String? name);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase.SupabaseClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const ServerException(message: 'Failed to sign in');
      }

      return UserModel.fromSupabaseUser(user);
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw const ServerException(message: 'Unexpected error during sign in');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String? name) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      final user = response.user;
      if (user == null) {
        throw const ServerException(message: 'Failed to sign up');
      }

      return UserModel.fromSupabaseUser(user);
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw const ServerException(message: 'Unexpected error during sign up');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw const ServerException(message: 'Unexpected error during sign out');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw const ServerException(
        message: 'Unexpected error during password reset',
      );
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      return user != null ? UserModel.fromSupabaseUser(user) : null;
    } catch (e) {
      throw const ServerException(message: 'Failed to get current user');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      return user != null ? UserModel.fromSupabaseUser(user) : null;
    });
  }
}
