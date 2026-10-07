import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../app/app_colors.dart';
import '../../../turbidity/presentation/screens/turbidity_history_visualization.dart';

class TurbidityCard extends StatefulWidget {
  const TurbidityCard({super.key, required this.turbidity});
  final double turbidity;

  @override
  State<TurbidityCard> createState() => _TurbidityCardState();
}

class _TurbidityCardState extends State<TurbidityCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double percent = ((widget.turbidity) / 5);
    return GestureDetector(
      onTap: _onTap,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 50,
                lineWidth: 12,
                percent: percent,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.cyan,
                backgroundColor: Colors.transparent,
                arcType: ArcType.FULL,
                arcBackgroundColor: Colors.white24,
                center: Text(
                  (widget.turbidity).toStringAsFixed(1),
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.textColorDarkSecondary,
                  ),
                ),
              ),
              const Text(
                "Turbidity",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    Navigator.pushNamed(context, TurbidityHistoryVisualization.routeName);
  }
}
