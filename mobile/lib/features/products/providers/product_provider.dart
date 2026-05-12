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
      print('Fetching products from API...');
      final response = await _dio.get('/api/products');
      print('Products API Response: ${response.data}');
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('GetProducts DioError: ${e.type} -> ${e.message}');
      if (e.response != null) {
        print('Error Response Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      print('GetProducts Unexpected Error: $e');
      rethrow;
    }
  }

  Future<void> createProduct(Map<String, dynamic> productData) async {
    try {
      print('Creating product: $productData');
      final response = await _dio.post('/api/products', data: productData);
      print('Product creation response: ${response.data}');
    } on DioException catch (e) {
      print('CreateProduct DioError: ${e.type} -> ${e.message}');
      if (e.response != null) {
        print('Error Response Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      print('CreateProduct Unexpected Error: $e');
      rethrow;
    }
  }
}

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(productRepositoryProvider).getProducts();
});
