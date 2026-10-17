import 'package:flutter/material.dart';

class Settigns extends StatefulWidget {
  const Settigns({super.key});
  static const routeName = '/settings';
  @override
  State<Settigns> createState() => _SettignsState();
}

class _SettignsState extends State<Settigns> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leadingWidth: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}
