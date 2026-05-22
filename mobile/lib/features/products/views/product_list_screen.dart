import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
  bool _isListView = false;
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
                  icon: Icon(_isListView ? Icons.grid_view : Icons.view_list),
                  onPressed: () {
                    setState(() {
                      _isListView = !_isListView;
                      _bulkSelections.clear();
                    });
                  },
                ),
                IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () => Get.toNamed(Routes.cart)),
              ],
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: const Color(0xFF6750A4),
                labelColor: const Color(0xFF6750A4),
                unselectedLabelColor: Colors.grey,
                tabs: allCategories.map((name) => Tab(text: name)).toList(),
              ),
            ),
            body: _buildBody(context, ref, productState, allCategories, user, cartAsync.value),
            floatingActionButton: _isListView ? _buildBulkAddFAB() : _buildFAB(user),
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
              // Owners see everything, shoppers see only available
              final isStaffOrOwner = user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'staff';
              filteredProducts = isStaffOrOwner 
                ? state.products 
                : state.products.where((p) => p.quantity > 0).toList();
            } else {
              // Specific category
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
        productCode: '1234567890123456',
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
      backgroundColor: const Color(0xFF6750A4),
      foregroundColor: Colors.white,
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBulkAddFAB() {
    if (_bulkSelections.isEmpty || !_bulkSelections.values.any((qty) => qty > 0)) {
      return const SizedBox.shrink();
    }
    return FloatingActionButton.extended(
      heroTag: 'bulk_add',
      onPressed: _submitBulkAdd,
      backgroundColor: const Color(0xFF6750A4),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.shopping_cart_checkout),
      label: const Text('Add All to Cart'),
    );
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
        _isListView = false;
      });
    }
  }

  Widget _buildProductList(BuildContext context, WidgetRef ref, List<ProductModel> products, bool isLoading, dynamic user, dynamic cart) {
    if (products.isEmpty && !isLoading) {
      return const Center(child: Text('No products found in this category.'));
    }

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
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
          
          if (_isListView) {
            return _buildBulkAddTile(product, isLoading, isStockReached);
          }

          final favProvider = ref.read(favoritesProvider.notifier);
          final isFav = favProvider.isFavorite(product.id);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6750A4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.inventory_2, color: Color(0xFF6750A4)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('${product.category} • Qty: ${product.quantity}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text('Code: ${product.productCode}',
                                style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF6750A4))),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (user?.role.toLowerCase() == 'owner' || user?.role.toLowerCase() == 'staff')
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.edit_note, color: Colors.blue),
                                  onPressed: () => _showUpdateQuantityDialog(context, ref, product),
                                ),
                              const SizedBox(width: 8),
                              if (!isStockReached && !isLoading)
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF6750A4)),
                                  onPressed: () async {
                                    try {
                                      await ref.read(cartRepositoryProvider).addToCart(product.id, 1);
                                      ref.invalidate(cartProvider);
                                      Get.snackbar('Cart', '${product.name} added to cart',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: const Color(0xFF6750A4),
                                        colorText: Colors.white,
                                      );
                                    } catch (e) {
                                      Get.snackbar('Error', e.toString());
                                    }
                                  },
                                ),
                              if (isStockReached && !isLoading)
                                const Icon(Icons.check_circle, color: Colors.green, size: 24),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isLoading)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                      onPressed: () => favProvider.toggleFavorite(product.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBulkAddTile(ProductModel product, bool isLoading, bool isStockReached) {
    if (product.quantity <= 0) return const SizedBox.shrink(); // Don't show OOS items in bulk mode

    final currentSelected = _bulkSelections[product.id] ?? 0;
    final maxSelectable = product.quantity; // Not accounting for what's already in cart for simplicity

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('\$${product.price.toStringAsFixed(2)} | In Stock: ${product.quantity}'),
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
            Text('$currentSelected', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
    );
  }

  Future<void> _showUpdateQuantityDialog(BuildContext context, WidgetRef ref, ProductModel product) async {
    final controller = TextEditingController(text: product.quantity.toString());
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Quantity: ${product.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New Quantity'),
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
