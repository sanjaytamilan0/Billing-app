import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../models/category_model.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '0');
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                icon: Icons.shopping_bag_outlined,
                validator: (val) => val!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: 'Price',
                icon: Icons.attach_money_outlined,
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Please enter price' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _quantityController,
                label: 'Initial Quantity',
                icon: Icons.inventory_outlined,
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Please enter quantity' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Category'),
              const SizedBox(height: 16),
              categoriesAsync.when(
                data: (categories) => Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: _inputDecoration('Select Category', Icons.category_outlined),
                        items: categories.map((cat) => DropdownMenuItem(
                          value: cat.name,
                          child: Text(cat.name),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedCategory = val),
                        validator: (val) => val == null ? 'Please select category' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: _showAddCategoryDialog,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF6750A4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, st) => Text('Error loading categories: $e'),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Description (Optional)'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('CREATE PRODUCT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon),
      validator: validator,
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Category Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await ref.read(categoryRepositoryProvider).createCategory(controller.text);
                  ref.invalidate(categoriesProvider);
                  Get.back();
                  Get.snackbar('Success', 'Category created');
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              }
            },
            child: const Text('CREATE'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(productsNotifierProvider.notifier).addProduct({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
        'category': _selectedCategory,
        'description': _descriptionController.text,
      });
      Get.back();
      Get.snackbar('Success', 'Product added successfully', 
        backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}
