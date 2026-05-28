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
    final viewType = ref.watch(cartViewTypeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<CartViewType>(
            icon: const Icon(Icons.view_comfy_alt),
            tooltip: 'Change View Layout',
            onSelected: (type) => ref.read(cartViewTypeProvider.notifier).state = type,
            itemBuilder: (context) => const [
              PopupMenuItem(value: CartViewType.list, child: ListTile(leading: Icon(Icons.view_list), title: Text('List View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: CartViewType.grid, child: ListTile(leading: Icon(Icons.grid_view), title: Text('Grid View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: CartViewType.card, child: ListTile(leading: Icon(Icons.credit_card), title: Text('Card View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: CartViewType.page, child: ListTile(leading: Icon(Icons.view_carousel), title: Text('Page View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: CartViewType.compact, child: ListTile(leading: Icon(Icons.view_headline), title: Text('Compact View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: CartViewType.timeline, child: ListTile(leading: Icon(Icons.timeline), title: Text('Timeline View'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: CartViewType.table, child: ListTile(leading: Icon(Icons.table_chart), title: Text('Table View'), contentPadding: EdgeInsets.zero)),
            ],
          ),
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
          
          Widget content;
          switch (viewType) {
            case CartViewType.grid:
              content = _buildGridView(cart.items, theme, isDark);
              break;
            case CartViewType.card:
              content = _buildCardView(cart.items, theme, isDark);
              break;
            case CartViewType.page:
              content = _buildPageView(cart.items, theme, isDark);
              break;
            case CartViewType.compact:
              content = _buildCompactView(cart.items, theme, isDark);
              break;
            case CartViewType.timeline:
              content = _buildTimelineView(cart.items, theme, isDark);
              break;
            case CartViewType.table:
              content = _buildTableView(context, cart.items, theme, isDark);
              break;
            case CartViewType.list:
            default:
              content = _buildListView(cart.items, theme, isDark);
          }

          return Column(
            children: [
              Expanded(child: content),
              _buildCheckoutPanel(context, ref, cart, theme, isDark),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }

  // --- 7 VIEW BUILDERS ---

  Widget _buildListView(List<dynamic> items, ThemeData theme, bool isDark) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildGlassmorphicCartTile(context, item, theme, isDark),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<dynamic> items, ThemeData theme, bool isDark) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 500),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket, color: theme.colorScheme.primary, size: 40),
                      const SizedBox(height: 12),
                      Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      _buildQuantityControls(context, item),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardView(List<dynamic> items, ThemeData theme, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 24),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(child: Icon(Icons.image, size: 60, color: theme.colorScheme.primary.withOpacity(0.5))),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('\$${item.price.toStringAsFixed(2)} each', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    _buildQuantityControls(context, item),
                  ],
                ),
              ),
            ],
          ),
        ).animate().slideX();
      },
    );
  }

  Widget _buildPageView(List<dynamic> items, ThemeData theme, bool isDark) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 100, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(item.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
              const Spacer(),
              _buildQuantityControls(context, item),
            ],
          ),
        ).animate().scale();
      },
    );
  }

  Widget _buildCompactView(List<dynamic> items, ThemeData theme, bool isDark) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          dense: true,
          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              _buildQuantityControls(context, item),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineView(List<dynamic> items, ThemeData theme, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Container(width: 16, height: 16, decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle)),
                  if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.withOpacity(0.3))),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Item added to cart', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(color: theme.colorScheme.primary)),
                          const SizedBox(height: 12),
                          _buildQuantityControls(context, item),
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

  Widget _buildTableView(BuildContext context, List<dynamic> items, ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: items.map((item) {
            return DataRow(
              cells: [
                DataCell(Text(item.name)),
                DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
                DataCell(_buildQuantityControls(context, item)),
                DataCell(Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // --- REUSABLE WIDGETS ---

  Widget _buildGlassmorphicCartTile(BuildContext context, dynamic item, ThemeData theme, bool isDark) {
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
              BoxShadow(color: theme.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
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
                _buildQuantityControls(context, item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, dynamic item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 20),
                color: Colors.redAccent,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('Max', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        );
      },
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
