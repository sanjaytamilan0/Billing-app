import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class LocalStorage {
  final SharedPreferences _prefs;
  LocalStorage(this._prefs);

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clear() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
  }
}

final localStorageProvider = Provider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorage(prefs);
});
