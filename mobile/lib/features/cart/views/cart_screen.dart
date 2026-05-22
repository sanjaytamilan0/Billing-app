import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/cart_provider.dart';
import '../../orders/providers/order_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(cartProvider),
          ),
        ],
      ),
      body: cartAsync.when(
        data: (cart) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: 0.2),
            );
          }
          return Column(
            children: [
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _buildGlassmorphicCartTile(context, ref, item, theme, isDark),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              _buildCheckoutPanel(context, ref, cart, theme, isDark),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildGlassmorphicCartTile(BuildContext context, WidgetRef ref, dynamic item, ThemeData theme, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : theme.colorScheme.primary.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: isDark ? [] : [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1), 
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.shopping_basket, color: theme.colorScheme.primary, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        color: Colors.redAccent,
                        onPressed: () async {
                          try {
                            await ref.read(cartRepositoryProvider).updateCartItemQuantity(item.productId, item.quantity - 1);
                            ref.refresh(cartProvider);
                          } catch (e) {
                            Get.snackbar('Error', e.toString());
                          }
                        },
                      ),
                      Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (item.quantity < item.stock)
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          color: Colors.green,
                          onPressed: () async {
                            try {
                              await ref.read(cartRepositoryProvider).updateCartItemQuantity(item.productId, item.quantity + 1);
                              ref.refresh(cartProvider);
                            } catch (e) {
                              Get.snackbar('Error', e.toString());
                            }
                          },
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Max', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutPanel(BuildContext context, WidgetRef ref, dynamic cart, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12, 
            blurRadius: 20, 
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text(
                  '\$${cart.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                onPressed: () async {
                  try {
                    await ref.read(orderRepositoryProvider).createOrder();
                    ref.refresh(cartProvider);
                    Get.snackbar('Success', 'Order placed successfully', backgroundColor: Colors.green, colorText: Colors.white);
                    Get.back();
                  } catch (e) {
                    Get.snackbar('Error', e.toString());
                  }
                },
                child: const Text('Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 1.0, duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic);
  }
}
