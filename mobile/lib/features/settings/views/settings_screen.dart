import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Settings'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settingsState.isDarkMode,
            onChanged: (val) => settingsNotifier.toggleTheme(val),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en_US',
            groupValue: settingsState.languageCode,
            onChanged: (val) => settingsNotifier.changeLanguage(val!),
          ),
          RadioListTile<String>(
            title: const Text('தமிழ் (Tamil)'),
            value: 'ta_IN',
            groupValue: settingsState.languageCode,
            onChanged: (val) => settingsNotifier.changeLanguage(val!),
          ),
          RadioListTile<String>(
            title: const Text('മലയാളം (Malayalam)'),
            value: 'ml_IN',
            groupValue: settingsState.languageCode,
            onChanged: (val) => settingsNotifier.changeLanguage(val!),
          ),
        ],
      ),
    );
  }
}
