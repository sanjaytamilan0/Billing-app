// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalyticsDashboard _$AnalyticsDashboardFromJson(Map<String, dynamic> json) {
  return _AnalyticsDashboard.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsDashboard {
  AnalyticsSummary get summary => throw _privateConstructorUsedError;
  List<DailyRevenue> get dailyRevenue => throw _privateConstructorUsedError;
  List<TopProduct> get topProducts => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDashboardCopyWith<AnalyticsDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDashboardCopyWith<$Res> {
  factory $AnalyticsDashboardCopyWith(
    AnalyticsDashboard value,
    $Res Function(AnalyticsDashboard) then,
  ) = _$AnalyticsDashboardCopyWithImpl<$Res, AnalyticsDashboard>;
  @useResult
  $Res call({
    AnalyticsSummary summary,
    List<DailyRevenue> dailyRevenue,
    List<TopProduct> topProducts,
  });

  $AnalyticsSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$AnalyticsDashboardCopyWithImpl<$Res, $Val extends AnalyticsDashboard>
    implements $AnalyticsDashboardCopyWith<$Res> {
  _$AnalyticsDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? dailyRevenue = null,
    Object? topProducts = null,
  }) {
    return _then(
      _value.copyWith(
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as AnalyticsSummary,
            dailyRevenue: null == dailyRevenue
                ? _value.dailyRevenue
                : dailyRevenue // ignore: cast_nullable_to_non_nullable
                      as List<DailyRevenue>,
            topProducts: null == topProducts
                ? _value.topProducts
                : topProducts // ignore: cast_nullable_to_non_nullable
                      as List<TopProduct>,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsSummaryCopyWith<$Res> get summary {
    return $AnalyticsSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsDashboardImplCopyWith<$Res>
    implements $AnalyticsDashboardCopyWith<$Res> {
  factory _$$AnalyticsDashboardImplCopyWith(
    _$AnalyticsDashboardImpl value,
    $Res Function(_$AnalyticsDashboardImpl) then,
  ) = __$$AnalyticsDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AnalyticsSummary summary,
    List<DailyRevenue> dailyRevenue,
    List<TopProduct> topProducts,
  });

  @override
  $AnalyticsSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$AnalyticsDashboardImplCopyWithImpl<$Res>
    extends _$AnalyticsDashboardCopyWithImpl<$Res, _$AnalyticsDashboardImpl>
    implements _$$AnalyticsDashboardImplCopyWith<$Res> {
  __$$AnalyticsDashboardImplCopyWithImpl(
    _$AnalyticsDashboardImpl _value,
    $Res Function(_$AnalyticsDashboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? dailyRevenue = null,
    Object? topProducts = null,
  }) {
    return _then(
      _$AnalyticsDashboardImpl(
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as AnalyticsSummary,
        dailyRevenue: null == dailyRevenue
            ? _value._dailyRevenue
            : dailyRevenue // ignore: cast_nullable_to_non_nullable
                  as List<DailyRevenue>,
        topProducts: null == topProducts
            ? _value._topProducts
            : topProducts // ignore: cast_nullable_to_non_nullable
                  as List<TopProduct>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDashboardImpl implements _AnalyticsDashboard {
  const _$AnalyticsDashboardImpl({
    required this.summary,
    final List<DailyRevenue> dailyRevenue = const [],
    final List<TopProduct> topProducts = const [],
  }) : _dailyRevenue = dailyRevenue,
       _topProducts = topProducts;

  factory _$AnalyticsDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDashboardImplFromJson(json);

  @override
  final AnalyticsSummary summary;
  final List<DailyRevenue> _dailyRevenue;
  @override
  @JsonKey()
  List<DailyRevenue> get dailyRevenue {
    if (_dailyRevenue is EqualUnmodifiableListView) return _dailyRevenue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyRevenue);
  }

  final List<TopProduct> _topProducts;
  @override
  @JsonKey()
  List<TopProduct> get topProducts {
    if (_topProducts is EqualUnmodifiableListView) return _topProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topProducts);
  }

  @override
  String toString() {
    return 'AnalyticsDashboard(summary: $summary, dailyRevenue: $dailyRevenue, topProducts: $topProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDashboardImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._dailyRevenue,
              _dailyRevenue,
            ) &&
            const DeepCollectionEquality().equals(
              other._topProducts,
              _topProducts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    summary,
    const DeepCollectionEquality().hash(_dailyRevenue),
    const DeepCollectionEquality().hash(_topProducts),
  );

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDashboardImplCopyWith<_$AnalyticsDashboardImpl> get copyWith =>
      __$$AnalyticsDashboardImplCopyWithImpl<_$AnalyticsDashboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDashboardImplToJson(this);
  }
}

abstract class _AnalyticsDashboard implements AnalyticsDashboard {
  const factory _AnalyticsDashboard({
    required final AnalyticsSummary summary,
    final List<DailyRevenue> dailyRevenue,
    final List<TopProduct> topProducts,
  }) = _$AnalyticsDashboardImpl;

  factory _AnalyticsDashboard.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDashboardImpl.fromJson;

  @override
  AnalyticsSummary get summary;
  @override
  List<DailyRevenue> get dailyRevenue;
  @override
  List<TopProduct> get topProducts;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDashboardImplCopyWith<_$AnalyticsDashboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsSummary _$AnalyticsSummaryFromJson(Map<String, dynamic> json) {
  return _AnalyticsSummary.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsSummary {
  double get totalRevenue => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  int get pendingOrders => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsSummaryCopyWith<AnalyticsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsSummaryCopyWith<$Res> {
  factory $AnalyticsSummaryCopyWith(
    AnalyticsSummary value,
    $Res Function(AnalyticsSummary) then,
  ) = _$AnalyticsSummaryCopyWithImpl<$Res, AnalyticsSummary>;
  @useResult
  $Res call({double totalRevenue, int totalOrders, int pendingOrders});
}

/// @nodoc
class _$AnalyticsSummaryCopyWithImpl<$Res, $Val extends AnalyticsSummary>
    implements $AnalyticsSummaryCopyWith<$Res> {
  _$AnalyticsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? pendingOrders = null,
  }) {
    return _then(
      _value.copyWith(
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingOrders: null == pendingOrders
                ? _value.pendingOrders
                : pendingOrders // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsSummaryImplCopyWith<$Res>
    implements $AnalyticsSummaryCopyWith<$Res> {
  factory _$$AnalyticsSummaryImplCopyWith(
    _$AnalyticsSummaryImpl value,
    $Res Function(_$AnalyticsSummaryImpl) then,
  ) = __$$AnalyticsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double totalRevenue, int totalOrders, int pendingOrders});
}

/// @nodoc
class __$$AnalyticsSummaryImplCopyWithImpl<$Res>
    extends _$AnalyticsSummaryCopyWithImpl<$Res, _$AnalyticsSummaryImpl>
    implements _$$AnalyticsSummaryImplCopyWith<$Res> {
  __$$AnalyticsSummaryImplCopyWithImpl(
    _$AnalyticsSummaryImpl _value,
    $Res Function(_$AnalyticsSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? pendingOrders = null,
  }) {
    return _then(
      _$AnalyticsSummaryImpl(
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingOrders: null == pendingOrders
            ? _value.pendingOrders
            : pendingOrders // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsSummaryImpl implements _AnalyticsSummary {
  const _$AnalyticsSummaryImpl({
    this.totalRevenue = 0,
    this.totalOrders = 0,
    this.pendingOrders = 0,
  });

  factory _$AnalyticsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsSummaryImplFromJson(json);

  @override
  @JsonKey()
  final double totalRevenue;
  @override
  @JsonKey()
  final int totalOrders;
  @override
  @JsonKey()
  final int pendingOrders;

  @override
  String toString() {
    return 'AnalyticsSummary(totalRevenue: $totalRevenue, totalOrders: $totalOrders, pendingOrders: $pendingOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsSummaryImpl &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.pendingOrders, pendingOrders) ||
                other.pendingOrders == pendingOrders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalRevenue, totalOrders, pendingOrders);

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsSummaryImplCopyWith<_$AnalyticsSummaryImpl> get copyWith =>
      __$$AnalyticsSummaryImplCopyWithImpl<_$AnalyticsSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsSummaryImplToJson(this);
  }
}

abstract class _AnalyticsSummary implements AnalyticsSummary {
  const factory _AnalyticsSummary({
    final double totalRevenue,
    final int totalOrders,
    final int pendingOrders,
  }) = _$AnalyticsSummaryImpl;

  factory _AnalyticsSummary.fromJson(Map<String, dynamic> json) =
      _$AnalyticsSummaryImpl.fromJson;

  @override
  double get totalRevenue;
  @override
  int get totalOrders;
  @override
  int get pendingOrders;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsSummaryImplCopyWith<_$AnalyticsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyRevenue _$DailyRevenueFromJson(Map<String, dynamic> json) {
  return _DailyRevenue.fromJson(json);
}

/// @nodoc
mixin _$DailyRevenue {
  @JsonKey(name: '_id')
  String get date => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this DailyRevenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyRevenueCopyWith<DailyRevenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRevenueCopyWith<$Res> {
  factory $DailyRevenueCopyWith(
    DailyRevenue value,
    $Res Function(DailyRevenue) then,
  ) = _$DailyRevenueCopyWithImpl<$Res, DailyRevenue>;
  @useResult
  $Res call({@JsonKey(name: '_id') String date, double revenue});
}

/// @nodoc
class _$DailyRevenueCopyWithImpl<$Res, $Val extends DailyRevenue>
    implements $DailyRevenueCopyWith<$Res> {
  _$DailyRevenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? revenue = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyRevenueImplCopyWith<$Res>
    implements $DailyRevenueCopyWith<$Res> {
  factory _$$DailyRevenueImplCopyWith(
    _$DailyRevenueImpl value,
    $Res Function(_$DailyRevenueImpl) then,
  ) = __$$DailyRevenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String date, double revenue});
}

/// @nodoc
class __$$DailyRevenueImplCopyWithImpl<$Res>
    extends _$DailyRevenueCopyWithImpl<$Res, _$DailyRevenueImpl>
    implements _$$DailyRevenueImplCopyWith<$Res> {
  __$$DailyRevenueImplCopyWithImpl(
    _$DailyRevenueImpl _value,
    $Res Function(_$DailyRevenueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? revenue = null}) {
    return _then(
      _$DailyRevenueImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRevenueImpl implements _DailyRevenue {
  const _$DailyRevenueImpl({
    @JsonKey(name: '_id') required this.date,
    required this.revenue,
  });

  factory _$DailyRevenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRevenueImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String date;
  @override
  final double revenue;

  @override
  String toString() {
    return 'DailyRevenue(date: $date, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRevenueImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, revenue);

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRevenueImplCopyWith<_$DailyRevenueImpl> get copyWith =>
      __$$DailyRevenueImplCopyWithImpl<_$DailyRevenueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRevenueImplToJson(this);
  }
}

abstract class _DailyRevenue implements DailyRevenue {
  const factory _DailyRevenue({
    @JsonKey(name: '_id') required final String date,
    required final double revenue,
  }) = _$DailyRevenueImpl;

  factory _DailyRevenue.fromJson(Map<String, dynamic> json) =
      _$DailyRevenueImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get date;
  @override
  double get revenue;

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyRevenueImplCopyWith<_$DailyRevenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopProduct _$TopProductFromJson(Map<String, dynamic> json) {
  return _TopProduct.fromJson(json);
}

/// @nodoc
mixin _$TopProduct {
  @JsonKey(name: '_id')
  String get productId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;

  /// Serializes this TopProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopProductCopyWith<TopProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopProductCopyWith<$Res> {
  factory $TopProductCopyWith(
    TopProduct value,
    $Res Function(TopProduct) then,
  ) = _$TopProductCopyWithImpl<$Res, TopProduct>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String productId,
    String name,
    int totalQuantity,
    double totalRevenue,
  });
}

/// @nodoc
class _$TopProductCopyWithImpl<$Res, $Val extends TopProduct>
    implements $TopProductCopyWith<$Res> {
  _$TopProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? name = null,
    Object? totalQuantity = null,
    Object? totalRevenue = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            totalQuantity: null == totalQuantity
                ? _value.totalQuantity
                : totalQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopProductImplCopyWith<$Res>
    implements $TopProductCopyWith<$Res> {
  factory _$$TopProductImplCopyWith(
    _$TopProductImpl value,
    $Res Function(_$TopProductImpl) then,
  ) = __$$TopProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String productId,
    String name,
    int totalQuantity,
    double totalRevenue,
  });
}

/// @nodoc
class __$$TopProductImplCopyWithImpl<$Res>
    extends _$TopProductCopyWithImpl<$Res, _$TopProductImpl>
    implements _$$TopProductImplCopyWith<$Res> {
  __$$TopProductImplCopyWithImpl(
    _$TopProductImpl _value,
    $Res Function(_$TopProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? name = null,
    Object? totalQuantity = null,
    Object? totalRevenue = null,
  }) {
    return _then(
      _$TopProductImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        totalQuantity: null == totalQuantity
            ? _value.totalQuantity
            : totalQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopProductImpl implements _TopProduct {
  const _$TopProductImpl({
    @JsonKey(name: '_id') required this.productId,
    required this.name,
    required this.totalQuantity,
    required this.totalRevenue,
  });

  factory _$TopProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopProductImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String productId;
  @override
  final String name;
  @override
  final int totalQuantity;
  @override
  final double totalRevenue;

  @override
  String toString() {
    return 'TopProduct(productId: $productId, name: $name, totalQuantity: $totalQuantity, totalRevenue: $totalRevenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, name, totalQuantity, totalRevenue);

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopProductImplCopyWith<_$TopProductImpl> get copyWith =>
      __$$TopProductImplCopyWithImpl<_$TopProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopProductImplToJson(this);
  }
}

abstract class _TopProduct implements TopProduct {
  const factory _TopProduct({
    @JsonKey(name: '_id') required final String productId,
    required final String name,
    required final int totalQuantity,
    required final double totalRevenue,
  }) = _$TopProductImpl;

  factory _TopProduct.fromJson(Map<String, dynamic> json) =
      _$TopProductImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get productId;
  @override
  String get name;
  @override
  int get totalQuantity;
  @override
  double get totalRevenue;

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopProductImplCopyWith<_$TopProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
