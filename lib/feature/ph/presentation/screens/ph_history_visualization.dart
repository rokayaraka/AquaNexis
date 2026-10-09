import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../../shared/widgets/customed_no_history_logo.dart';
import '../provider/ph_history_provider.dart';
import '../widgets/ph_history_list.dart';
import '../widgets/ph_history_pie_chart.dart';

class PhHistoryVisualization extends StatelessWidget {
  const PhHistoryVisualization({super.key});

  static const String routeName = '/ph-history-visualization';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhHistoryProvider()..loadHistory(),
      child: const _PhHistoryView(),
    );
  }
}

class _PhHistoryView extends StatelessWidget {
  const _PhHistoryView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhHistoryProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'pH History',
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
      ),
      body: SafeArea(child: _buildBody(provider)),
    );
  }

  Widget _buildBody(PhHistoryProvider provider) {
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
            Center(child: Text('No pH history available.')),
          ],
        ),
      );
    }

    return Column(
      children: [
        PhHistoryPieChart(history: provider.history),
        Expanded(
          child: RefreshIndicator(
            onRefresh: provider.loadHistory,
            child: PhHistoryList(history: provider.history),
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
