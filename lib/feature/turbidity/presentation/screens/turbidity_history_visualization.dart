import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../provider/turbidity_history_provider.dart';
import '../../widgets/turbidity_history_list.dart';
import '../../widgets/turbidity_history_pie_chart.dart';

class TurbidityHistoryVisualization extends StatelessWidget {
  const TurbidityHistoryVisualization({super.key});

  static const String routeName = '/turbidity-history-visualization';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TurbidityHistoryProvider()..loadHistory(),
      child: const _TurbidityHistoryView(),
    );
  }
}

class _TurbidityHistoryView extends StatelessWidget {
  const _TurbidityHistoryView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TurbidityHistoryProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Turbidity History',
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
      ),
      body: SafeArea(
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TurbidityHistoryProvider provider,
  ) {
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
            Center(child: Text('No turbidity history available.')),
          ],
        ),
      );
    }

    return Column(
      children: [
        TurbidityHistoryPieChart(history: provider.history),
        Expanded(
          child: RefreshIndicator(
            onRefresh: provider.loadHistory,
            child: TurbidityHistoryList(history: provider.history),
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
