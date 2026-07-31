import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSessionStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const tokenKey = 'token';
  static const refreshTokenKey = 'refresh_token';
  static const userIdKey = 'user_id';
  static const userEmailKey = 'user_email';

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: tokenKey, value: token);
    if (IoD.instance.isRegistered<AppState>()) {
      IoD.instance.get<AppState>().setIsLogged(true);
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await _secureStorage.delete(key: tokenKey);
    await _secureStorage.delete(key: refreshTokenKey);
    await _secureStorage.delete(key: userIdKey);
    await _secureStorage.delete(key: userEmailKey);
    await prefs.remove(tokenKey);
    await prefs.remove(refreshTokenKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userEmailKey);
    IoD.instance.get<AppState>().setIsLogged(false);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final secureToken = await _secureStorage.read(key: tokenKey);
    final legacyToken = prefs.getString(tokenKey);
    if ((secureToken == null || secureToken.isEmpty) &&
        legacyToken != null &&
        legacyToken.isNotEmpty) {
      await _secureStorage.write(key: tokenKey, value: legacyToken);
      await prefs.remove(tokenKey);
      return legacyToken;
    }
    return secureToken;
  }
}
