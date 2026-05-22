// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuggestionModelImpl _$$SuggestionModelImplFromJson(
  Map<String, dynamic> json,
) => _$SuggestionModelImpl(
  id: json['_id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble() ?? 0,
  companyName: json['companyName'] as String,
  status: json['status'] as String,
  suggestedBy: json['suggestedBy'] == null
      ? null
      : SuggestedByInfo.fromJson(json['suggestedBy'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SuggestionModelImplToJson(
  _$SuggestionModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'description': instance.description,
  'price': instance.price,
  'companyName': instance.companyName,
  'status': instance.status,
  'suggestedBy': instance.suggestedBy,
};

_$SuggestedByInfoImpl _$$SuggestedByInfoImplFromJson(
  Map<String, dynamic> json,
) => _$SuggestedByInfoImpl(
  id: json['_id'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$$SuggestedByInfoImplToJson(
  _$SuggestedByInfoImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'phone': instance.phone,
  'role': instance.role,
};
