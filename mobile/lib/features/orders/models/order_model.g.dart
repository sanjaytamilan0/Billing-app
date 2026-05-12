// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      userRole: json['userRole'] as String,
      companyName: json['companyName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'userRole': instance.userRole,
      'companyName': instance.companyName,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
