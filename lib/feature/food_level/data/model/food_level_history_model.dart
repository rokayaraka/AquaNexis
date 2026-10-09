class FoodLevelHistoryModel {
  const FoodLevelHistoryModel({
    required this.weight,
    this.recordedAt,
  });

  final double weight;
  final DateTime? recordedAt;

  factory FoodLevelHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawWeight = json['weight'] ?? json['value'] ?? json['reading'];
    final weight = rawWeight is num
        ? rawWeight.toDouble()
        : double.tryParse(rawWeight?.toString().trim() ?? '');

    if (weight == null) {
      throw const FormatException('Weight value is missing.');
    }

    final rawDate =
        json['timestamp'] ??
        json['recorded_at'] ??
        json['created_at'] ??
        json['datetime'] ??
        json['date'];

    return FoodLevelHistoryModel(
      weight: weight,
      recordedAt: rawDate is DateTime
          ? rawDate
          : DateTime.tryParse(rawDate?.toString() ?? ''),
    );
  }
}
