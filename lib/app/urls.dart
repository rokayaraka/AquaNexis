class Urls {
  static const String baseUrl = "http://192.168.0.113:8080";
  static const String loginUrl = "$baseUrl/api/login/";
  static const String registerUrl = "$baseUrl/api/register/";
  static const String temperatureHistoryUrl =
      "$baseUrl/api/sensors/history/?field=temperature";
  static const String turbidityHistoryUrl =
      "$baseUrl/api/sensors/history/?field=turbidity";
  static const String phHistoryUrl = "$baseUrl/api/sensors/history/?field=ph";
  static const String weightHistoryUrl =
      "$baseUrl/api/sensors/history/?field=weight";
  static String webSocketUrl(String deviceId, String tokenId) =>
      'ws://192.168.0.113:8080/ws/device/$deviceId/'
      '?role=viewer&token=$tokenId';
}

//test urls:"http://192.168.0.113:8080"
//deployed urls: "https://aquanexis-backend.onrender.com"
