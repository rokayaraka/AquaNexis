class PhHistoryModel {
  const PhHistoryModel({required this.ph, this.recordedAt});

  final double ph;
  final DateTime? recordedAt;

  factory PhHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawValue = json['ph'] ?? json['value'] ?? json['reading'];
    final ph = rawValue is num
        ? rawValue.toDouble()
        : double.tryParse(rawValue?.toString().trim() ?? '');

    if (ph == null) {
      throw const FormatException('pH value is missing.');
    }

    final rawDate =
        json['timestamp'] ??
        json['recorded_at'] ??
        json['created_at'] ??
        json['datetime'] ??
        json['date'];

    return PhHistoryModel(
      ph: ph,
      recordedAt: rawDate is DateTime
          ? rawDate
          : DateTime.tryParse(rawDate?.toString() ?? ''),
    );
  }
}
