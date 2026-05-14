import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @JsonKey(name: '_id') String? id,
    required String sender,
    required String receiver,
    required String text,
    required String companyName,
    DateTime? createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

@freezed
class ChatParticipant with _$ChatParticipant {
  const factory ChatParticipant({
    @JsonKey(name: '_id') required String id,
    required String phone,
    required String role,
    required String companyName,
  }) = _ChatParticipant;

  factory ChatParticipant.fromJson(Map<String, dynamic> json) => _$ChatParticipantFromJson(json);
}
