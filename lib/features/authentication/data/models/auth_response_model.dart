import 'user_model.dart';

class AuthResponseModel {
  const AuthResponseModel({required this.user, required this.token});

  final UserModel user;
  final String token;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson =
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final token = json['token'] as String?;
    if (token == null || token.isEmpty) {
      throw StateError('Missing authentication token');
    }
    return AuthResponseModel(user: UserModel.fromJson(userJson), token: token);
  }
}
