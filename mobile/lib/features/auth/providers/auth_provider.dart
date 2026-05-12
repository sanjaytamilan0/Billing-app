import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../../core/network/dio_client.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(dioProvider)));

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  Future<UserModel> login(String phone, String password, String role) async {
    try {
      print('Attempting login for $phone with role $role...');
      final response = await _dio.post('/api/login', data: {
        'phone': phone,
        'password': password,
        'role': role,
      });
      
      print('Login successful for $phone');
      final data = response.data;
      return UserModel(
        id: data['userId'],
        phone: phone,
        role: data['role'],
        permissions: List<String>.from(data['permissions'] ?? []),
        token: data['token'],
      );
    } on DioException catch (e) {
      print('Login DioError: ${e.type} -> ${e.message}');
      if (e.response != null) {
        print('Error Response Data: ${e.response?.data}');
        print('Error Response Status: ${e.response?.statusCode}');
      }
      rethrow;
    } catch (e) {
      print('Login Unexpected Error: $e');
      rethrow;
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repository;
  AuthNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> login(String phone, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(phone, password, role);
      state = AsyncValue.data(user);
    } catch (e, st) {
      print('AuthNotifier Error: $e');
      state = AsyncValue.error(e, st);
    }
  }
}
