import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/cart_provider.dart';
import '../../orders/providers/order_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
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
            return const Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(orderRepositoryProvider).createOrder();
                      ref.refresh(cartProvider);
                      Get.snackbar('Success', 'Order placed successfully');
                    } catch (e) {
                      Get.snackbar('Error', e.toString());
                    }
                  },
                  child: const Text('Checkout'),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
