import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../data/model/ph_history_model.dart';

class PhHistoryList extends StatelessWidget {
  const PhHistoryList({required this.history, super.key});

  final List<PhHistoryModel> history;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.textColorDarkSecondary,
                child: Icon(Icons.science, color: AppColors.themeColorDark),
              ),
              title: Text(
                item.ph.toStringAsFixed(1),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: item.recordedAt == null
                  ? null
                  : Text(_formatDate(item.recordedAt!)),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${localDate.year}-${twoDigits(localDate.month)}-${twoDigits(localDate.day)} '
        '${twoDigits(localDate.hour)}:${twoDigits(localDate.minute)}';
  }
}
