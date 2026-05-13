import 'package:equatable/equatable.dart';
import '../models/product_model.dart';

enum ProductStatus { initial, loading, success, failed }

class ProductState extends Equatable {
  final List<ProductModel> products;
  final ProductStatus status;
  final String? errorMessage;

  const ProductState({
    this.products = const [],
    this.status = ProductStatus.initial,
    this.errorMessage,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    ProductStatus? status,
    String? errorMessage,
  }) {
    return ProductState(
      products: products ?? this.products,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [products, status, errorMessage];
}
