import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/routes/app_pages.dart';
import '../../auth/providers/auth_provider.dart';
import '../../products/providers/product_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../company/providers/company_provider.dart';
import '../../chatbot/views/chatbot_screen.dart';
import '../../chatbot/views/chat_list_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.chatbot),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.auto_awesome, color: Colors.white)
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2.seconds)
            .scaleXY(end: 1.1, duration: 1.seconds, curve: Curves.easeInOut)
            .then()
            .scaleXY(end: 1.0, duration: 1.seconds, curve: Curves.easeInOut),
        label: const Text('AI Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 3.seconds, color: Colors.white24)
          .elevate(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ).animate().fade(duration: 2.seconds).scale(begin: const Offset(0.8, 0.8)),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                            ).animate().fadeIn(delay: 200.ms).slideX(),
                            Text(
                              user?.phone ?? 'User',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ).animate().fadeIn(delay: 400.ms).slideX(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  _buildAnimatedGrid(context, user, ref),
                  const SizedBox(height: 32),
                  _buildRecommendations(ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedGrid(BuildContext context, user, WidgetRef ref) {
    final List<Widget> dashBoxes = [
      _buildDashBox(context, 'Products'.tr, Icons.inventory_2, const Color(0xFF8B5CF6), () => Get.toNamed(Routes.productList)),
      _buildDashBox(context, 'Cart'.tr, Icons.shopping_cart, const Color(0xFFEC4899), () => Get.toNamed(Routes.cart)),
      _buildDashBox(context, 'Favorites'.tr, Icons.favorite, const Color(0xFFF43F5E), () => Get.toNamed(Routes.favorites)),
      _buildDashBox(context, 'Orders'.tr, Icons.receipt_long, const Color(0xFFF59E0B), () => Get.toNamed(Routes.orderList)),
      if (user?.role == 'owner' || user?.role == 'super_admin')
        _buildDashBox(context, 'Staff'.tr, Icons.people, const Color(0xFF10B981), () => Get.toNamed(Routes.staffManagement)),
      if (user?.role == 'user')
        _buildDashBox(context, 'Suggest'.tr, Icons.lightbulb, const Color(0xFFEAB308), () => Get.toNamed(Routes.suggestProduct)),
      if (user?.role == 'owner' || user?.role == 'staff' || user?.role == 'super_admin')
        _buildDashBox(context, 'Review'.tr, Icons.rate_review, const Color(0xFFEAB308), () => Get.toNamed(Routes.reviewSuggestions)),
      if (user?.role == 'owner' || user?.role == 'super_admin' || user?.role == 'staff')
        _buildDashBox(context, 'Analytics'.tr, Icons.insights, const Color(0xFF3B82F6), () => Get.toNamed(Routes.analytics)),
      _buildDashBox(context, 'Profile'.tr, Icons.person, const Color(0xFF6366F1), () => Get.toNamed(Routes.profile)),
      _buildDashBox(context, 'Settings'.tr, Icons.settings, const Color(0xFF64748B), () => Get.toNamed(Routes.settings)),
    ];

    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: List.generate(
          dashBoxes.length,
          (int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: dashBoxes[index],
                ),
              ),
            );
          },
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
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: recommendationsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return const Center(child: Text('No recommendations yet'));
              }
              return AnimationLimiter(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Icon(Icons.inventory_2, size: 48, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          await ref.read(cartRepositoryProvider).addToCart(product.id, 1);
                                          Get.snackbar('Success', 'Added to cart', backgroundColor: Colors.green.withOpacity(0.9), colorText: Colors.white);
                                        } catch (e) {
                                          Get.snackbar('Error', 'Could not add to cart', backgroundColor: Colors.red.withOpacity(0.9), colorText: Colors.white);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => Skeletonizer(
              enabled: true,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onTap,
              splashColor: color.withOpacity(0.2),
              highlightColor: color.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 32, color: color),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
