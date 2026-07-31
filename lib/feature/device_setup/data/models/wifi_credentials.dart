class WifiCredentials {
  final String ssid;
  final String password;
  final String? server;
  final String? deviceId;

  WifiCredentials({required this.ssid, required this.password, this.server, this.deviceId});
}