import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/model/ph_history_model.dart';

class PhHistoryPieChart extends StatelessWidget {
  const PhHistoryPieChart({required this.history, super.key});

  final List<PhHistoryModel> history;

  static const _ranges = [
    _PhRange('Acidic (<6.5)', Colors.red),
    _PhRange('Normal (>=6.5 & <=7.5)', Colors.green),
    _PhRange('Alkaline (>7.5)', Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    final counts = List<int>.filled(_ranges.length, 0);
    for (final item in history) {
      counts[_rangeIndex(item.ph)]++;
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

  int _rangeIndex(double ph) {
    if (ph < 6.5) return 0;
    if (ph <= 7.5) return 1;
    return 2;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.range, required this.count});

  final _PhRange range;
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

class _PhRange {
  const _PhRange(this.label, this.color);

  final String label;
  final Color color;
}
