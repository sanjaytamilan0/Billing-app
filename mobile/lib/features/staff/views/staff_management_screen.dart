import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/staff_provider.dart';

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends ConsumerState<StaffManagementScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final staffListAsync = ref.watch(staffListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Staff Management')),
      body: staffListAsync.when(
        data: (staff) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Add New Staff', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                        TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password')),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await ref.read(staffRepositoryProvider).createStaff(
                                _phoneController.text,
                                _passwordController.text,
                              );
                              _phoneController.clear();
                              _passwordController.clear();
                              ref.refresh(staffListProvider);
                              Get.snackbar('Success', 'Staff created successfully');
                            } catch (e) {
                              Get.snackbar('Error', e.toString());
                            }
                          },
                          child: const Text('Create Staff'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: staff.length,
                  itemBuilder: (context, index) {
                    final member = staff[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(member.phone),
                      subtitle: Text('Role: ${member.role}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
