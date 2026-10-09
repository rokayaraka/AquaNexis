import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/model/food_level_history_model.dart';

class FoodLevelHistoryLineChart extends StatelessWidget {
  const FoodLevelHistoryLineChart({required this.history, super.key});

  final List<FoodLevelHistoryModel> history;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SizedBox(
        height: 240,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 1000,
            minX: 0,
            maxX: (history.length - 1).clamp(1, double.infinity).toDouble(),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                axisNameWidget: const Text('Weight (g)'),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: _bottomTitleInterval,
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    if (index < 0 || index >= history.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      '${index + 1}',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var index = 0; index < history.length; index++)
                    FlSpot(index.toDouble(), history[index].weight),
                ],
                isCurved: true,
                color: Colors.cyan,
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.cyan.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get _bottomTitleInterval {
    if (history.length <= 5) return 1;
    return (history.length / 5).ceilToDouble();
  }
}
