import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/favorites_provider.dart';
import '../../cart/providers/cart_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'.tr),
      ),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)} | In Stock: ${product.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF6750A4)),
                    onPressed: product.quantity > 0 ? () async {
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
                    } : null,
                  ),
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
}
