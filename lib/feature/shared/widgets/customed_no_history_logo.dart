import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../app/asset_paths.dart';

class CustomedNoHistoryLogo extends StatelessWidget {
  const CustomedNoHistoryLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(AssetPaths.historyIcon, width: 300, height: 300),
    );
  }
}
