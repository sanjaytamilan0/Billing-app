import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name', prefixIcon: Icon(Icons.shopping_bag)),
                validator: (val) => val!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price', prefixIcon: Icon(Icons.attach_money)),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Please enter price' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                validator: (val) => val!.isEmpty ? 'Please enter category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Create Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(productRepositoryProvider).createProduct({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'category': _categoryController.text,
        'description': _descriptionController.text,
      });
      ref.refresh(productsProvider);
      Get.back();
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
