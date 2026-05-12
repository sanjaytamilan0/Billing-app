// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['_id'] as String,
      productCode: json['productCode'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      companyName: json['companyName'] as String,
      description: json['description'] as String?,
      createdBy: json['createdBy'] == null
          ? null
          : CreatorInfo.fromJson(json['createdBy'] as Map<String, dynamic>),
      creatorRole: json['creatorRole'] as String?,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'productCode': instance.productCode,
      'name': instance.name,
      'price': instance.price,
      'category': instance.category,
      'companyName': instance.companyName,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'creatorRole': instance.creatorRole,
    };

_$CreatorInfoImpl _$$CreatorInfoImplFromJson(Map<String, dynamic> json) =>
    _$CreatorInfoImpl(
      id: json['_id'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$CreatorInfoImplToJson(_$CreatorInfoImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'phone': instance.phone,
      'role': instance.role,
    };
