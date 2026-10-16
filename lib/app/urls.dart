class Urls {
  //static const String baseUrl = "https://objectives-renewable-minority-drivers.trycloudflare.com";
  static const String baseUrl =
      "https://liberal-julie-instant-pastor.trycloudflare.com";
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
      'ws://liberal-julie-instant-pastor.trycloudflare.com/ws/device/$deviceId/'
      '?role=viewer&token=$tokenId';
  // static String webSocketUrl(String deviceId, String tokenId) =>
  //     'ws://aquanexis-backend.onrender.com/ws/device/$deviceId/'
  //     '?role=viewer&token=$tokenId';
}

//test urls:"http://192.168.0.113:8080"
//deployed urls: "https://aquanexis-backend.onrender.com"
// macbook base urls:"https://jobs-exclusively-magic-trademark.trycloudflare.com"
