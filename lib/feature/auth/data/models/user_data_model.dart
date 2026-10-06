import 'package:aqua_nexis/feature/auth/data/models/device_data_model.dart';
import 'package:hive/hive.dart';

class UserDataModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? token;
  final DeviceDataModel? device;
  final String deviceWebSocketUrl;
  UserDataModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.token,
    this.device,
    required this.deviceWebSocketUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'token': token,
      if (device != null) 'device': device!.toJson(),
      'device_webSocket_url': deviceWebSocketUrl,
    };
  }

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      token: json['token']?.toString(),
      device: json['device'] != null
          ? DeviceDataModel.fromJson(
              Map<String, dynamic>.from(json['device'] as Map),
            )
          : null,
      deviceWebSocketUrl: json['device_websocket_url']?.toString() ?? '',
    );
  }
}

class UserDataModelAdapter extends TypeAdapter<UserDataModel> {
  @override
  final int typeId = 2;

  @override
  UserDataModel read(BinaryReader reader) {
    final fields = reader.readMap();
    return UserDataModel(
      id: fields[0]?.toString() ?? '',
      email: fields[1]?.toString() ?? '',
      name: fields[2]?.toString() ?? '',
      phone: fields[3]?.toString(),
      device: fields[4] is DeviceDataModel
          ? fields[4] as DeviceDataModel
          : null,
      deviceWebSocketUrl: fields[5]?.toString() ?? '',
      token: fields[6]?.toString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserDataModel object) {
    writer.writeMap(<int, dynamic>{
      0: object.id,
      1: object.email,
      2: object.name,

      3: object.phone,
      4: object.device,
      5: object.deviceWebSocketUrl,
      6: object.token,
    });
  }
}
