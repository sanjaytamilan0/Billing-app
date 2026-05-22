import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../providers/suggestion_provider.dart';
import '../models/suggestion_model.dart';

class ReviewSuggestionsScreen extends ConsumerWidget {
  const ReviewSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(pendingSuggestionsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Suggestions', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(pendingSuggestionsProvider),
          ),
        ],
      ),
      body: suggestionsAsync.when(
        data: (suggestions) {
          if (suggestions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No pending suggestions.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: 0.2),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildGlassmorphicSuggestionCard(context, ref, suggestion, theme, isDark),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildGlassmorphicSuggestionCard(BuildContext context, WidgetRef ref, SuggestionModel suggestion, ThemeData theme, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.lightbulb, color: theme.colorScheme.primary),
            ),
            title: Text(suggestion.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${suggestion.category}', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text('Suggested by: ${suggestion.suggestedBy?.phone ?? 'Unknown'}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            isThreeLine: true,
            onTap: () => _showReviewDialog(context, ref, suggestion, theme, isDark),
          ),
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, WidgetRef ref, SuggestionModel suggestion, ThemeData theme, bool isDark) {
    final nameCtrl = TextEditingController(text: suggestion.name);
    final catCtrl = TextEditingController(text: suggestion.category);
    final descCtrl = TextEditingController(text: suggestion.description);
    final priceCtrl = TextEditingController(text: suggestion.price.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Review Suggestion', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField('Name', nameCtrl, theme),
              const SizedBox(height: 16),
              _buildDialogField('Category', catCtrl, theme),
              const SizedBox(height: 16),
              _buildDialogField('Price', priceCtrl, theme, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildDialogField('Description', descCtrl, theme, maxLines: 3),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await ref.read(suggestionRepositoryProvider).updateSuggestionStatus(suggestion.id, 'rejected');
                ref.refresh(pendingSuggestionsProvider);
                Get.back();
                Get.snackbar('Rejected', 'Suggestion was rejected.');
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
            child: const Text('Reject', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(suggestionRepositoryProvider).updateSuggestion(suggestion.id, {
                  'name': nameCtrl.text,
                  'category': catCtrl.text,
                  'description': descCtrl.text,
                  'price': double.tryParse(priceCtrl.text) ?? 0,
                });
                await ref.read(suggestionRepositoryProvider).updateSuggestionStatus(suggestion.id, 'accepted');
                ref.refresh(pendingSuggestionsProvider);
                Get.back();
                Get.snackbar('Accepted', 'Product successfully created from suggestion!', backgroundColor: Colors.green, colorText: Colors.white);
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Accept & Add', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller, ThemeData theme, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.primary.withOpacity(0.8)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.colorScheme.primary, width: 2)),
        filled: true,
        fillColor: theme.colorScheme.primary.withOpacity(0.05),
      ),
    );
  }
}
