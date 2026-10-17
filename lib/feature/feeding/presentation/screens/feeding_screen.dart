import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class Feeding extends StatefulWidget {
  const Feeding({super.key});
  static const routeName = '/feeding';
  @override
  State<Feeding> createState() => _FeedingState();
}

class _FeedingState extends State<Feeding> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feeding',
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
        centerTitle: true,
        leadingWidth: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppColors.textColorDarkSecondary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('Feeding Screen')),
    );
  }
}
