import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../core/routes/app_pages.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/local_storage.dart';
import '../../auth/providers/auth_provider.dart';

class CompanySelectionScreen extends ConsumerStatefulWidget {
  const CompanySelectionScreen({super.key});

  @override
  ConsumerState<CompanySelectionScreen> createState() => _CompanySelectionScreenState();
}

class _CompanySelectionScreenState extends ConsumerState<CompanySelectionScreen> {
  List<String> _companies = [];
  String? _selectedCompany;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    try {
      final response = await ref.read(dioProvider).get('/api/public/companies');
      setState(() {
        _companies = List<String>.from(response.data);
        _isLoading = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch shops: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubmit() async {
    if (_selectedCompany == null) {
      Get.snackbar('Required', 'Please select a shop first');
      return;
    }

    // Save selected company to local storage for persistence
    await ref.read(localStorageProvider).saveCompanyName(_selectedCompany!);
    
    // Also update the auth state so components know which company is active
    ref.read(authStateProvider.notifier).updateUserCompany(_selectedCompany!);

    Get.offAllNamed(Routes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6750A4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.storefront, size: 40, color: Color(0xFF6750A4)),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please select the shop you want to browse today.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 48),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_companies.isEmpty)
                const Center(child: Text('No shops found.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _companies.length,
                    itemBuilder: (context, index) {
                      final company = _companies[index];
                      final isSelected = _selectedCompany == company;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6750A4).withOpacity(0.05) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF6750A4) : Colors.grey[200]!,
                            width: 2,
                          ),
                        ),
                        child: RadioListTile<String>(
                          value: company,
                          groupValue: _selectedCompany,
                          title: Text(
                            company,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? const Color(0xFF6750A4) : Colors.black87,
                            ),
                          ),
                          onChanged: (val) => setState(() => _selectedCompany = val),
                          activeColor: const Color(0xFF6750A4),
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: const Text('SUBMIT & PROCEED', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
