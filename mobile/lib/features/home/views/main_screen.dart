import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../products/views/product_list_screen.dart';
import '../../orders/views/order_list_screen.dart';
import '../../auth/views/profile_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/routes/app_pages.dart';
import '../../chat/views/chat_list_screen.dart';
import '../../chat/views/chat_screen.dart';
import '../../chat/providers/chat_provider.dart';
import '../../products/providers/product_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../cart/providers/cart_provider.dart';


class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const ProductListScreen(),
    const OrderListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    print('DEBUG: Building MainScreen at index $_currentIndex');
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF6750A4),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dash'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Catalog'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.companyName ?? 'Dashboard'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              Get.offAllNamed(Routes.login);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user?.phone ?? 'User'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.role.toUpperCase() ?? '',
              style: TextStyle(color: Colors.grey[600], letterSpacing: 1.2, fontSize: 12),
            ),
            const SizedBox(height: 32),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildDashBox(
                  context,
                  'Shop Products'.tr,
                  Icons.shopping_cart,
                  Colors.blue,
                  () => Get.toNamed(Routes.products),
                ),
                _buildDashBox(
                  context,
                  'Favorites'.tr,
                  Icons.favorite,
                  Colors.red,
                  () => Get.toNamed(Routes.favorites),
                ),
                _buildDashBox(
                  context,
                  'View Orders'.tr,
                  Icons.receipt_long,
                  Colors.orange,
                  () => Get.toNamed(Routes.orderList),
                ),
                if (user?.role == 'owner' || user?.role == 'super_admin')
                  _buildDashBox(
                    context,
                    'Staff'.tr,
                    Icons.people,
                    Colors.green,
                    () => Get.toNamed(Routes.staffManagement),
                  ),
                if (user?.role == 'user')
                  _buildDashBox(
                    context,
                    'Suggest Product'.tr,
                    Icons.lightbulb,
                    Colors.amber,
                    () => Get.toNamed(Routes.suggestProduct),
                  ),
                if (user?.role == 'owner' || user?.role == 'staff' || user?.role == 'super_admin')
                  _buildDashBox(
                    context,
                    'Suggestions'.tr,
                    Icons.rate_review,
                    Colors.amber,
                    () => Get.toNamed(Routes.reviewSuggestions),
                  ),
                if (user?.role == 'owner' || user?.role == 'super_admin' || user?.role == 'staff')
                  _buildDashBox(
                    context,
                    'Analytics'.tr,
                    Icons.insights,
                    Colors.indigo,
                    () => Get.toNamed(Routes.analytics),
                  ),
                _buildDashBox(
                  context,
                  'Profile'.tr,
                  Icons.person,
                  Colors.purple,
                  () => Get.toNamed(Routes.profile),
                ),
                _buildDashBox(
                  context,
                  'Settings'.tr,
                  Icons.settings,
                  Colors.blueGrey,
                  () => Get.toNamed(Routes.settings),
                ),
                _buildDashBox(
                  context,
                  'Chat'.tr,
                  Icons.chat,
                  Colors.teal,
                  () async {
                    if (user?.role == 'owner' || user?.role == 'super_admin') {
                      Get.to(() => const ChatListScreen());
                    } else {
                      // Find owner and go to chat
                      final owner = await ref.read(companyOwnerProvider.future);
                      if (owner != null) {
                        Get.to(() => ChatScreen(
                          otherUserId: owner.id,
                          otherUserName: 'Company Owner',
                        ));
                      } else {
                        Get.snackbar('Error', 'Owner not found for this company');
                      }
                    }
                  },
                ),
              ],

            ),
            const SizedBox(height: 32),
            _buildRecommendations(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendedProductsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended For You',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: recommendationsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return const Center(child: Text('No recommendations yet'));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Icon(Icons.inventory_2, size: 40, color: Colors.purple.withOpacity(0.5)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.purple)),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  await ref.read(cartRepositoryProvider).addToCart(product.id, 1);
                                  Get.snackbar('Success', 'Added to cart');
                                } catch (e) {
                                  Get.snackbar('Error', 'Could not add to cart');
                                }
                              },
                              child: const Icon(Icons.add_circle, color: Colors.green, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => Skeletonizer(
              enabled: true,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            error: (e, st) => const Center(child: Text('Could not load recommendations')),
          ),
        ),
      ],
    );
  }

  Widget _buildDashBox(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
