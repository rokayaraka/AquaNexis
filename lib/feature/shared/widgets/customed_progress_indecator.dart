import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../app/asset_paths.dart';

class CustomedProgressIndecator extends StatelessWidget {
  const CustomedProgressIndecator({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Lottie.asset(
        AssetPaths.loading,
        width: 300,
        height: 300,
      ),
    );
  }
}