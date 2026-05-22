import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/suggestion_provider.dart';
import '../models/suggestion_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewSuggestionsScreen extends ConsumerWidget {
  const ReviewSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(pendingSuggestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Suggestions'),
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
            return const Center(child: Text('No pending suggestions.'));
          }
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(suggestion.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Category: ${suggestion.category}\nSuggested by: ${suggestion.suggestedBy?.phone ?? 'Unknown'}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  isThreeLine: true,
                  onTap: () => _showReviewDialog(context, ref, suggestion),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, WidgetRef ref, SuggestionModel suggestion) {
    final nameCtrl = TextEditingController(text: suggestion.name);
    final catCtrl = TextEditingController(text: suggestion.category);
    final descCtrl = TextEditingController(text: suggestion.description);
    final priceCtrl = TextEditingController(text: suggestion.price.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review Suggestion'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
            ],
          ),
        ),
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
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Update first if anything changed
                await ref.read(suggestionRepositoryProvider).updateSuggestion(suggestion.id, {
                  'name': nameCtrl.text,
                  'category': catCtrl.text,
                  'description': descCtrl.text,
                  'price': double.tryParse(priceCtrl.text) ?? 0,
                });
                // Then accept
                await ref.read(suggestionRepositoryProvider).updateSuggestionStatus(suggestion.id, 'accepted');
                ref.refresh(pendingSuggestionsProvider);
                Get.back();
                Get.snackbar('Accepted', 'Product successfully created from suggestion!', backgroundColor: Colors.green, colorText: Colors.white);
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Accept & Add Product', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
