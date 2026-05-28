import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://billing-app-k53w.onrender.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final storage = ref.read(localStorageProvider);
        final token = storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          print('Adding Token to Header: Bearer $token');
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          ref.read(localStorageProvider).clear();
          // Ideally, trigger a logout/navigation to login
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});
