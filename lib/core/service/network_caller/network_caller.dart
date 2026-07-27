import 'dart:convert';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
part 'network_response.dart';

class NetworkCaller {
  final _logger = Logger();
  final Map<String, String> Function() headers;
  NetworkCaller({required this.headers});
  //get request
  Future<NetworkResponse> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: headers());
      final response = await get(uri, headers: headers());
      _logResponse(response);
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['message'] ?? 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
      );
    }
  }

  //post request
  Future<NetworkResponse> postRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, requestBody: body, headers: headers());
      final response = await post(
        uri,
        body: jsonEncode(body),
        headers: headers(),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['message'] ?? 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
      );
    }
  }
  
  
  //put request
  Future<NetworkResponse> putRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, requestBody: body, headers: headers());
      final response = await put(
        uri,
        body: jsonEncode(body),
        headers: headers(),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['message'] ?? 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
      );
    }
  }
  
  //patch request
  Future<NetworkResponse> patchRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, requestBody: body, headers: headers());
      final response = await patch(
        uri,
        body: jsonEncode(body),
        headers: headers(),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['message'] ?? 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
      );
    }
  }
  
  
  //delete request
  Future<NetworkResponse> deleteRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, requestBody: body, headers: headers());
      final response = await delete(
        uri,
        body: jsonEncode(body),
        headers: headers(),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['message'] ?? 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
      );
    }
  }

  void _logRequest(
    String url, {
    Map<String, dynamic>? requestBody,
    Map<String, dynamic>? headers,
  }) {
    _logger.d('''URL => $url
      Headers => $headers
      Request Body => $requestBody
     ''');
  }

  void _logResponse(Response response) {
    if (response.statusCode == 200) {
      _logger.i('''Response => ${response.body}
      Status Code => ${response.statusCode}
     ''');
    } else {
      _logger.e('''Response => ${response.body}
      Status Code => ${response.statusCode}
     ''');
    }
  }
}