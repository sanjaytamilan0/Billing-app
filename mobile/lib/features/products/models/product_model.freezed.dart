// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get productCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  CreatorInfo? get createdBy => throw _privateConstructorUsedError;
  String? get creatorRole => throw _privateConstructorUsedError;

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
    ProductModel value,
    $Res Function(ProductModel) then,
  ) = _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String productCode,
    String name,
    double price,
    String category,
    String companyName,
    String? description,
    CreatorInfo? createdBy,
    String? creatorRole,
  });

  $CreatorInfoCopyWith<$Res>? get createdBy;
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productCode = null,
    Object? name = null,
    Object? price = null,
    Object? category = null,
    Object? companyName = null,
    Object? description = freezed,
    Object? createdBy = freezed,
    Object? creatorRole = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productCode: null == productCode
                ? _value.productCode
                : productCode // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as CreatorInfo?,
            creatorRole: freezed == creatorRole
                ? _value.creatorRole
                : creatorRole // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatorInfoCopyWith<$Res>? get createdBy {
    if (_value.createdBy == null) {
      return null;
    }

    return $CreatorInfoCopyWith<$Res>(_value.createdBy!, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
    _$ProductModelImpl value,
    $Res Function(_$ProductModelImpl) then,
  ) = __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String productCode,
    String name,
    double price,
    String category,
    String companyName,
    String? description,
    CreatorInfo? createdBy,
    String? creatorRole,
  });

  @override
  $CreatorInfoCopyWith<$Res>? get createdBy;
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
    _$ProductModelImpl _value,
    $Res Function(_$ProductModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productCode = null,
    Object? name = null,
    Object? price = null,
    Object? category = null,
    Object? companyName = null,
    Object? description = freezed,
    Object? createdBy = freezed,
    Object? creatorRole = freezed,
  }) {
    return _then(
      _$ProductModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productCode: null == productCode
            ? _value.productCode
            : productCode // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as CreatorInfo?,
        creatorRole: freezed == creatorRole
            ? _value.creatorRole
            : creatorRole // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl implements _ProductModel {
  const _$ProductModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.productCode,
    required this.name,
    required this.price,
    required this.category,
    required this.companyName,
    this.description,
    this.createdBy,
    this.creatorRole,
  });

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String productCode;
  @override
  final String name;
  @override
  final double price;
  @override
  final String category;
  @override
  final String companyName;
  @override
  final String? description;
  @override
  final CreatorInfo? createdBy;
  @override
  final String? creatorRole;

  @override
  String toString() {
    return 'ProductModel(id: $id, productCode: $productCode, name: $name, price: $price, category: $category, companyName: $companyName, description: $description, createdBy: $createdBy, creatorRole: $creatorRole)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.creatorRole, creatorRole) ||
                other.creatorRole == creatorRole));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productCode,
    name,
    price,
    category,
    companyName,
    description,
    createdBy,
    creatorRole,
  );

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(this);
  }
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel({
    @JsonKey(name: '_id') required final String id,
    required final String productCode,
    required final String name,
    required final double price,
    required final String category,
    required final String companyName,
    final String? description,
    final CreatorInfo? createdBy,
    final String? creatorRole,
  }) = _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get productCode;
  @override
  String get name;
  @override
  double get price;
  @override
  String get category;
  @override
  String get companyName;
  @override
  String? get description;
  @override
  CreatorInfo? get createdBy;
  @override
  String? get creatorRole;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatorInfo _$CreatorInfoFromJson(Map<String, dynamic> json) {
  return _CreatorInfo.fromJson(json);
}

/// @nodoc
mixin _$CreatorInfo {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this CreatorInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatorInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatorInfoCopyWith<CreatorInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatorInfoCopyWith<$Res> {
  factory $CreatorInfoCopyWith(
    CreatorInfo value,
    $Res Function(CreatorInfo) then,
  ) = _$CreatorInfoCopyWithImpl<$Res, CreatorInfo>;
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String phone, String role});
}

/// @nodoc
class _$CreatorInfoCopyWithImpl<$Res, $Val extends CreatorInfo>
    implements $CreatorInfoCopyWith<$Res> {
  _$CreatorInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatorInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? phone = null, Object? role = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatorInfoImplCopyWith<$Res>
    implements $CreatorInfoCopyWith<$Res> {
  factory _$$CreatorInfoImplCopyWith(
    _$CreatorInfoImpl value,
    $Res Function(_$CreatorInfoImpl) then,
  ) = __$$CreatorInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String phone, String role});
}

/// @nodoc
class __$$CreatorInfoImplCopyWithImpl<$Res>
    extends _$CreatorInfoCopyWithImpl<$Res, _$CreatorInfoImpl>
    implements _$$CreatorInfoImplCopyWith<$Res> {
  __$$CreatorInfoImplCopyWithImpl(
    _$CreatorInfoImpl _value,
    $Res Function(_$CreatorInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatorInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? phone = null, Object? role = null}) {
    return _then(
      _$CreatorInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatorInfoImpl implements _CreatorInfo {
  const _$CreatorInfoImpl({
    @JsonKey(name: '_id') required this.id,
    required this.phone,
    required this.role,
  });

  factory _$CreatorInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatorInfoImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String phone;
  @override
  final String role;

  @override
  String toString() {
    return 'CreatorInfo(id: $id, phone: $phone, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatorInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, phone, role);

  /// Create a copy of CreatorInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatorInfoImplCopyWith<_$CreatorInfoImpl> get copyWith =>
      __$$CreatorInfoImplCopyWithImpl<_$CreatorInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatorInfoImplToJson(this);
  }
}

abstract class _CreatorInfo implements CreatorInfo {
  const factory _CreatorInfo({
    @JsonKey(name: '_id') required final String id,
    required final String phone,
    required final String role,
  }) = _$CreatorInfoImpl;

  factory _CreatorInfo.fromJson(Map<String, dynamic> json) =
      _$CreatorInfoImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get phone;
  @override
  String get role;

  /// Create a copy of CreatorInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatorInfoImplCopyWith<_$CreatorInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
