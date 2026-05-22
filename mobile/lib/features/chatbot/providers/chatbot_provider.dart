import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isLoading;
  ChatbotState({this.messages = const [], this.isLoading = false});

  ChatbotState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final Dio _dio;

  ChatbotNotifier(this._dio) : super(ChatbotState(messages: [
    ChatMessage(text: 'Hello! I am your AI assistant. I can help you add items to your cart, checkout, or suggest new products. How can I help you today?', isUser: false)
  ]));

  Future<String?> sendMessage(String text) async {
    if (text.trim().isEmpty) return null;

    final userMessage = ChatMessage(text: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true
    );

    try {
      print('🤖 Sending chat prompt: $text');
      final response = await _dio.post('/api/chat', data: {'prompt': text});
      print('🤖 Received chat response: ${response.data}');
      final replyText = response.data['reply'] ?? 'No response';
      
      state = state.copyWith(
        messages: [...state.messages, ChatMessage(text: replyText, isUser: false)],
        isLoading: false
      );
      return replyText;
    } on DioException catch (e) {
      print('🔴 Chatbot DioException: $e');
      print('🔴 Chatbot DioException Data: ${e.response?.data}');
      final errorMsg = e.response?.data?['message'] ?? e.response?.data?['error'] ?? e.message;
      state = state.copyWith(
        messages: [...state.messages, ChatMessage(text: 'Error: $errorMsg', isUser: false)],
        isLoading: false
      );
      return 'Error: $errorMsg';
    } catch (e, st) {
      print('🔴 Chatbot Unexpected Error: $e');
      print('🔴 Stacktrace: $st');
      state = state.copyWith(
        messages: [...state.messages, ChatMessage(text: 'Unexpected Error: $e', isUser: false)],
        isLoading: false
      );
      return 'Unexpected error occurred.';
    }
  }
}

final chatbotProvider = StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  return ChatbotNotifier(ref.watch(dioProvider));
});
