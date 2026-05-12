import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../../../core/network/dio_client.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository(ref.watch(dioProvider)));

class ProductRepository {
  final Dio _dio;
  ProductRepository(this._dio);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get('/api/products');
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(productRepositoryProvider).getProducts();
});
