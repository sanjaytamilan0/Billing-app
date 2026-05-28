import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';
import 'product_state.dart';
enum ProductViewType { list, grid, card, page, compact, timeline, table }

final productViewTypeProvider = StateProvider<ProductViewType>((ref) => ProductViewType.grid);

final productRepositoryProvider = Provider((ref) => ProductRepository(ref.watch(dioProvider)));

class ProductRepository {
  final Dio _dio;
  ProductRepository(this._dio);

  Future<List<ProductModel>> getRecommendations() async {
    try {
      final response = await _dio.get('/api/products/recommendations');
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

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

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      await _dio.patch('/api/products/$productId/quantity', data: {'quantity': quantity});
    } catch (e) {
      rethrow;
    }
  }
}



final productsNotifierProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final notifier = ProductNotifier(
    ref.watch(productRepositoryProvider),
    ref,
  );
  // Auto-fetch on initialization
  notifier.fetchProducts();
  return notifier;
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repository;
  final Ref _ref;

  ProductNotifier(this._repository, this._ref) : super(const ProductState()) {
    // Watch auth state to re-fetch when company or user changes
    _ref.listen(authStateProvider, (previous, next) {
      if (previous?.value?.companyName != next.value?.companyName || 
          previous?.value?.id != next.value?.id) {
        fetchProducts();
      }
    });
  }

  Future<void> fetchProducts() async {
    state = state.copyWith(status: ProductStatus.loading);
    try {
      final products = await _repository.getProducts();
      state = state.copyWith(
        status: ProductStatus.success,
        products: products,
      );
    } catch (e) {
      state = state.copyWith(
        status: ProductStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      await _repository.createProduct(productData);
      await fetchProducts(); // Refresh list after adding
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      await _repository.updateQuantity(productId, newQuantity);
      await fetchProducts(); // Refresh list to show new quantity
    } catch (e) {
      rethrow;
    }
  }
}

// Keep a simple accessor for convenience if needed
final productsProvider = Provider((ref) => ref.watch(productsNotifierProvider).products);

final recommendedProductsProvider = FutureProvider.autoDispose<List<ProductModel>>((ref) async {
  return ref.watch(productRepositoryProvider).getRecommendations();
});
