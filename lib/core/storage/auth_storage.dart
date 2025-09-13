import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  AuthStorage._();
  static final AuthStorage instance = AuthStorage._();

  static final _secureStorage = FlutterSecureStorage();

  Future<String?> getToken() => _secureStorage.read(key: 'token');
  Future<void> setToken(String value) =>
      _secureStorage.write(key: 'token', value: value);
  Future<void> clearToken() => _secureStorage.delete(key: 'token');
}
