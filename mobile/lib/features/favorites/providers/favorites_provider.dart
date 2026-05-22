import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../products/models/product_model.dart';
import '../../auth/providers/auth_provider.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Product>>>((ref) {
  final dio = ref.watch(dioProvider);
  return FavoritesNotifier(dio);
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final Dio _dio;

  FavoritesNotifier(this._dio) : super(const AsyncValue.loading()) {
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      state = const AsyncValue.loading();
      final response = await _dio.get('/api/users/favorites');
      final List<Product> products = (response.data as List)
          .map((item) => Product.fromJson(item))
          .toList();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(String productId) async {
    // Optimistic update not easily possible without knowing the full Product object
    // if it's an addition. If it's a removal, we can optimistically remove it.
    try {
      await _dio.post('/api/users/favorites/$productId');
      await fetchFavorites(); // Refresh the list
    } catch (e) {
      // Handle error
    }
  }

  bool isFavorite(String productId) {
    if (state is AsyncData) {
      return state.value!.any((p) => p.id == productId);
    }
    return false;
  }
}
