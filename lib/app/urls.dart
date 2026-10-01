class Urls {
  static const String esp32RouterUrl = "http://192.168.4.1";
  static String webSocketUrl(String deviceId, String tokenId) =>
      'ws://192.168.0.113:8000/ws/device/$deviceId/'
      '?role=viewer&token=$tokenId';
}
