import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

import '../../feature/auth/data/models/device_data_model.dart';
import '../../feature/auth/data/models/user_data_model.dart';

class AuthStorage {
  AuthStorage._();

  static const String _boxName = 'auth_box';
  static const String _userDataKey = 'user_data';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DeviceDataModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserDataModelAdapter());
    }
    await Hive.openBox<UserDataModel>(_boxName);
  }

  static String getwebSocketUrl() {
    final userData = _box.get(_userDataKey);
    return userData?.deviceWebSocketUrl ?? '';
  }

  static Box<UserDataModel> get _box => Hive.box<UserDataModel>(_boxName);

  static bool get hasUserData => userData != null;

  static UserDataModel? get userData {
    final storedData = _box.get(_userDataKey);
    return storedData;
  }

  static Future<void> saveUserData(UserDataModel userData) async {
    log('Saving user data: ${userData.toJson()}');
    await _box.put(_userDataKey, userData);
  }

  static Future<void> clear() async {
    await _box.delete(_userDataKey);
  }
}
