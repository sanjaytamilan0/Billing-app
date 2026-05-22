import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/suggestion_provider.dart';

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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => _category = v!,
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
