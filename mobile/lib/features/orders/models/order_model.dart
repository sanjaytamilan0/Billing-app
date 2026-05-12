import 'package:freezed_annotation/freezed_annotation.dart';
import '../../cart/models/cart_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required String userRole,
    required String companyName,
    required List<CartItemModel> items,
    required double totalAmount,
    required String status,
    required DateTime createdAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}
