import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/local_storage.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(dioProvider)));

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  Future<void> register({
    required String phone,
    required String password,
    required String role,
    String? companyName,
  }) async {
    try {
      print('Attempting registration for $phone...');
      await _dio.post('/api/register', data: {
        'phone': phone,
        'password': password,
        'role': role,
        'companyName': companyName,
      });
    } on DioException catch (e) {
      print('Register DioError: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Register Unexpected Error: $e');
      rethrow;
    }
  }

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
        companyName: data['companyName'],
        permissions: List<String>.from(data['permissions'] ?? []),
        token: data['token'],
      );
    } on DioException catch (e) {
      print('Login DioError: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Login Unexpected Error: $e');
      rethrow;
    }
  }

  Future<UserModel> getMe() async {
    try {
      print('Fetching current user profile...');
      final response = await _dio.get('/api/me');
      print('Profile Response: ${response.data}');
      return UserModel.fromJson(response.data);
    } catch (e) {
      print('GetMe Error: $e');
      rethrow;
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final notifier = AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(localStorageProvider),
  );
  notifier.checkAuth();
  return notifier;
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repository;
  final LocalStorage _storage;
  AuthNotifier(this._repository, this._storage) : super(const AsyncValue.data(null));

  Future<void> checkAuth() async {
    final token = _storage.getToken();
    if (token != null) {
      try {
        state = const AsyncValue.loading();
        final user = await _repository.getMe();
        state = AsyncValue.data(user.copyWith(token: token));
        print('Auto-login: Fetched profile for ${user.phone}');
      } catch (e, st) {
        print('Auto-login failed: $e');
        await _storage.clear();
        state = const AsyncValue.data(null);
      }
    }
  }

  Future<void> register({
    required String phone,
    required String password,
    required String role,
    String? companyName,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.register(
        phone: phone,
        password: password,
        role: role,
        companyName: companyName,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String phone, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(phone, password, role);
      if (user.token != null) {
        await _storage.saveUserData(
          token: user.token!,
          role: user.role,
          phone: user.phone,
          companyName: user.companyName,
        );
      }
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _storage.clear();
    state = const AsyncValue.data(null);
  }
}
