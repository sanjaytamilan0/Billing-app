import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Suggest a Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Have a product in mind? Let us know!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: 16),
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
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Category (Select or type new)', 
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                        onSaved: (v) => _category = v!,
                      );
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => const Text('Error loading categories'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Estimated Price (Optional)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onSaved: (v) => _price = double.tryParse(v ?? '') ?? 0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                onSaved: (v) => _description = v ?? '',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Suggestion'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
