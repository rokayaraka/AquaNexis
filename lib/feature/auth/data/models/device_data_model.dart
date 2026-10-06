import 'package:hive/hive.dart';

class DeviceDataModel {
  final String deviceId;
  final String lastSeen;
  final String secureKey;

  DeviceDataModel({
    required this.deviceId,
    required this.lastSeen,
    required this.secureKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'last_seen': lastSeen,
      'secure_key': secureKey,
    };
  }

  factory DeviceDataModel.fromJson(Map<String, dynamic> json) {
    return DeviceDataModel(
      deviceId: json['device_id']?.toString() ?? '',
      lastSeen: json['last_seen']?.toString() ?? '',
      secureKey: json['secure_key']?.toString() ?? '',
    );
  }
}

class DeviceDataModelAdapter extends TypeAdapter<DeviceDataModel> {
  @override
  final int typeId = 1;

  @override
  DeviceDataModel read(BinaryReader reader) {
    final fields = reader.readMap();
    return DeviceDataModel(
      deviceId: fields[0]?.toString() ?? '',
      lastSeen: fields[1]?.toString() ?? '',
      secureKey: fields[2]?.toString() ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, DeviceDataModel object) {
    writer.writeMap(<int, dynamic>{
      0: object.deviceId,
      1: object.lastSeen,
      2: object.secureKey,
    });
  }
}
