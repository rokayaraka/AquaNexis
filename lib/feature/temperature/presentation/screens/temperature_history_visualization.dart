import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_colors.dart';
import '../../../shared/widgets/customed_no_history_logo.dart';
import '../provider/temperature_history_provider.dart';
import '../widgets/temperature_history_list.dart';
import '../widgets/temperature_history_pie_chart.dart';

class TemperatureHistoryVisualization extends StatelessWidget {
  const TemperatureHistoryVisualization({super.key});

  static const String routeName = '/temperature-history-visualization';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TemperatureHistoryProvider()..loadHistory(),
      child: const _TemperatureHistoryView(),
    );
  }
}

class _TemperatureHistoryView extends StatelessWidget {
  const _TemperatureHistoryView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TemperatureHistoryProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Temperature History',
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
      ),
      body: SafeArea(child: _buildBody(context, provider)),
    );
  }

  Widget _buildBody(BuildContext context, TemperatureHistoryProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return _ErrorView(
        message: provider.errorMessage!,
        onRetry: provider.loadHistory,
      );
    }

    if (provider.history.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.loadHistory,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            CustomedNoHistoryLogo(),
            SizedBox(height: 20),
            Center(child: Text('No temperature history available.')),
          ],
        ),
      );
    }

    return Column(
      children: [
        TemperatureHistoryPieChart(history: provider.history),
        Expanded(
          child: RefreshIndicator(
            onRefresh: provider.loadHistory,
            child: TemperatureHistoryList(history: provider.history),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
