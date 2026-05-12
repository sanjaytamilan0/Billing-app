import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/models/user_model.dart';

final staffRepositoryProvider = Provider((ref) => StaffRepository(ref.watch(dioProvider)));

class StaffRepository {
  final Dio _dio;
  StaffRepository(this._dio);

  Future<void> createStaff(String phone, String password) async {
    try {
      await _dio.post('/api/staff', data: {
        'phone': phone,
        'password': password,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getStaffList() async {
    try {
      final response = await _dio.get('/api/users');
      final List data = response.data;
      // Filter for staff only if the API returns all users
      return data
          .map((json) => UserModel.fromJson(json))
          .where((u) => u.role == 'staff')
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

final staffListProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(staffRepositoryProvider).getStaffList();
});
