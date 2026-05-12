import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/staff_provider.dart';

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends ConsumerState<StaffManagementScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    final staffListAsync = ref.watch(staffListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildAddStaffCard(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Text('Active Staff', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: staffListAsync.when(
                data: (staff) => _buildStaffList(staff),
                loading: () => _buildLoadingList(),
                error: (e, st) => Center(child: Text(e.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddStaffCard() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create New Staff', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_android),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Temp Password',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isCreating ? null : _handleCreateStaff,
              child: _isCreating 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Register Staff Account'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffList(List staff) {
    if (staff.isEmpty) {
      return const Center(child: Text('No staff members registered yet.'));
    }
    return ListView.builder(
      itemCount: staff.length,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (context, index) {
        final member = staff[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF6750A4).withOpacity(0.1),
              child: const Icon(Icons.person, color: Color(0xFF6750A4)),
            ),
            title: Text(member.phone, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Status: Active', style: TextStyle(color: Colors.green[700])),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  Widget _buildLoadingList() {
    return Skeletonizer(
      enabled: true,
      child: _buildStaffList(List.generate(3, (index) => null)),
    );
  }

  Future<void> _handleCreateStaff() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar('Input Required', 'Please fill in both fields');
      return;
    }

    setState(() => _isCreating = true);
    try {
      await ref.read(staffRepositoryProvider).createStaff(
        _phoneController.text,
        _passwordController.text,
      );
      _phoneController.clear();
      _passwordController.clear();
      ref.invalidate(staffListProvider);
      Get.snackbar('Success', 'Staff member added successfully');
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      setState(() => _isCreating = false);
    }
  }
}
