import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../models/analytics_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(analyticsDashboardProvider),
          ),
        ],
      ),
      body: analyticsAsync.when(
        data: (data) => _buildDashboard(context, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AnalyticsDashboard data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(data.summary).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: 0.1),
          const SizedBox(height: 32),
          const Text('Revenue Over Time (Last 30 Active Days)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideY(begin: 0.1),
          const SizedBox(height: 16),
          _buildRevenueChart(data.dailyRevenue).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideY(begin: 0.1),
          const SizedBox(height: 32),
          const Text('Top 5 Selling Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideY(begin: 0.1),
          const SizedBox(height: 16),
          _buildTopProducts(data.topProducts).animate().fadeIn(delay: const Duration(milliseconds: 500)).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(AnalyticsSummary summary) {
    return Row(
      children: [
        Expanded(child: _buildCard('Revenue', '\$${summary.totalRevenue.toStringAsFixed(2)}', Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _buildCard('Orders', '${summary.totalOrders}', Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildCard('Pending', '${summary.pendingOrders}', Colors.orange)),
      ],
    );
  }

  Widget _buildCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(List<DailyRevenue> daily) {
    if (daily.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No revenue data available.')));
    }

    List<FlSpot> spots = [];
    double maxRevenue = 0;

    for (int i = 0; i < daily.length; i++) {
      spots.add(FlSpot(i.toDouble(), daily[i].revenue));
      if (daily[i].revenue > maxRevenue) maxRevenue = daily[i].revenue;
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < daily.length) {
                    // Try parsing date YYYY-MM-DD
                    try {
                      final date = DateTime.parse(daily[value.toInt()].date);
                      return Padding(
                        padding:  EdgeInsets.only(top: 8.0),
                        child: Text(DateFormat('Md').format(date), style: const TextStyle(fontSize: 10)),
                      );
                    } catch (_) {
                      return Text(daily[value.toInt()].date, style: const TextStyle(fontSize: 10));
                    }
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: daily.length > 1 ? (daily.length - 1).toDouble() : 1.0,
          minY: 0,
          maxY: maxRevenue == 0 ? 10 : maxRevenue * 1.2, // Give some top padding
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF6750A4),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF6750A4).withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts(List<TopProduct> products) {
    if (products.isEmpty) {
      return const Text('No sales data available yet.');
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFF7C3AED).withOpacity(0.1)),
            dataRowHeight: 60,
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)))),
              DataColumn(label: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Revenue', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: List.generate(products.length, (index) {
              final p = products[index];
              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(Text('${p.totalQuantity}')),
                  DataCell(Text('\$${p.totalRevenue.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
