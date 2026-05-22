import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/product_provider.dart';
import '../providers/product_state.dart';
import '../providers/category_provider.dart';
import '../models/product_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../../core/routes/app_pages.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  bool _isBulkMode = false;
  final Map<String, int> _bulkSelections = {};

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productsNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final cartAsync = ref.watch(cartProvider);
    final user = ref.watch(authStateProvider).value;

    return categoriesAsync.when(
      data: (categories) {
        final isStaffOrOwner = user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'staff';
        final allCategories = ['All', ...categories.map((c) => c.name)];
        if (isStaffOrOwner) {
          allCategories.add('Out of Stock');
        }
        
        return DefaultTabController(
          length: allCategories.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Shop Products', style: TextStyle(fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                  icon: Icon(_isBulkMode ? Icons.close : Icons.checklist_rtl),
                  tooltip: 'Bulk Add Mode',
                  onPressed: () {
                    setState(() {
                      _isBulkMode = !_isBulkMode;
                      _bulkSelections.clear();
                    });
                  },
                ),
                IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () => Get.toNamed(Routes.cart)),
              ],
              bottom: TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 1),
                ),
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabAlignment: TabAlignment.start,
                tabs: allCategories.map((name) => Tab(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(name),
                  ),
                )).toList(),
              ),
            ),
            body: _buildBody(context, ref, productState, allCategories, user, cartAsync.value),
            floatingActionButton: _isBulkMode ? _buildBulkAddFAB() : _buildFAB(user),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: _buildErrorWidget(ref, error)),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ProductState state, List<String> allCategories, dynamic user, dynamic cart) {
    switch (state.status) {
      case ProductStatus.loading:
        return _buildLoadingList(context, ref);
      case ProductStatus.failed:
        return _buildErrorWidget(ref, state.errorMessage ?? 'Unknown error');
      case ProductStatus.success:
      case ProductStatus.initial:
        return TabBarView(
          children: allCategories.map((categoryName) {
            List<ProductModel> filteredProducts;
            if (categoryName == 'Out of Stock') {
              filteredProducts = state.products.where((p) => p.quantity <= 0).toList();
            } else if (categoryName == 'All') {
              final isStaffOrOwner = user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'staff';
              filteredProducts = isStaffOrOwner 
                ? state.products 
                : state.products.where((p) => p.quantity > 0).toList();
            } else {
              final isStaffOrOwner = user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'staff';
              filteredProducts = state.products.where((p) => p.category == categoryName).toList();
              if (!isStaffOrOwner) {
                filteredProducts = filteredProducts.where((p) => p.quantity > 0).toList();
              }
            }
            return _buildProductList(context, ref, filteredProducts, false, user, cart);
          }).toList(),
        );
    }
  }

  Widget _buildLoadingList(BuildContext context, WidgetRef ref) {
    return _buildProductList(
      context,
      ref,
      List.generate(6, (index) => ProductModel(
        id: '$index',
        productCode: '123456',
        name: 'Loading...',
        price: 0.0,
        category: 'Category',
        companyName: 'Company',
      )),
      true,
      null,
      null,
    );
  }

  Widget _buildErrorWidget(WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(productsProvider);
              ref.invalidate(categoriesProvider);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(dynamic user) {
    final isStaffOrOwner = user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'staff';
    if (!isStaffOrOwner) return const SizedBox.shrink();

    return FloatingActionButton(
      heroTag: 'add',
      onPressed: () => Get.toNamed(Routes.addProduct),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      child: const Icon(Icons.add),
    ).animate().scale(delay: const Duration(milliseconds: 200)).shimmer();
  }

  Widget _buildBulkAddFAB() {
    if (_bulkSelections.isEmpty || !_bulkSelections.values.any((qty) => qty > 0)) {
      return const SizedBox.shrink();
    }
    return FloatingActionButton.extended(
      heroTag: 'bulk_add',
      onPressed: _submitBulkAdd,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.shopping_cart_checkout),
      label: const Text('Add All to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
    ).animate().slideY(begin: 1.0, duration: const Duration(milliseconds: 300));
  }

  Future<void> _submitBulkAdd() async {
    final cartRepo = ref.read(cartRepositoryProvider);
    bool hasError = false;
    for (final entry in _bulkSelections.entries) {
      if (entry.value > 0) {
        try {
          await cartRepo.addToCart(entry.key, entry.value);
        } catch (e) {
          hasError = true;
          Get.snackbar('Error', 'Failed to add some items');
          break;
        }
      }
    }
    
    if (!hasError) {
      ref.invalidate(cartProvider);
      Get.snackbar('Success', 'Items added to cart', backgroundColor: Colors.green, colorText: Colors.white);
      setState(() {
        _bulkSelections.clear();
        _isBulkMode = false;
      });
    }
  }

  Widget _buildProductList(BuildContext context, WidgetRef ref, List<ProductModel> products, bool isLoading, dynamic user, dynamic cart) {
    if (products.isEmpty && !isLoading) {
      return const Center(child: Text('No products found in this category.'));
    }

    if (_isBulkMode) {
      // Keep bulk mode as a vertical list for easier scanning and quantity adjusting
      return Skeletonizer(
        enabled: isLoading,
        child: AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildBulkAddTile(products[index], isLoading),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    // Modern 2026 Glassmorphic Grid for standard product viewing
    return Skeletonizer(
      enabled: isLoading,
      child: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.68,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            int cartQty = 0;
            if (cart != null) {
              for (final item in cart.items) {
                if (item.productId == product.id) {
                  cartQty = item.quantity;
                  break;
                }
              }
            }
            final isStockReached = cartQty >= product.quantity;
            final favProvider = ref.read(favoritesProvider.notifier);
            final isFav = favProvider.isFavorite(product.id);

            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              duration: const Duration(milliseconds: 500),
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: _buildGlassmorphicProductCard(context, ref, product, isFav, isStockReached, isLoading, user),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlassmorphicProductCard(BuildContext context, WidgetRef ref, ProductModel product, bool isFav, bool isStockReached, bool isLoading, dynamic user) {
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
                        if (user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'staff')
                          GestureDetector(
                            onTap: () => _showUpdateQuantityDialog(context, ref, product),
                            child: const Icon(Icons.edit_note, color: Colors.blue, size: 24),
                          )
                        else if (!isStockReached && !isLoading)
                          GestureDetector(
                            onTap: () async {
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
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 16),
                            ),
                          )
                        else if (isStockReached && !isLoading)
                          const Icon(Icons.check_circle, color: Colors.green, size: 24),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isLoading)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
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

  Widget _buildBulkAddTile(ProductModel product, bool isLoading) {
    if (product.quantity <= 0) return const SizedBox.shrink();

    final currentSelected = _bulkSelections[product.id] ?? 0;
    final maxSelectable = product.quantity;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
            boxShadow: isDark ? [] : [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.inventory_2, color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text('\$${product.price.toStringAsFixed(2)} | In Stock: ${product.quantity}', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: currentSelected > 0 ? () {
                    setState(() {
                      _bulkSelections[product.id] = currentSelected - 1;
                    });
                  } : null,
                ),
                Text('$currentSelected', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: currentSelected < maxSelectable ? () {
                    setState(() {
                      _bulkSelections[product.id] = currentSelected + 1;
                    });
                  } : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showUpdateQuantityDialog(BuildContext context, WidgetRef ref, ProductModel product) async {
    final controller = TextEditingController(text: product.quantity.toString());
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Update Quantity: ${product.name}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'New Quantity',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await ref.read(productsNotifierProvider.notifier).updateQuantity(product.id, int.parse(controller.text));
                  Get.back();
                  Get.snackbar('Success', 'Quantity updated', backgroundColor: Colors.green, colorText: Colors.white);
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              }
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }
}
