import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/suggestion_model.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';

final suggestionRepositoryProvider = Provider((ref) => SuggestionRepository(ref.watch(dioProvider)));

class SuggestionRepository {
  final Dio _dio;
  SuggestionRepository(this._dio);

  Future<void> submitSuggestion(Map<String, dynamic> data) async {
    try {
      await _dio.post('/api/suggestions', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SuggestionModel>> getPendingSuggestions() async {
    try {
      final response = await _dio.get('/api/suggestions');
      final List data = response.data;
      return data.map((json) => SuggestionModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSuggestion(String id, Map<String, dynamic> data) async {
    try {
      await _dio.put('/api/suggestions/$id', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSuggestionStatus(String id, String status) async {
    try {
      await _dio.patch('/api/suggestions/$id/status', data: {'status': status});
    } catch (e) {
      rethrow;
    }
  }
}

final pendingSuggestionsProvider = FutureProvider.autoDispose<List<SuggestionModel>>((ref) async {
  return ref.watch(suggestionRepositoryProvider).getPendingSuggestions();
});
