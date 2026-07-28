class SignUpParams{
  final String email;
  final String password;
  final String deviceId;
  final String name;
  final String phone;
  SignUpParams({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.name,
    required this.phone,
  });
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceId': deviceId,
      'name': name,
      'phone': phone,
    };
  }
}