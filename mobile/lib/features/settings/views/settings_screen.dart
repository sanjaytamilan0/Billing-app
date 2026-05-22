import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Settings'.tr, style: const TextStyle(fontWeight: FontWeight.bold))),
      body: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 500),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              _buildSettingsSection(
                context, 
                theme, 
                isDark, 
                'Appearance',
                [
                  SwitchListTile(
                    title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                    value: settingsState.isDarkMode,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (val) => settingsNotifier.toggleTheme(val),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSettingsSection(
                context, 
                theme, 
                isDark, 
                'Language',
                [
                  RadioListTile<String>(
                    title: const Text('English', style: TextStyle(fontWeight: FontWeight.w500)),
                    value: 'en_US',
                    activeColor: theme.colorScheme.primary,
                    groupValue: settingsState.languageCode,
                    onChanged: (val) => settingsNotifier.changeLanguage(val!),
                  ),
                  RadioListTile<String>(
                    title: const Text('தமிழ் (Tamil)', style: TextStyle(fontWeight: FontWeight.w500)),
                    value: 'ta_IN',
                    activeColor: theme.colorScheme.primary,
                    groupValue: settingsState.languageCode,
                    onChanged: (val) => settingsNotifier.changeLanguage(val!),
                  ),
                  RadioListTile<String>(
                    title: const Text('മലയാളം (Malayalam)', style: TextStyle(fontWeight: FontWeight.w500)),
                    value: 'ml_IN',
                    activeColor: theme.colorScheme.primary,
                    groupValue: settingsState.languageCode,
                    onChanged: (val) => settingsNotifier.changeLanguage(val!),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, ThemeData theme, bool isDark, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
          child: Text(
            title, 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.primary),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : theme.colorScheme.primary.withOpacity(0.1),
                  width: 1.5,
                ),
                boxShadow: isDark ? [] : [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(children: children),
            ),
          ),
        ),
      ],
    );
  }
}
