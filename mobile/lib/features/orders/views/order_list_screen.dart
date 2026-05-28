import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../../../core/routes/app_pages.dart';

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final viewType = ref.watch(orderViewTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<OrderViewType>(
            icon: const Icon(Icons.view_comfy_alt),
            tooltip: 'Change View Layout',
            onSelected: (type) => ref.read(orderViewTypeProvider.notifier).state = type,
            itemBuilder: (context) => const [
              PopupMenuItem(value: OrderViewType.list, child: ListTile(leading: Icon(Icons.view_list), title: Text('List View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: OrderViewType.grid, child: ListTile(leading: Icon(Icons.grid_view), title: Text('Grid View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: OrderViewType.card, child: ListTile(leading: Icon(Icons.credit_card), title: Text('Card View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: OrderViewType.page, child: ListTile(leading: Icon(Icons.view_carousel), title: Text('Page View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: OrderViewType.compact, child: ListTile(leading: Icon(Icons.view_headline), title: Text('Compact View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: OrderViewType.timeline, child: ListTile(leading: Icon(Icons.timeline), title: Text('Timeline View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: OrderViewType.table, child: ListTile(leading: Icon(Icons.table_chart), title: Text('Table View'), contentPadding: EdgeInsets.zero)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(ordersProvider),
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) return _buildEmptyState();
          
          switch (viewType) {
            case OrderViewType.list:
              return _buildListView(orders, theme, isDark);
            case OrderViewType.grid:
              return _buildGridView(orders, theme, isDark);
            case OrderViewType.card:
              return _buildCardView(orders, theme, isDark);
            case OrderViewType.page:
              return _buildPageView(orders, theme, isDark);
            case OrderViewType.compact:
              return _buildCompactView(orders, theme, isDark);
            case OrderViewType.timeline:
              return _buildTimelineView(orders, theme, isDark);
            case OrderViewType.table:
              return _buildTableView(orders, theme, isDark);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No orders found', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ).animate().fadeIn().slideY(begin: 0.2),
    );
  }

  // 1. LIST VIEW (Original Glassmorphism)
  Widget _buildListView(List<OrderModel> orders, ThemeData theme, bool isDark) {
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
                      decoration: _glassDecoration(theme, isDark),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: _buildIcon(theme),
                        title: _buildTitleRow(order, theme),
                        subtitle: _buildSubtitle(order, status, isDark),
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
  }

  // 2. GRID VIEW
  Widget _buildGridView(List<OrderModel> orders, ThemeData theme, bool isDark) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final status = order.status.toLowerCase();
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 500),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.orderDetail, arguments: order),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _glassDecoration(theme, isDark),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIcon(theme),
                        const SizedBox(height: 16),
                        Text('#${order.id.substring(order.id.length - 6)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('\$${order.totalAmount.toStringAsFixed(2)}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),
                        _buildStatusBadge(status),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 3. CARD VIEW (Expansive)
  Widget _buildCardView(List<OrderModel> orders, ThemeData theme, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: isDark ? 0 : 8,
          shadowColor: Colors.black26,
          margin: const EdgeInsets.only(bottom: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: isDark ? Colors.grey[900] : Colors.white,
          child: InkWell(
            onTap: () => Get.toNamed(Routes.orderDetail, arguments: order),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(order.status),
                      Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Order ID: ${order.id}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Date: ${order.createdAt.toString().split(' ')[0]}', style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 32),
                  const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...order.items.take(2).map((item) => Text('• ${item.name} (x${item.quantity})')),
                  if (order.items.length > 2) Text('...and ${order.items.length - 2} more items', style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
        ).animate().slideX(delay: Duration(milliseconds: index * 100)).fadeIn();
      },
    );
  }

  // 4. PAGE VIEW (Swipeable)
  Widget _buildPageView(List<OrderModel> orders, ThemeData theme, bool isDark) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.85),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
          ),
          child: InkWell(
            onTap: () => Get.toNamed(Routes.orderDetail, arguments: order),
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag, size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 24),
                  Text('#${order.id.substring(order.id.length - 6)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildStatusBadge(order.status),
                  const Spacer(),
                  Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
                  const Spacer(),
                  const Text('Swipe for next order', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ).animate().scale(delay: Duration(milliseconds: index * 100));
      },
    );
  }

  // 5. COMPACT VIEW (Dense list)
  Widget _buildCompactView(List<OrderModel> orders, ThemeData theme, bool isDark) {
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          dense: true,
          onTap: () => Get.toNamed(Routes.orderDetail, arguments: order),
          title: Text('#${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(order.createdAt.toString().split(' ')[0]),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(_getStatusLabel(order.status), style: TextStyle(color: _getStatusColor(order.status), fontSize: 10)),
            ],
          ),
        );
      },
    );
  }

  // 6. TIMELINE VIEW
  Widget _buildTimelineView(List<OrderModel> orders, ThemeData theme, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isLast = index == orders.length - 1;
        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(color: _getStatusColor(order.status), shape: BoxShape.circle),
                  ),
                  if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.withOpacity(0.3))),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.orderDetail, arguments: order),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _glassDecoration(theme, isDark),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.createdAt.toString().split('.')[0], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          Text('Order #${order.id.substring(order.id.length - 6)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('\$${order.totalAmount.toStringAsFixed(2)}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate().slideX();
      },
    );
  }

  // 7. TABLE VIEW
  Widget _buildTableView(List<OrderModel> orders, ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: orders.map((order) {
            return DataRow(
              onSelectChanged: (_) => Get.toNamed(Routes.orderDetail, arguments: order),
              cells: [
                DataCell(Text('#${order.id.substring(order.id.length - 6)}')),
                DataCell(Text(order.createdAt.toString().split(' ')[0])),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_getStatusLabel(order.status), style: TextStyle(color: _getStatusColor(order.status), fontSize: 12)),
                  ),
                ),
                DataCell(Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            );
          }).toList(),
        ),
      ).animate().fadeIn(),
    );
  }

  // --- Reusable UI Elements ---

  BoxDecoration _glassDecoration(ThemeData theme, bool isDark) {
    return BoxDecoration(
      color: isDark ? Colors.white.withOpacity(0.05) : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : theme.colorScheme.primary.withOpacity(0.1), width: 1.5),
      boxShadow: isDark ? [] : [BoxShadow(color: theme.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
    );
  }

  Widget _buildIcon(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.receipt, color: theme.colorScheme.primary),
    );
  }

  Widget _buildTitleRow(OrderModel order, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Order #${order.id.substring(order.id.length - 6)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text('\$${order.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w900, color: theme.colorScheme.primary, fontSize: 16)),
      ],
    );
  }

  Widget _buildSubtitle(OrderModel order, String status, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Placed on ${order.createdAt.toString().split(' ')[0]}', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 12),
        _buildStatusBadge(status),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.3)),
      ),
      child: Text(
        _getStatusLabel(status),
        style: TextStyle(color: _getStatusColor(status), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
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
}
