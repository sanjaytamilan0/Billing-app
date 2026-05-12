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

    if (user.role == 'user' && order.status == 'completed') {
       // Server logic says status starts as 'completed' in testing, 
       // but user wants a flow where user pays.
       // Let's allow user to click 'Pay Now' if it's not 'paid' yet.
       if (order.status != 'paid') {
         return ElevatedButton(
           onPressed: () async {
             await ref.read(orderRepositoryProvider).updateOrderStatus(order.id, 'paid');
             ref.refresh(ordersProvider);
             Get.back();
             Get.snackbar('Success', 'Order marked as Paid');
           },
           child: const Text('Pay Now'),
         );
       }
    }

    if ((user.role == 'staff' || user.role == 'owner') && order.status == 'paid') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () async {
                await ref.read(orderRepositoryProvider).updateOrderStatus(order.id, 'approved');
                ref.refresh(ordersProvider);
                Get.back();
                Get.snackbar('Success', 'Order Approved');
              },
              child: const Text('Approve & Complete'),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
