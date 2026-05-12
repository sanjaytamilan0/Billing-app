import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/order_provider.dart';
import '../../../core/routes/app_pages.dart';

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(ordersProvider),
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }
          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ListTile(
                  title: Text('Order #${order.id.substring(order.id.length - 6)}'),
                  subtitle: Text('Status: ${order.status.toUpperCase()}'),
                  trailing: Text('\$${order.totalAmount.toStringAsFixed(2)}'),
                  onTap: () => Get.toNamed(Routes.orderDetail, arguments: order),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
