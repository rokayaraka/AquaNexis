import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../../../core/storage/auth_storage.dart';

class TemperatureHistoryVisualization extends StatefulWidget {
  const TemperatureHistoryVisualization({super.key});
  static const String routeName = '/temperature-history-visualization';

  @override
  State<TemperatureHistoryVisualization> createState() =>
      _TemperatureHistoryVisualizationState();
}

class _TemperatureHistoryVisualizationState
    extends State<TemperatureHistoryVisualization> {
  final NetworkCaller _networkCaller = NetworkCaller(
    headers: () {
      final token = AuthStorage.userData?.token;
      return {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Token $token',
      };
    },
  );

  List<_TemperatureHistoryItem> _history = [];
  bool _isLoading = true;
  String? _errorMessage;

  static const _temperatureRanges = [
    _TemperatureRange('Cold (<15°C)', Colors.blue),
    _TemperatureRange('Normal (15-23°C)', Colors.green),
    _TemperatureRange('Warm (23-25°C)', Colors.yellow),
    _TemperatureRange('Hot (>25°C)', Colors.red),
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final token = AuthStorage.userData?.token;
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please sign in to view temperature history.';
      });
      return;
    }

    final response = await _networkCaller.getRequest(
      Urls.temperatureHistoryUrl,
    );
    if (!mounted) return;

    if (!response.isSuccess) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            response.errorMessage ?? 'Unable to load temperature history.';
      });
      return;
    }

    final items = _parseHistory(response.body);
    setState(() {
      _history = items;
      _isLoading = false;
    });
  }

  List<_TemperatureHistoryItem> _parseHistory(dynamic body) {
    final rawItems = body is List
        ? body
        : body is Map && body['results'] is List
        ? body['results'] as List
        : body is Map && body['data'] is List
        ? body['data'] as List
        : const [];

    return rawItems
        .whereType<Map>()
        .map(
          (item) =>
              _TemperatureHistoryItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.temperature != null)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _loadHistory,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            : _history.isEmpty
            ? RefreshIndicator(
                onRefresh: _loadHistory,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 180),
                    Center(child: Text('No temperature history available.')),
                  ],
                ),
              )
            : Column(
                children: [
                  _buildChart(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadHistory,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      AppColors.textColorDarkSecondary,
                                  child: Icon(
                                    Icons.thermostat,
                                    color: AppColors.themeColorDark,
                                  ),
                                ),
                                title: Text(
                                  '${item.temperature!.toStringAsFixed(1)} °C',
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
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildChart() {
    final counts = List<int>.filled(_temperatureRanges.length, 0);
    for (final item in _history) {
      final temperature = item.temperature!;
      final rangeIndex = temperature < 15
          ? 0
          : temperature < 23
          ? 1
          : temperature <= 25
          ? 2
          : 3;
      counts[rangeIndex]++;
    }

    final total = _history.length;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 32,
                sections: [
                  for (
                    var index = 0;
                    index < _temperatureRanges.length;
                    index++
                  )
                    PieChartSectionData(
                      value: counts[index].toDouble(),
                      color: _temperatureRanges[index].color,
                      title: counts[index] == 0
                          ? ''
                          : '${(counts[index] / total * 100).round()}%',
                      radius: 58,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              for (var index = 0; index < _temperatureRanges.length; index++)
                _buildLegendItem(_temperatureRanges[index], counts[index]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(_TemperatureRange range, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: range.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text('${range.label} ($count)'),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${localDate.year}-${twoDigits(localDate.month)}-${twoDigits(localDate.day)} '
        '${twoDigits(localDate.hour)}:${twoDigits(localDate.minute)}';
  }
}

class _TemperatureRange {
  const _TemperatureRange(this.label, this.color);

  final String label;
  final Color color;
}

class _TemperatureHistoryItem {
  const _TemperatureHistoryItem({this.temperature, this.recordedAt});

  final double? temperature;
  final DateTime? recordedAt;

  factory _TemperatureHistoryItem.fromJson(Map<String, dynamic> json) {
    final rawTemperature =
        json['temperature'] ?? json['value'] ?? json['reading'];
    final temperature = rawTemperature is num
        ? rawTemperature.toDouble()
        : double.tryParse(rawTemperature?.toString().trim() ?? '');
    final rawDate =
        json['timestamp'] ??
        json['recorded_at'] ??
        json['created_at'] ??
        json['datetime'] ??
        json['date'];

    return _TemperatureHistoryItem(
      temperature: temperature,
      recordedAt: rawDate is DateTime
          ? rawDate
          : DateTime.tryParse(rawDate?.toString() ?? ''),
    );
  }
}
