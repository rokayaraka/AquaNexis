import 'package:flutter/foundation.dart';

import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../data/models/user_data_model.dart';
import '../../data/models/sign_in_params.dart';

class SignInProvider extends ChangeNotifier {
  SignInProvider({NetworkCaller? networkCaller})
    : _networkCaller =
          networkCaller ??
          NetworkCaller(
            headers: () => <String, String>{'Content-Type': 'application/json'},
          );

  final NetworkCaller _networkCaller;

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;
  dynamic _responseBody;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;
  dynamic get responseBody => _responseBody;

  Future<bool> signIn(SignInParams params) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    _responseBody = null;
    notifyListeners();

    final response = await _networkCaller.postRequest(
      Urls.loginUrl,
      body: params.toJson(),
    );

    _isLoading = false;
    _isSuccess = response.isSuccess;
    _responseBody = response.body;
    _errorMessage = response.isSuccess ? null : response.errorMessage;
    if (response.isSuccess) {
      final responseBody = response.body;
      if (responseBody is! Map) {
        _isSuccess = false;
        _errorMessage = 'Invalid user data received from the server.';
      } else {
        final userData = UserDataModel.fromJson(
          Map<String, dynamic>.from(responseBody),
        );
        await AuthStorage.saveUserData(userData);
      }
    }
    notifyListeners();

    return _isSuccess;
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }
}
