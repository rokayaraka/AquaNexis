import 'package:aqua_nexis/feature/home/presentation/providers/sensor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../widgets/video_message.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: AspectRatio(
                aspectRatio: 12 / 9,
                child: StreamBuilder(
                  stream: videoStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const VideoMessage(
                        message: 'Video stream unavailable',
                      );
                    }

                    final frame = snapshot.data;
                    if (frame == null) {
                      return const VideoMessage(
                        message: 'Waiting for video...',
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        frame,
                        width: double.infinity,

                        fit: BoxFit.fill,

                        gaplessPlayback: true,
                        errorBuilder: (context, error, stackTrace) =>
                            const VideoMessage(
                              message: 'Unable to display video frame',
                            ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
