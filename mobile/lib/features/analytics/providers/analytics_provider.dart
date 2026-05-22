import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics_model.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';

final analyticsRepositoryProvider = Provider((ref) => AnalyticsRepository(ref.watch(dioProvider)));

class AnalyticsRepository {
  final Dio _dio;
  AnalyticsRepository(this._dio);

  Future<AnalyticsDashboard> getAnalytics() async {
    try {
      final response = await _dio.get('/api/analytics');
      return AnalyticsDashboard.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

final analyticsDashboardProvider = FutureProvider.autoDispose<AnalyticsDashboard>((ref) async {
  // Re-fetch if auth state changes
  ref.watch(authStateProvider);
  return ref.watch(analyticsRepositoryProvider).getAnalytics();
});
