import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../../auth/providers/auth_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OrderModel order = Get.arguments;
    final currentUser = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Status: ${order.status.toUpperCase()}', 
              style: TextStyle(
                color: _getStatusColor(order.status),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(height: 32),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ...order.items.map((item) => ListTile(
              title: Text(item.name),
              subtitle: Text('Qty: ${item.quantity}'),
              trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
            )),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 48),
            _buildActionButtons(context, ref, order, currentUser),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'paid': return Colors.blue;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, OrderModel order, user) {
    if (user == null) return const SizedBox();

    final role = user.role.toLowerCase();
    final status = order.status.toLowerCase();

    // 1. User sees 'pending' and clicks 'Pay Now'
    if (role == 'user' && status == 'pending') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () async {
          try {
            await ref.read(orderRepositoryProvider).updateOrderStatus(order.id, 'paid');
            ref.invalidate(ordersProvider);
            Get.back();
            Get.snackbar('Payment', 'Payment successful! Order status updated to Paid.');
          } catch (e) {
            Get.snackbar('Error', e.toString());
          }
        },
        child: const Text('Pay Now'),
      );
    }

    // 2. Staff sees 'paid' and clicks 'Complete Order'
    if (role == 'staff' && status == 'paid') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
        onPressed: () async {
          try {
            await ref.read(orderRepositoryProvider).updateOrderStatus(order.id, 'completed');
            ref.invalidate(ordersProvider);
            Get.back();
            Get.snackbar('Order Update', 'Order marked as Completed by Staff.');
          } catch (e) {
            Get.snackbar('Error', e.toString());
          }
        },
        child: const Text('Complete Order'),
      );
    }

    return const SizedBox();
  }
}
