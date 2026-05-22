import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/favorites_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../products/models/product_model.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No favorites yet.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: 0.2),
            );
          }

          return AnimationLimiter(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 2,
                  duration: const Duration(milliseconds: 500),
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _buildGlassmorphicFavoriteCard(context, ref, product),
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

  Widget _buildGlassmorphicFavoriteCard(BuildContext context, WidgetRef ref, ProductModel product) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : theme.colorScheme.primary.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: isDark ? [] : [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.inventory_2, size: 48, color: theme.colorScheme.primary.withOpacity(0.7)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.category} • Qty: ${product.quantity}',
                      style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: theme.colorScheme.primary),
                        ),
                        GestureDetector(
                          onTap: product.quantity > 0 ? () async {
                            try {
                              await ref.read(cartRepositoryProvider).addToCart(product.id, 1);
                              ref.invalidate(cartProvider);
                              Get.snackbar('Cart', '${product.name} added to cart',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: theme.colorScheme.primary,
                                colorText: Colors.white,
                              );
                            } catch (e) {
                              Get.snackbar('Error', e.toString());
                            }
                          } : null,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: product.quantity > 0 ? theme.colorScheme.primary : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(product.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
