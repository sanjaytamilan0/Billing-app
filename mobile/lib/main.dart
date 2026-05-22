import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/network/local_storage.dart';
import 'core/localization/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine initial route based on token and role
    final storage = ref.read(localStorageProvider);
    final token = storage.getToken();
    final role = storage.getRole();
    final companyName = storage.getCompanyName();

    String initialRoute = Routes.login;
    if (token != null) {
      if (role == 'user' && companyName == null) {
        initialRoute = Routes.companySelection;
      } else {
        initialRoute = Routes.main;
      }
    }

    final prefs = ref.read(sharedPreferencesProvider);
    final isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    final langCode = prefs.getString('language_code') ?? 'en_US';
    final langParts = langCode.split('_');
    final locale = Locale(langParts[0], langParts.length > 1 ? langParts[1] : null);

    return GetMaterialApp(
      title: 'Billing App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
