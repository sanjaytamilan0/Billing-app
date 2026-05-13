import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';

final categoryRepositoryProvider = Provider((ref) => CategoryRepository(ref.watch(dioProvider)));

class CategoryRepository {
  final Dio _dio;
  CategoryRepository(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('/api/categories');
      final List data = response.data;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<CategoryModel> createCategory(String name) async {
    try {
      final response = await _dio.post('/api/categories', data: {'name': name});
      return CategoryModel.fromJson(response.data['category']);
    } catch (e) {
      rethrow;
    }
  }
}

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  // Watch auth state to re-fetch when company or user changes
  ref.watch(authStateProvider);
  return ref.watch(categoryRepositoryProvider).getCategories();
});
