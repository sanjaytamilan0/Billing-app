import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final localStorageProvider = Provider((ref) => LocalStorage(ref.watch(sharedPreferencesProvider)));

class LocalStorage {
  final SharedPreferences _prefs;
  LocalStorage(this._prefs);

  static const _tokenKey = 'auth_token';
  static const _roleKey = 'user_role';
  static const _companyKey = 'user_company';
  static const _phoneKey = 'user_phone';

  Future<void> saveUserData({
    required String token,
    required String role,
    required String phone,
    String? companyName,
  }) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_roleKey, role);
    await _prefs.setString(_phoneKey, phone);
    if (companyName != null) {
      await _prefs.setString(_companyKey, companyName);
    }
  }

  String? getToken() => _prefs.getString(_tokenKey);
  String? getRole() => _prefs.getString(_roleKey);
  String? getPhone() => _prefs.getString(_phoneKey);
  String? getCompanyName() => _prefs.getString(_companyKey);

  Future<void> saveCompanyName(String name) async {
    await _prefs.setString(_companyKey, name);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
