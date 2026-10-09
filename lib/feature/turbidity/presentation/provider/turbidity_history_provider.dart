import 'package:flutter/foundation.dart';

import '../../../../app/urls.dart';
import '../../../../core/service/network_caller/network_caller.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../data/model/turbidity_history_model.dart';

class TurbidityHistoryProvider extends ChangeNotifier {
  TurbidityHistoryProvider({NetworkCaller? networkCaller})
    : _networkCaller =
          networkCaller ??
          NetworkCaller(
            headers: () {
              final token = AuthStorage.userData?.token;
              return {
                'Content-Type': 'application/json',
                if (token != null && token.isNotEmpty)
                  'Authorization': 'Token $token',
              };
            },
          );

  final NetworkCaller _networkCaller;

  List<TurbidityHistoryModel> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TurbidityHistoryModel> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final token = AuthStorage.userData?.token;
    if (token == null || token.isEmpty) {
      _setError('Please sign in to view turbidity history.');
      return;
    }

    final response = await _networkCaller.getRequest(Urls.turbidityHistoryUrl);
    if (!response.isSuccess) {
      _setError(response.errorMessage ?? 'Unable to load turbidity history.');
      return;
    }

    try {
      _history = _parseHistory(response.body);
      _isLoading = false;
      notifyListeners();
    } on FormatException catch (error) {
      _setError('Invalid turbidity history data: ${error.message}');
    }
  }

  List<TurbidityHistoryModel> _parseHistory(dynamic body) {
    final rawItems = body is List
        ? body
        : body is Map && body['results'] is List
        ? body['results'] as List
        : body is Map && body['data'] is List
        ? body['data'] as List
        : const [];

    return rawItems
        .whereType<Map>()
        .map(
          (item) =>
              TurbidityHistoryModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  void _setError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }
}
