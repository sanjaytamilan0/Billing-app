import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/order_provider.dart';
import '../../../core/routes/app_pages.dart';

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No orders found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: 0.2),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final order = orders[index];
                final status = order.status.toLowerCase();
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: ClipRRect(
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
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.receipt, color: theme.colorScheme.primary),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order #${order.id.substring(order.id.length - 6)}', 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    '\$${order.totalAmount.toStringAsFixed(2)}', 
                                    style: TextStyle(fontWeight: FontWeight.w900, color: theme.colorScheme.primary, fontSize: 16),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'Placed on ${order.createdAt.toString().split(' ')[0]}', 
                                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(status).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: _getStatusColor(status).withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      _getStatusLabel(status),
                                      style: TextStyle(
                                        color: _getStatusColor(status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => Get.toNamed(Routes.orderDetail, arguments: order),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending': return 'Waiting for Payment';
      case 'paid': return 'Paid - Processing';
      case 'completed': return 'Completed';
      case 'approved': return 'Approved';
      default: return status.toUpperCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'paid': return Colors.blue;
      case 'completed': return Colors.green;
      case 'approved': return Colors.teal;
      default: return Colors.grey;
    }
  }
}
