import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
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
      // 1. Process Locally with ML Kit
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      // 2. Parse Text into Key-Value Pairs
      Map<String, dynamic> extractedData = _parseRecognizedText(recognizedText.text);
      if (extractedData.isEmpty) {
        extractedData = {'RawText': recognizedText.text};
      }

      // 3. Send parsed JSON to Backend
      final response = await _dio.post('/api/ocr', data: extractedData);
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

  // Basic parser to find key-value pairs separated by colons or hyphens
  Map<String, dynamic> _parseRecognizedText(String text) {
    final Map<String, dynamic> result = {};
    final lines = text.split('\n');

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join(':').trim();
          if (key.isNotEmpty && value.isNotEmpty) {
            result[key] = value;
          }
        }
      } else if (line.contains('-')) {
        final parts = line.split('-');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('-').trim();
          // Heuristic: Ensure key is not just a number or too long
          if (key.isNotEmpty && value.isNotEmpty && key.length < 30) {
            result[key] = value;
          }
        }
      }
    }
    return result;
  }
}
