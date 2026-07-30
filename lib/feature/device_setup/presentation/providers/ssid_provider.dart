import 'package:flutter/material.dart';

class SsidProvider extends ChangeNotifier {
  String? _ssid;

  String? get ssid => _ssid;
  
  

  void setSsid(String? newSsid) {
    _ssid = newSsid;
    notifyListeners();
  }


}