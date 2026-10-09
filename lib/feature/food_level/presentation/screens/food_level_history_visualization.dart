import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../../shared/widgets/customed_error_view.dart';
import '../../../shared/widgets/customed_no_history_logo.dart';
import '../provider/food_level_history_provider.dart';
import '../widgets/food_level_history_line_chart.dart';
import '../widgets/food_level_history_list.dart';

class FoodLevelHistoryVisualization extends StatelessWidget {
  const FoodLevelHistoryVisualization({super.key});

  static const String routeName = '/food-level-history-visualization';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodLevelHistoryProvider()..loadHistory(),
      child: const _FoodLevelHistoryView(),
    );
  }
}

class _FoodLevelHistoryView extends StatelessWidget {
  const _FoodLevelHistoryView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoodLevelHistoryProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Level History',
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

  Widget _buildBody(FoodLevelHistoryProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return CustomedErrorView(
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
            Center(child: Text('No food level history available.')),
          ],
        ),
      );
    }

    return Column(
      children: [
        FoodLevelHistoryLineChart(history: provider.history),
        Expanded(
          child: RefreshIndicator(
            onRefresh: provider.loadHistory,
            child: FoodLevelHistoryList(history: provider.history),
          ),
        ),
      ],
    );
  }
}
