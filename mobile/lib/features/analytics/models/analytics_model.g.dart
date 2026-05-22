// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsDashboardImpl _$$AnalyticsDashboardImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsDashboardImpl(
  summary: AnalyticsSummary.fromJson(json['summary'] as Map<String, dynamic>),
  dailyRevenue:
      (json['dailyRevenue'] as List<dynamic>?)
          ?.map((e) => DailyRevenue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  topProducts:
      (json['topProducts'] as List<dynamic>?)
          ?.map((e) => TopProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AnalyticsDashboardImplToJson(
  _$AnalyticsDashboardImpl instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'dailyRevenue': instance.dailyRevenue,
  'topProducts': instance.topProducts,
};

_$AnalyticsSummaryImpl _$$AnalyticsSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsSummaryImpl(
  totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
  totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
  pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$AnalyticsSummaryImplToJson(
  _$AnalyticsSummaryImpl instance,
) => <String, dynamic>{
  'totalRevenue': instance.totalRevenue,
  'totalOrders': instance.totalOrders,
  'pendingOrders': instance.pendingOrders,
};

_$DailyRevenueImpl _$$DailyRevenueImplFromJson(Map<String, dynamic> json) =>
    _$DailyRevenueImpl(
      date: json['_id'] as String,
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailyRevenueImplToJson(_$DailyRevenueImpl instance) =>
    <String, dynamic>{'_id': instance.date, 'revenue': instance.revenue};

_$TopProductImpl _$$TopProductImplFromJson(Map<String, dynamic> json) =>
    _$TopProductImpl(
      productId: json['_id'] as String,
      name: json['name'] as String,
      totalQuantity: (json['totalQuantity'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$TopProductImplToJson(_$TopProductImpl instance) =>
    <String, dynamic>{
      '_id': instance.productId,
      'name': instance.name,
      'totalQuantity': instance.totalQuantity,
      'totalRevenue': instance.totalRevenue,
    };
