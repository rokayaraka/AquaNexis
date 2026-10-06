class Urls {
  static const String baseUrl = "https://aquanexis-backend.onrender.com";
  static const String loginUrl = "$baseUrl/api/login/";
  static const String registerUrl = "$baseUrl/api/register/";
  static String webSocketUrl(String deviceId, String tokenId) =>
      'wss://aquanexis-backend.onrender.com/ws/device/$deviceId/'
      '?role=viewer&token=$tokenId';
}
