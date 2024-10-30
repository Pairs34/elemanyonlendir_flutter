import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Globals {
  // Private constructor for singleton pattern
  Globals._privateConstructor();
  static final Globals _instance = Globals._privateConstructor();
  static Globals get instance => _instance;

  // Secure storage instance
  static final _secureStorage = FlutterSecureStorage();

  // Getter for token
  Future<String?> get token async {
    return await _secureStorage.read(key: 'token');
  }

  // Setter for token
  Future<void> setToken(String value) async {
    await _secureStorage.write(key: 'token', value: value);
  }

  // Optional: Method to remove token (logout scenario)
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'token');
  }
}
