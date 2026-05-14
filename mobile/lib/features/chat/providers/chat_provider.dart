import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

final chatHistoryProvider = FutureProvider.family<List<ChatMessage>, String>((ref, otherUserId) async {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getChatHistory(otherUserId);
});

final chatParticipantsProvider = FutureProvider<List<ChatParticipant>>((ref) async {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getParticipants();
});

final companyOwnerProvider = FutureProvider<ChatParticipant?>((ref) async {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getOwner();
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatService _service;
  final String _otherUserId;

  ChatNotifier(this._service, this._otherUserId) : super([]) {
    _init();
  }

  void _init() async {
    // Load history
    final history = await _service.getChatHistory(_otherUserId);
    state = history;

    // Listen for new messages
    _service.messageStream.listen((message) {
      if ((message.sender == _otherUserId || message.receiver == _otherUserId)) {
        // Avoid duplicate messages if already in state
        if (!state.any((m) => m.id == message.id && message.id != null)) {
            state = [...state, message];
        }
      }
    });
  }

  void sendMessage(String text) {
    _service.sendMessage(_otherUserId, text);
  }
}

final chatMessagesProvider = StateNotifierProvider.family<ChatNotifier, List<ChatMessage>, String>((ref, otherUserId) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatNotifier(chatService, otherUserId);
});
