import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/suggestion_provider.dart';
import '../providers/category_provider.dart';

class SuggestProductScreen extends ConsumerStatefulWidget {
  const SuggestProductScreen({super.key});

  @override
  ConsumerState<SuggestProductScreen> createState() => _SuggestProductScreenState();
}

class _SuggestProductScreenState extends ConsumerState<SuggestProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = '';
  String _description = '';
  double _price = 0;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    setState(() => _isLoading = true);
    try {
      await ref.read(suggestionRepositoryProvider).submitSuggestion({
        'name': _name,
        'category': _category,
        'description': _description,
        'price': _price,
      });
      Get.back();
      Get.snackbar(
        'Success', 
        'Thank you for your suggestion!', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Suggest a Product', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Have a product in mind? Let us know!', 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
              ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideX(begin: -0.2),
              const SizedBox(height: 32),
              
              _buildFuturisticField(
                label: 'Product Name',
                icon: Icons.inventory_2,
                theme: theme,
                isDark: isDark,
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => _name = v!,
              ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideY(begin: 0.2),
              
              const SizedBox(height: 20),
              
              categoriesAsync.when(
                data: (categories) {
                  final catNames = categories.map((c) => c.name).toList();
                  return Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) return catNames;
                      return catNames.where((String option) {
                        return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      _category = selection;
                    },
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                      return _buildFuturisticField(
                        controller: controller,
                        focusNode: focusNode,
                        label: 'Category (Select or type new)',
                        icon: Icons.category,
                        theme: theme,
                        isDark: isDark,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                        onSaved: (v) => _category = v!,
                      );
                    },
                  ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideY(begin: 0.2);
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => const Text('Error loading categories'),
              ),
              
              const SizedBox(height: 20),
              
              _buildFuturisticField(
                label: 'Estimated Price (Optional)',
                icon: Icons.attach_money,
                theme: theme,
                isDark: isDark,
                keyboardType: TextInputType.number,
                onSaved: (v) => _price = double.tryParse(v ?? '') ?? 0,
              ).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideY(begin: 0.2),
              
              const SizedBox(height: 20),
              
              _buildFuturisticField(
                label: 'Description',
                icon: Icons.description,
                theme: theme,
                isDark: isDark,
                maxLines: 3,
                onSaved: (v) => _description = v ?? '',
              ).animate().fadeIn(delay: const Duration(milliseconds: 500)).slideY(begin: 0.2),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: theme.colorScheme.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Submit Suggestion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 600)).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuturisticField({
    TextEditingController? controller,
    FocusNode? focusNode,
    required String label,
    required IconData icon,
    required ThemeData theme,
    required bool isDark,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        boxShadow: isDark ? [] : [
          BoxShadow(color: theme.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        style: TextStyle(fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.colorScheme.primary.withOpacity(0.8)),
          prefixIcon: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.7)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }
}
