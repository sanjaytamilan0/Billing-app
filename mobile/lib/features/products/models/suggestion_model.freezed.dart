// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggestion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SuggestionModel _$SuggestionModelFromJson(Map<String, dynamic> json) {
  return _SuggestionModel.fromJson(json);
}

/// @nodoc
mixin _$SuggestionModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  SuggestedByInfo? get suggestedBy => throw _privateConstructorUsedError;

  /// Serializes this SuggestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestionModelCopyWith<SuggestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestionModelCopyWith<$Res> {
  factory $SuggestionModelCopyWith(
    SuggestionModel value,
    $Res Function(SuggestionModel) then,
  ) = _$SuggestionModelCopyWithImpl<$Res, SuggestionModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String category,
    String? description,
    double price,
    String companyName,
    String status,
    SuggestedByInfo? suggestedBy,
  });

  $SuggestedByInfoCopyWith<$Res>? get suggestedBy;
}

/// @nodoc
class _$SuggestionModelCopyWithImpl<$Res, $Val extends SuggestionModel>
    implements $SuggestionModelCopyWith<$Res> {
  _$SuggestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? description = freezed,
    Object? price = null,
    Object? companyName = null,
    Object? status = null,
    Object? suggestedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            suggestedBy: freezed == suggestedBy
                ? _value.suggestedBy
                : suggestedBy // ignore: cast_nullable_to_non_nullable
                      as SuggestedByInfo?,
          )
          as $Val,
    );
  }

  /// Create a copy of SuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SuggestedByInfoCopyWith<$Res>? get suggestedBy {
    if (_value.suggestedBy == null) {
      return null;
    }

    return $SuggestedByInfoCopyWith<$Res>(_value.suggestedBy!, (value) {
      return _then(_value.copyWith(suggestedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SuggestionModelImplCopyWith<$Res>
    implements $SuggestionModelCopyWith<$Res> {
  factory _$$SuggestionModelImplCopyWith(
    _$SuggestionModelImpl value,
    $Res Function(_$SuggestionModelImpl) then,
  ) = __$$SuggestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String category,
    String? description,
    double price,
    String companyName,
    String status,
    SuggestedByInfo? suggestedBy,
  });

  @override
  $SuggestedByInfoCopyWith<$Res>? get suggestedBy;
}

/// @nodoc
class __$$SuggestionModelImplCopyWithImpl<$Res>
    extends _$SuggestionModelCopyWithImpl<$Res, _$SuggestionModelImpl>
    implements _$$SuggestionModelImplCopyWith<$Res> {
  __$$SuggestionModelImplCopyWithImpl(
    _$SuggestionModelImpl _value,
    $Res Function(_$SuggestionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? description = freezed,
    Object? price = null,
    Object? companyName = null,
    Object? status = null,
    Object? suggestedBy = freezed,
  }) {
    return _then(
      _$SuggestionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        suggestedBy: freezed == suggestedBy
            ? _value.suggestedBy
            : suggestedBy // ignore: cast_nullable_to_non_nullable
                  as SuggestedByInfo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestionModelImpl implements _SuggestionModel {
  const _$SuggestionModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    required this.category,
    this.description,
    this.price = 0,
    required this.companyName,
    required this.status,
    this.suggestedBy,
  });

  factory _$SuggestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestionModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final String? description;
  @override
  @JsonKey()
  final double price;
  @override
  final String companyName;
  @override
  final String status;
  @override
  final SuggestedByInfo? suggestedBy;

  @override
  String toString() {
    return 'SuggestionModel(id: $id, name: $name, category: $category, description: $description, price: $price, companyName: $companyName, status: $status, suggestedBy: $suggestedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.suggestedBy, suggestedBy) ||
                other.suggestedBy == suggestedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    category,
    description,
    price,
    companyName,
    status,
    suggestedBy,
  );

  /// Create a copy of SuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestionModelImplCopyWith<_$SuggestionModelImpl> get copyWith =>
      __$$SuggestionModelImplCopyWithImpl<_$SuggestionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestionModelImplToJson(this);
  }
}

abstract class _SuggestionModel implements SuggestionModel {
  const factory _SuggestionModel({
    @JsonKey(name: '_id') required final String id,
    required final String name,
    required final String category,
    final String? description,
    final double price,
    required final String companyName,
    required final String status,
    final SuggestedByInfo? suggestedBy,
  }) = _$SuggestionModelImpl;

  factory _SuggestionModel.fromJson(Map<String, dynamic> json) =
      _$SuggestionModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String get category;
  @override
  String? get description;
  @override
  double get price;
  @override
  String get companyName;
  @override
  String get status;
  @override
  SuggestedByInfo? get suggestedBy;

  /// Create a copy of SuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestionModelImplCopyWith<_$SuggestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestedByInfo _$SuggestedByInfoFromJson(Map<String, dynamic> json) {
  return _SuggestedByInfo.fromJson(json);
}

/// @nodoc
mixin _$SuggestedByInfo {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this SuggestedByInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestedByInfoCopyWith<SuggestedByInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedByInfoCopyWith<$Res> {
  factory $SuggestedByInfoCopyWith(
    SuggestedByInfo value,
    $Res Function(SuggestedByInfo) then,
  ) = _$SuggestedByInfoCopyWithImpl<$Res, SuggestedByInfo>;
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String phone, String role});
}

/// @nodoc
class _$SuggestedByInfoCopyWithImpl<$Res, $Val extends SuggestedByInfo>
    implements $SuggestedByInfoCopyWith<$Res> {
  _$SuggestedByInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestedByInfo
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
abstract class _$$SuggestedByInfoImplCopyWith<$Res>
    implements $SuggestedByInfoCopyWith<$Res> {
  factory _$$SuggestedByInfoImplCopyWith(
    _$SuggestedByInfoImpl value,
    $Res Function(_$SuggestedByInfoImpl) then,
  ) = __$$SuggestedByInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String phone, String role});
}

/// @nodoc
class __$$SuggestedByInfoImplCopyWithImpl<$Res>
    extends _$SuggestedByInfoCopyWithImpl<$Res, _$SuggestedByInfoImpl>
    implements _$$SuggestedByInfoImplCopyWith<$Res> {
  __$$SuggestedByInfoImplCopyWithImpl(
    _$SuggestedByInfoImpl _value,
    $Res Function(_$SuggestedByInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuggestedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? phone = null, Object? role = null}) {
    return _then(
      _$SuggestedByInfoImpl(
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
class _$SuggestedByInfoImpl implements _SuggestedByInfo {
  const _$SuggestedByInfoImpl({
    @JsonKey(name: '_id') required this.id,
    required this.phone,
    required this.role,
  });

  factory _$SuggestedByInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestedByInfoImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String phone;
  @override
  final String role;

  @override
  String toString() {
    return 'SuggestedByInfo(id: $id, phone: $phone, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedByInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, phone, role);

  /// Create a copy of SuggestedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedByInfoImplCopyWith<_$SuggestedByInfoImpl> get copyWith =>
      __$$SuggestedByInfoImplCopyWithImpl<_$SuggestedByInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedByInfoImplToJson(this);
  }
}

abstract class _SuggestedByInfo implements SuggestedByInfo {
  const factory _SuggestedByInfo({
    @JsonKey(name: '_id') required final String id,
    required final String phone,
    required final String role,
  }) = _$SuggestedByInfoImpl;

  factory _SuggestedByInfo.fromJson(Map<String, dynamic> json) =
      _$SuggestedByInfoImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get phone;
  @override
  String get role;

  /// Create a copy of SuggestedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestedByInfoImplCopyWith<_$SuggestedByInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
