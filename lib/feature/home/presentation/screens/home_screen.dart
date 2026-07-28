import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName='/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C3035),
        title:  Text('Home',
          style:textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
        centerTitle: true,
        leadingWidth: 80,
        leading: Container(
          clipBehavior: Clip.none,
          margin: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.textColorDark,
          ),
          child:IconButton(
            icon: const Icon(Icons.person,size:18),
            color: AppColors.themeColorDark,
            onPressed: () {
              // Handle menu button press
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Text('Home Screen'),
        ),
      ),
    );
  }
}