import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  static const String _tokenKey = 'auth_token';
  final StreamController<String?> _tokenController =
      StreamController<String?>.broadcast();

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
    _tokenController.add(token);
  }

  Future<String?> getToken() => _secureStorage.read(key: _tokenKey);

  Future<bool> hasToken() async => (await getToken()) != null;

  Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
    _tokenController.add(null);
  }

  Stream<String?> get tokenChanges => _tokenController.stream;

  void dispose() {
    _tokenController.close();
  }
}
