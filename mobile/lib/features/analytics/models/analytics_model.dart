import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

@freezed
class AnalyticsDashboard with _$AnalyticsDashboard {
  const factory AnalyticsDashboard({
    required AnalyticsSummary summary,
    @Default([]) List<DailyRevenue> dailyRevenue,
    @Default([]) List<TopProduct> topProducts,
  }) = _AnalyticsDashboard;

  factory AnalyticsDashboard.fromJson(Map<String, dynamic> json) => _$AnalyticsDashboardFromJson(json);
}

@freezed
class AnalyticsSummary with _$AnalyticsSummary {
  const factory AnalyticsSummary({
    @Default(0) double totalRevenue,
    @Default(0) int totalOrders,
    @Default(0) int pendingOrders,
  }) = _AnalyticsSummary;

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) => _$AnalyticsSummaryFromJson(json);
}

@freezed
class DailyRevenue with _$DailyRevenue {
  const factory DailyRevenue({
    @JsonKey(name: '_id') required String date,
    required double revenue,
  }) = _DailyRevenue;

  factory DailyRevenue.fromJson(Map<String, dynamic> json) => _$DailyRevenueFromJson(json);
}

@freezed
class TopProduct with _$TopProduct {
  const factory TopProduct({
    @JsonKey(name: '_id') required String productId,
    required String name,
    required int totalQuantity,
    required double totalRevenue,
  }) = _TopProduct;

  factory TopProduct.fromJson(Map<String, dynamic> json) => _$TopProductFromJson(json);
}
