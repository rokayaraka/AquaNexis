import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class VideoMessage extends StatelessWidget {
  const VideoMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 4,
            strokeCap: StrokeCap.round,
            color: AppColors.themeColorLight,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
