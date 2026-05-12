import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();
  String _selectedRole = 'user';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (previous?.isLoading == true) {
            Get.back(); // Go back to login
            Get.snackbar('Success', 'Account created! Please login.');
          }
        },
        error: (error, stack) {
          Get.snackbar('Error', error.toString());
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
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
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Join Us',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create an account to start managing your billing.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
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
                        labelText: 'Register As',
                        prefixIcon: const Icon(Icons.person_outline),
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
                      items: ['super_admin', 'owner', 'user']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role.replaceAll('_', ' ').toUpperCase(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _companyController,
                      label: 'Company Name',
                      icon: Icons.business_outlined,
                      hint: 'e.g. ABC Store',
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
                                if (_companyController.text.isEmpty) {
                                  Get.snackbar('Required', 'Company Name is required');
                                  return;
                                }
                                ref.read(authStateProvider.notifier).register(
                                      phone: _phoneController.text,
                                      password: _passwordController.text,
                                      role: _selectedRole,
                                      companyName: _companyController.text,
                                    );
                              },
                        child: const Text('CREATE ACCOUNT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.grey),
                            children: [
                              const TextSpan(text: "Already have an account? "),
                              TextSpan(
                                text: "Login",
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
    String? hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
}
