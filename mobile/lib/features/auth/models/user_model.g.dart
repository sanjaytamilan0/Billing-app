// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['_id'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      companyName: json['companyName'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'phone': instance.phone,
      'role': instance.role,
      'companyName': instance.companyName,
      'email': instance.email,
      'address': instance.address,
      'permissions': instance.permissions,
      'token': instance.token,
    };
