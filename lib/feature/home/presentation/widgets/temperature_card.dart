import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../app/app_colors.dart';

class TemperatureCard extends StatefulWidget {
  const TemperatureCard({
    super.key,

  });

  @override
  State<TemperatureCard> createState() => _TemperatureCardState();
}

class _TemperatureCardState extends State<TemperatureCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: _onTap,
      child: Card(
        child: Center(
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 50,
              lineWidth: 12,
              percent: 0.5,
              animation: true,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.cyan,
              backgroundColor: Colors.transparent,
              arcType: ArcType.FULL,
              arcBackgroundColor: Colors.white24,
              center:  Text(
                "50 °C",
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.textColorDarkSecondary,
                ),
              ),
            ),
            const Text(
              "Temperature",
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
  }
}