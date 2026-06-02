import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/dio_client.dart';
import '../models/ocr_document_model.dart';

final ocrProvider = StateNotifierProvider<OcrNotifier, AsyncValue<List<OcrDocument>>>((ref) {
  return OcrNotifier(ref.watch(dioProvider));
});

class OcrNotifier extends StateNotifier<AsyncValue<List<OcrDocument>>> {
  final Dio _dio;

  OcrNotifier(this._dio) : super(const AsyncValue.loading()) {
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      state = const AsyncValue.loading();
      final response = await _dio.get('/api/ocr');
      
      final docs = (response.data as List)
          .map((json) => OcrDocument.fromJson(json))
          .toList();
          
      state = AsyncValue.data(docs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<OcrDocument> processImage(XFile imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
      });

      final response = await _dio.post('/api/ocr', data: formData);
      final newDoc = OcrDocument.fromJson(response.data);
      
      // Update state with new doc
      if (state.hasValue) {
        state = AsyncValue.data([newDoc, ...state.value!]);
      }
      
      return newDoc;
    } catch (e) {
      rethrow;
    }
  }
}
