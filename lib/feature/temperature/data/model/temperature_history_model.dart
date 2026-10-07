class TemperatureHistoryModel {
  const TemperatureHistoryModel({
    required this.temperature,
    this.recordedAt,
  });

  final double temperature;
  final DateTime? recordedAt;

  factory TemperatureHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawTemperature =
        json['temperature'] ?? json['value'] ?? json['reading'];
    final temperature = rawTemperature is num
        ? rawTemperature.toDouble()
        : double.tryParse(rawTemperature?.toString().trim() ?? '');

    if (temperature == null) {
      throw const FormatException('Temperature value is missing.');
    }

    final rawDate =
        json['timestamp'] ??
        json['recorded_at'] ??
        json['created_at'] ??
        json['datetime'] ??
        json['date'];

    return TemperatureHistoryModel(
      temperature: temperature,
      recordedAt: rawDate is DateTime
          ? rawDate
          : DateTime.tryParse(rawDate?.toString() ?? ''),
    );
  }
}
