import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../models/analytics_model.dart';
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
          _buildSummaryCards(data.summary),
          const SizedBox(height: 32),
          const Text('Revenue Over Time (Past 7 Days)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildRevenueChart(data.dailyRevenue),
          const SizedBox(height: 32),
          const Text('Top 5 Selling Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildTopProducts(data.topProducts),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(List<DailyRevenue> daily) {
    if (daily.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No revenue data for the past 7 days.')));
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
          maxX: (daily.length - 1).toDouble(),
          minY: 0,
          maxY: maxRevenue * 1.2, // Give some top padding
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF6750A4).withOpacity(0.1),
              child: Text('#${index + 1}', style: const TextStyle(color: Color(0xFF6750A4), fontWeight: FontWeight.bold)),
            ),
            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Qty Sold: ${p.totalQuantity}'),
            trailing: Text('\$${p.totalRevenue.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        );
      },
    );
  }
}
