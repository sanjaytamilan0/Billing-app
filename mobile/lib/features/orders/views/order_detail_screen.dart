import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/network/local_storage.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key});

  Future<void> _downloadInvoice(WidgetRef ref, String orderId) async {
    try {
      final token = ref.read(localStorageProvider).getToken();
      final url = Uri.parse('https://billing-app-k53w.onrender.com/api/orders/$orderId/invoice?token=$token');
      
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not launch invoice download URL');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate invoice: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OrderModel order = Get.arguments;
    final currentUser = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadInvoice(ref, order.id),
            tooltip: 'Download Invoice',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  onPressed: () => _downloadInvoice(ref, order.id),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusLabel(order.status),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
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

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return 'Waiting for Payment';
      case 'paid': return 'Paid - Processing';
      case 'completed': return 'Completed';
      case 'approved': return 'Approved';
      default: return status.toUpperCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'paid': return Colors.blue;
      case 'completed': return Colors.green;
      case 'approved': return Colors.teal;
      default: return Colors.grey;
    }
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, OrderModel order, user) {
    if (user == null) return const SizedBox();

    final role = user.role.toString().trim().toLowerCase();
    final status = order.status.toString().trim().toLowerCase();

    print('DEBUG: OrderDetail Action Check -> Role: $role, Status: $status');

    // 1. User sees 'pending' and clicks 'Pay Now'
    if (role == 'user' && status == 'pending') {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: () async {
            try {
              print('User clicking Pay Now for order ${order.id}...');
              await ref.read(orderRepositoryProvider).updateOrderStatus(order.id, 'paid');
              print('Pay Now API call finished successfully');
              ref.invalidate(ordersProvider);
              Get.back();
              Get.snackbar('Payment', 'Payment successful! Order status updated to Paid.');
            } catch (e) {
              print('Pay Now API Error: $e');
              Get.snackbar('Error', e.toString());
            }
          },
          child: const Text('Pay Now'),
        ),
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
