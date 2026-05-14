import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/core/network/local_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/chat_model.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(localStorageProvider);
  return ChatService(dio, storage);
});

class ChatService {
  final Dio _dio;
  final LocalStorage _storage;
  IO.Socket? _socket;

  ChatService(this._dio, this._storage);

  final _messageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get messageStream => _messageController.stream;

  void connect() {
    final token = _storage.getToken();
    if (token == null) return;

    _socket = IO.io('https://billing-app-k53w.onrender.com', 
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': token})
        .enableAutoConnect()
        .build()
    );

    _socket!.onConnect((_) {
      print('Connected to Chat WebSocket');
    });

    _socket!.on('receive_message', (data) {
      final message = ChatMessage.fromJson(data);
      _messageController.add(message);
    });

    _socket!.on('message_sent', (data) {
       final message = ChatMessage.fromJson(data);
       _messageController.add(message);
    });

    _socket!.onDisconnect((_) => print('Disconnected from Chat WebSocket'));
    _socket!.onConnectError((err) => print('Chat Connect Error: $err'));
  }

  void sendMessage(String receiverId, String text) {
    if (_socket == null || !_socket!.connected) {
      print('Socket not connected');
      return;
    }
    _socket!.emit('send_message', {
      'receiverId': receiverId,
      'text': text,
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  Future<List<ChatMessage>> getChatHistory(String otherUserId) async {
    try {
      final response = await _dio.get('/api/chat/history/$otherUserId');
      return (response.data as List)
          .map((json) => ChatMessage.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }

  Future<List<ChatParticipant>> getParticipants() async {
    try {
      final response = await _dio.get('/api/chat/participants');
      return (response.data as List)
          .map((json) => ChatParticipant.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching participants: $e');
      return [];
    }
  }

  Future<ChatParticipant?> getOwner() async {
    try {
      final response = await _dio.get('/api/chat/owner');
      return ChatParticipant.fromJson(response.data);
    } catch (e) {
      print('Error fetching owner: $e');
      return null;
    }
  }
}
