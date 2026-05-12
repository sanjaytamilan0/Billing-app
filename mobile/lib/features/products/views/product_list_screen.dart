import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../../core/routes/app_pages.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          if (user?.role == 'owner')
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () => Get.toNamed(Routes.staffManagement),
              tooltip: 'Staff Management',
            ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Get.toNamed(Routes.orderList),
            tooltip: 'My Orders',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              Get.offAllNamed(Routes.login);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(productsProvider),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) => _buildProductList(context, ref, products, false),
        loading: () => _buildProductList(
          context,
          ref,
          List.generate(
            6,
            (index) => ProductModel(
              id: '$index',
              productCode: '1234567890123456',
              name: 'Loading Product Name',
              price: 0.0,
              category: 'Category',
              companyName: 'Company',
            ),
          ),
          true,
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.refresh(productsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
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
      ),
    );
  }

  Widget _buildProductList(BuildContext context, WidgetRef ref, List<ProductModel> products, bool isLoading) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${product.category} • ${product.companyName}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF6750A4),
                        ),
                      ),
                      Text(
                        product.productCode,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF6750A4)),
                    onPressed: () async {
                      try {
                        await ref.read(cartRepositoryProvider).addToCart(product.id, 1);
                        ref.invalidate(cartProvider);
                        Get.snackbar('Cart', '${product.name} added to cart');
                      } catch (e) {
                        Get.snackbar('Error', e.toString());
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                // TODO: Show product details
              },
            ),
          );
        },
      ),
    );
  }
}
