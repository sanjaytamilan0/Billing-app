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
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Skeletonizer(
          enabled: authState.isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join Us',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Create an account to start managing your billing.'),
                const SizedBox(height: 32),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Register As'),
                  items: ['super_admin', 'owner', 'user']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.replaceAll('_', ' ').capitalizeFirst!),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedRole = val!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    prefixIcon: Icon(Icons.business),
                    hintText: 'Enter your company or shop name',
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          if (_companyController.text.isEmpty) {
                            Get.snackbar('Required', 'Company Name is required by the server');
                            return;
                          }
                          ref.read(authStateProvider.notifier).register(
                                phone: _phoneController.text,
                                password: _passwordController.text,
                                role: _selectedRole,
                                companyName: _companyController.text,
                              );
                        },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
