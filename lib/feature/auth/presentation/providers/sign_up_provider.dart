import 'package:flutter/foundation.dart';

import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../data/models/sign_up_params.dart';

class SignUpProvider extends ChangeNotifier {
  SignUpProvider({NetworkCaller? networkCaller})
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

  Future<bool> signUp(SignUpParams params) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    _responseBody = null;
    notifyListeners();

    final response = await _networkCaller.postRequest(
      Urls.registerUrl,
      body: params.toJson(),
    );

    _isLoading = false;
    _isSuccess = response.isSuccess;
    _responseBody = response.body;
    _errorMessage = response.isSuccess ? null : response.errorMessage;
    notifyListeners();

    return response.isSuccess;
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }
}
