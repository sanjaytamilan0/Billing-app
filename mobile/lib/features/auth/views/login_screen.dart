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
            Get.offAllNamed(Routes.products);
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
      body: SafeArea(
        child: Skeletonizer(
          enabled: authState.isLoading,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to manage your bills',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: ['super_admin', 'owner', 'staff', 'user']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.replaceAll('_', ' ').capitalizeFirst!),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedRole = val!),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          ref.read(authStateProvider.notifier).login(
                                _phoneController.text,
                                _passwordController.text,
                                _selectedRole,
                              );
                        },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed(Routes.register),
                    child: const Text('Don\'t have an account? Register'),
                  ),
                ),
                const Spacer(),
                const Divider(),
                const Text(
                  'Quick Testing (Auto-fill)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTestChip('Admin', '1234567890', 'super_admin'),
                    _buildTestChip('Owner', '9876543210', 'owner'),
                    _buildTestChip('Staff', '5555555555', 'staff'),
                    _buildTestChip('User', '0000000000', 'user'),
                  ],
                ),
              ],
            ),
          ),
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
