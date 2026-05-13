import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_model.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';

final cartRepositoryProvider = Provider((ref) => CartRepository(ref.watch(dioProvider)));

class CartRepository {
  final Dio _dio;
  CartRepository(this._dio);

  Future<CartModel> getCart() async {
    try {
      print('Fetching cart data...');
      final response = await _dio.get('/api/cart');
      print('Cart API Response: ${response.data}');
      return CartModel.fromJson(response.data);
    } on DioException catch (e) {
      print('GetCart DioError: ${e.type} -> ${e.message}');
      if (e.response != null) {
        print('Error Response Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      print('GetCart Unexpected Error: $e');
      rethrow;
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    try {
      print('Adding to cart: Product $productId, Qty $quantity');
      await _dio.post('/api/cart', data: {
        'productId': productId,
        'quantity': quantity,
      });
      print('Add to cart successful');
    } on DioException catch (e) {
      print('AddToCart DioError: ${e.type} -> ${e.message}');
      if (e.response != null) {
        print('Error Response Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      print('AddToCart Unexpected Error: $e');
      rethrow;
    }
  }

  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    try {
      await _dio.patch('/api/cart/$productId', data: {'quantity': quantity});
    } catch (e) {
      rethrow;
    }
  }
}

final cartProvider = FutureProvider<CartModel>((ref) async {
  // Watch auth state so this provider re-runs when user or company changes
  ref.watch(authStateProvider);
  return ref.watch(cartRepositoryProvider).getCart();
});
