import 'package:aqua_nexis/feature/home/presentation/providers/sensor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';

class LiveMonitoring extends StatefulWidget {
  const LiveMonitoring({super.key});

  static const String routeName = '/live-monitoring';

  @override
  State<LiveMonitoring> createState() => _LiveMonitoringState();
}

class _LiveMonitoringState extends State<LiveMonitoring> {
  @override
  Widget build(BuildContext context) {
    final videoStream = context.read<SensorProvider>().videoStream;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C3035),
        title: Text(
          'Live Monitoring',
          style: textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
      ),

      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: StreamBuilder(
            stream: videoStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const _VideoMessage('Video stream unavailable');
              }

              final frame = snapshot.data;
              if (frame == null) {
                return const _VideoMessage('Waiting for video...');
              }

              return Image.memory(
                frame,
                fit: BoxFit.contain,
                
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) =>
                    const _VideoMessage('Unable to display video frame'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VideoMessage extends StatelessWidget {
  const _VideoMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.white70)),
    );
  }
}
