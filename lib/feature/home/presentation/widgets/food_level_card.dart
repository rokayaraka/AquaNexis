// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../app/app_colors.dart';
import '../../../food_level/presentation/screens/food_level_history_visualization.dart';

class FoodLevelCard extends StatefulWidget {
  const FoodLevelCard({super.key, required this.foodLevel});
  final double foodLevel; // Example food level value, replace with actual data
  @override
  State<FoodLevelCard> createState() => _FoodLevelCardState();
}

class _FoodLevelCardState extends State<FoodLevelCard> {
  @override
  Widget build(BuildContext context) {
    final double percent =
        (widget.foodLevel > 1000
            ? 1000
            : widget.foodLevel < 0
            ? 0
            : widget.foodLevel) /
        1000; // Assuming food level is out of 100
    // log(
    //   'Food Level: ${widget.foodLevel}, Percent: $percent',
    //   name: 'FoodLevelCard',
    // );
    final textTheme = Theme.of(context).textTheme;
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
                percent: percent, // Ensure percent is between 0 and 1
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: widget.foodLevel < 200
                    ? Colors.red
                    : Colors.cyan,
                backgroundColor: Colors.transparent,
                arcType: ArcType.FULL,
                arcBackgroundColor: Colors.white24,
                center: Text(
                  "${widget.foodLevel.toStringAsFixed(1)} gm",
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.textColorDarkSecondary,
                  ),
                ),
              ),
              const Text(
                "Food Level",
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
    Navigator.pushNamed(context, FoodLevelHistoryVisualization.routeName);
  }
}
