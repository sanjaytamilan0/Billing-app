import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/auth_provider.dart';
import '../../../core/routes/app_pages.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            if (user.role == 'user') {
              Get.offAllNamed(Routes.companySelection);
            } else {
              Get.offAllNamed(Routes.main);
            }
          }
        },
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Failed: $error')),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient Decor
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6750A4).withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: Skeletonizer(
              enabled: authState.isLoading,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6750A4).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.account_balance_wallet, size: 40, color: Color(0xFF6750A4)),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to your billing account',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Login as',
                        prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      items: ['super_admin', 'owner', 'staff', 'user']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role.replaceAll('_', ' ').toUpperCase(), 
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6750A4),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: const Color(0xFF6750A4).withOpacity(0.5),
                        ),
                        onPressed: authState.isLoading
                            ? null
                            : () {
                                ref.read(authStateProvider.notifier).login(
                                      _phoneController.text,
                                      _passwordController.text,
                                      _selectedRole,
                                    );
                              },
                        child: const Text('SIGN IN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.toNamed(Routes.register),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.grey),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: "Register",
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Divider(),
                    const Center(
                      child: Text(
                        'QUICK TESTING',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.5),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTestChip('Admin', '1234567890', 'super_admin'),
                          const SizedBox(width: 8),
                          _buildTestChip('Owner', '6383266215', 'owner'),
                          const SizedBox(width: 8),
                          _buildTestChip('Staff', '6383266213', 'staff'),
                          const SizedBox(width: 8),
                          _buildTestChip('User', '6383266210', 'user'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
      ),
    );
  }

  Widget _buildTestChip(String label, String phone, String role) {
    return ActionChip(
      avatar: const Icon(Icons.flash_on, size: 14, color: Colors.amber),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      onPressed: () {
        setState(() {
          _phoneController.text = phone;
          _passwordController.text = 'password'; // Common password for all test accounts
          _selectedRole = role;
        });
        Get.snackbar('Auto-filled', 'Using $label credentials', 
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
      },
    );
  }
}
