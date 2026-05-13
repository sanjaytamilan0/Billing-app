import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/product_provider.dart';
import '../providers/product_state.dart';
import '../providers/category_provider.dart';
import '../models/product_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../../core/routes/app_pages.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productsNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final user = ref.watch(authStateProvider).value;

    return categoriesAsync.when(
      data: (categories) {
        final allCategories = ['All', ...categories.map((c) => c.name)];
        
        return DefaultTabController(
          length: allCategories.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Shop Products', style: TextStyle(fontWeight: FontWeight.bold)),
              actions: [
                IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => Get.toNamed(Routes.cart)),
                IconButton(icon: const Icon(Icons.account_circle), onPressed: () => Get.toNamed(Routes.profile)),
                if (user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'super_admin')
                  IconButton(icon: const Icon(Icons.people), onPressed: () => Get.toNamed(Routes.staffManagement)),
                IconButton(icon: const Icon(Icons.receipt_long), onPressed: () => Get.toNamed(Routes.orderList)),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await ref.read(authStateProvider.notifier).logout();
                    Get.offAllNamed(Routes.login);
                  },
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: const Color(0xFF6750A4),
                labelColor: const Color(0xFF6750A4),
                unselectedLabelColor: Colors.grey,
                tabs: allCategories.map((name) => Tab(text: name)).toList(),
              ),
            ),
            body: _buildBody(context, ref, productState, allCategories),
            floatingActionButton: _buildFAB(),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: _buildErrorWidget(ref, error)),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ProductState state, List<String> allCategories) {
    switch (state.status) {
      case ProductStatus.loading:
        return _buildLoadingList(context, ref);
      case ProductStatus.failed:
        return _buildErrorWidget(ref, state.errorMessage ?? 'Unknown error');
      case ProductStatus.success:
      case ProductStatus.initial:
        return TabBarView(
          children: allCategories.map((categoryName) {
            final filteredProducts = categoryName == 'All'
                ? state.products
                : state.products.where((p) => p.category == categoryName).toList();
            return _buildProductList(context, ref, filteredProducts, false);
          }).toList(),
        );
    }
  }

  Widget _buildLoadingList(BuildContext context, WidgetRef ref) {
    return _buildProductList(
      context,
      ref,
      List.generate(6, (index) => ProductModel(
        id: '$index',
        productCode: '1234567890123456',
        name: 'Loading...',
        price: 0.0,
        category: 'Category',
        companyName: 'Company',
      )),
      true,
    );
  }

  Widget _buildErrorWidget(WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(productsProvider);
              ref.invalidate(categoriesProvider);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'cart',
          onPressed: () => Get.toNamed(Routes.cart),
          child: const Icon(Icons.shopping_cart),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'add',
          onPressed: () => Get.toNamed(Routes.addProduct),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildProductList(BuildContext context, WidgetRef ref, List<ProductModel> products, bool isLoading) {
    if (products.isEmpty && !isLoading) {
      return const Center(child: Text('No products found in this category.'));
    }

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6750A4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.inventory_2, color: Color(0xFF6750A4)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('${product.category} • Qty: ${product.quantity}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('Code: ${product.productCode}',
                            style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF6750A4))),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'staff')
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.edit_note, color: Colors.blue),
                              onPressed: () => _showUpdateQuantityDialog(context, ref, product),
                            ),
                          const SizedBox(width: 8),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF6750A4)),
                            onPressed: () async {
                              try {
                                await ref.read(cartRepositoryProvider).addToCart(product.id, 1);
                                ref.invalidate(cartProvider);
                                Get.snackbar('Cart', '${product.name} added to cart',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: const Color(0xFF6750A4),
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                Get.snackbar('Error', e.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showUpdateQuantityDialog(BuildContext context, WidgetRef ref, ProductModel product) async {
    final controller = TextEditingController(text: product.quantity.toString());
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Quantity: ${product.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New Quantity'),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await ref.read(productsNotifierProvider.notifier).updateQuantity(product.id, int.parse(controller.text));
                  Get.back();
                  Get.snackbar('Success', 'Quantity updated', backgroundColor: Colors.green, colorText: Colors.white);
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              }
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }
  }
}
