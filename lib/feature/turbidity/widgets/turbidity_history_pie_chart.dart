import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/model/turbidity_history_model.dart';

class TurbidityHistoryPieChart extends StatelessWidget {
  const TurbidityHistoryPieChart({required this.history, super.key});

  final List<TurbidityHistoryModel> history;

  static const _ranges = [
    _TurbidityRange('Clean (>=3.5)', Colors.green),
    _TurbidityRange('Slightly cloudy (<3.5 & >=2.5)', Colors.yellow),
    _TurbidityRange('Cloudy (<2.5 & >=1.5)', Colors.orange),
    _TurbidityRange('Dirty (<1.5)', Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    final counts = List<int>.filled(_ranges.length, 0);
    for (final item in history) {
      counts[_rangeIndex(item.turbidity)]++;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 32,
                sections: [
                  for (var index = 0; index < _ranges.length; index++)
                    PieChartSectionData(
                      value: counts[index].toDouble(),
                      color: _ranges[index].color,
                      title: counts[index] == 0
                          ? ''
                          : '${(counts[index] / history.length * 100).round()}%',
                      radius: 58,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              for (var index = 0; index < _ranges.length; index++)
                _LegendItem(range: _ranges[index], count: counts[index]),
            ],
          ),
        ],
      ),
    );
  }

  int _rangeIndex(double turbidity) {
    if (turbidity >= 3.5) return 0;
    if (turbidity >= 2.5) return 1;
    if (turbidity >= 1.5) return 2;
    return 3;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.range, required this.count});

  final _TurbidityRange range;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: range.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text('${range.label} ($count)'),
      ],
    );
  }
}

class _TurbidityRange {
  const _TurbidityRange(this.label, this.color);

  final String label;
  final Color color;
}
