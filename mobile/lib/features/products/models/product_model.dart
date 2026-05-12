import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    @JsonKey(name: '_id') required String id,
    required String productCode,
    required String name,
    required double price,
    required String category,
    required String companyName,
    String? description,
    CreatorInfo? createdBy,
    String? creatorRole,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}

@freezed
class CreatorInfo with _$CreatorInfo {
  const factory CreatorInfo({
    @JsonKey(name: '_id') required String id,
    required String phone,
    required String role,
  }) = _CreatorInfo;

  factory CreatorInfo.fromJson(Map<String, dynamic> json) => _$CreatorInfoFromJson(json);
}
