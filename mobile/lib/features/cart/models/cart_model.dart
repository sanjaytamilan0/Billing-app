import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
class CartModel with _$CartModel {
  const factory CartModel({
    @JsonKey(name: '_id') String? id,
    String? userId,
    String? companyName,
    @Default([]) List<CartItemModel> items,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
}

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String productId,
    required String name,
    required double price,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
}
