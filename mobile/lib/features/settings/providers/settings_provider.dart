import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../../core/network/local_storage.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});

class SettingsState {
  final bool isDarkMode;
  final String languageCode;

  SettingsState({required this.isDarkMode, required this.languageCode});

  SettingsState copyWith({bool? isDarkMode, String? languageCode}) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs)
      : super(SettingsState(
          isDarkMode: _prefs.getBool('is_dark_mode') ?? false,
          languageCode: _prefs.getString('language_code') ?? 'en_US',
        ));

  void toggleTheme(bool isDark) {
    _prefs.setBool('is_dark_mode', isDark);
    state = state.copyWith(isDarkMode: isDark);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void changeLanguage(String langCode) {
    _prefs.setString('language_code', langCode);
    state = state.copyWith(languageCode: langCode);
    
    final parts = langCode.split('_');
    final locale = Locale(parts[0], parts.length > 1 ? parts[1] : null);
    Get.updateLocale(locale);
  }
}
