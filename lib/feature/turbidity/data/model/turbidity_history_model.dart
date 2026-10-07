class TurbidityHistoryModel {
  const TurbidityHistoryModel({
    required this.turbidity,
    this.recordedAt,
  });

  final double turbidity;
  final DateTime? recordedAt;

  factory TurbidityHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawValue = json['turbidity'] ?? json['value'] ?? json['reading'];
    final turbidity = rawValue is num
        ? rawValue.toDouble()
        : double.tryParse(rawValue?.toString().trim() ?? '');

    if (turbidity == null) {
      throw const FormatException('Turbidity value is missing.');
    }

    final rawDate =
        json['timestamp'] ??
        json['recorded_at'] ??
        json['created_at'] ??
        json['datetime'] ??
        json['date'];

    return TurbidityHistoryModel(
      turbidity: turbidity,
      recordedAt: rawDate is DateTime
          ? rawDate
          : DateTime.tryParse(rawDate?.toString() ?? ''),
    );
  }
}
