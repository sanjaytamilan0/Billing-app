import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository(ref.watch(dioProvider)));

class OrderRepository {
  final Dio _dio;
  OrderRepository(this._dio);

  Future<List<OrderModel>> getOrders() async {
    try {
      print('Fetching orders...');
      final response = await _dio.get('/api/orders');
      print('Orders API Response: ${response.data}');
      final List data = response.data;
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('GetOrders DioError: ${e.response?.data}');
      final msg = e.response?.data?['message'];
      if (msg != null) throw msg;
      rethrow;
    } catch (e) {
      print('GetOrders Unexpected Error: $e');
      rethrow;
    }
  }

  Future<void> createOrder() async {
    try {
      print('Attempting checkout...');
      final response = await _dio.post('/api/orders');
      print('Checkout Response: ${response.data}');
    } on DioException catch (e) {
      print('Checkout DioError: ${e.response?.data}');
      final msg = e.response?.data?['message'];
      if (msg != null) throw msg;
      rethrow;
    } catch (e) {
      print('Checkout Unexpected Error: $e');
      rethrow;
    }
  }

  Future<String> updateOrderStatus(String orderId, String status) async {
    try {
      print('Updating order $orderId to status $status');
      final response = await _dio.put('/api/orders/$orderId/status', data: {'status': status});
      print('Update Status Response: ${response.data}');
      return response.data['message'] ?? 'Order updated successfully';
    } on DioException catch (e) {
      print('UpdateOrderStatus DioError: ${e.response?.data}');
      if (e.response?.data is Map) {
        final msg = (e.response?.data as Map)['message'];
        if (msg != null) throw msg.toString();
      } else if (e.response?.statusCode == 502) {
        throw 'Server is restarting (502). Please wait a minute and try again.';
      }
      rethrow;
    } catch (e) {
      print('UpdateOrderStatus Error: $e');
      rethrow;
    }
  }
}

final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  // Watch auth state so this provider re-runs when user or company changes
  ref.watch(authStateProvider);
  return ref.watch(orderRepositoryProvider).getOrders();
});
