// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['_id'] as String?,
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      text: json['text'] as String,
      companyName: json['companyName'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'text': instance.text,
      'companyName': instance.companyName,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$ChatParticipantImpl _$$ChatParticipantImplFromJson(
  Map<String, dynamic> json,
) => _$ChatParticipantImpl(
  id: json['_id'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String,
  companyName: json['companyName'] as String,
);

Map<String, dynamic> _$$ChatParticipantImplToJson(
  _$ChatParticipantImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'phone': instance.phone,
  'role': instance.role,
  'companyName': instance.companyName,
};
