import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_url.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpRequestClient {
  static const int _timeoutSeconds = 30;
  SharedPreferences? _preferences;

  // Singleton pattern for better performance
  static final HttpRequestClient _instance = HttpRequestClient._internal();
  factory HttpRequestClient() => _instance;
  HttpRequestClient._internal();

  /// Get shared preferences instance
  Future<SharedPreferences> get preferences async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  /// Get authentication token from shared preferences
  Future<String?> getToken() async {
    final prefs = await preferences;
    return prefs.getString(AppSharedPreferenceKey.kSetPrefToken);
  }

  /// Build common headers for requests
  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? additionalHeaders,
    bool isMultipart = false,
  }) async {
    final headers = <String, String>{
      'Connection': 'Keep-Alive',
      'Accept': 'application/json',
    };

    if (isMultipart) {
      headers['Content-Type'] = 'multipart/form-data';
    }

    // Add authorization token if available
    final token = await getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Add additional headers if provided
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Log request details
  void _logRequest({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    List<http.MultipartFile>? files,
  }) {
    log("==== $method REQUEST ====");
    log("URL: $url");
    if (body != null) log("BODY $url: ${jsonEncode(body)}");
    if (files != null) log("FILES: $files");
  }

  /// Log response details
  void _logResponse({
    required String method,
    required String url,
    required http.Response response,
  }) {
    log("RESPONSE $method $url STATUS: ${response.statusCode}");
    log("RESPONSE BODY $url: ${response.body}");
    log("========================");
  }

  /// Handle common response scenarios
  Future<http.Response> _handleResponse(
    http.Response response,
    String url, {
    Map<String, dynamic>? body,
    List<http.MultipartFile>? files,
    required String method,
  }) async {
    // Handle timeout
    if (response.body.contains("Timeout")) {
      log("TIMEOUT");
      final context = Get.context;
      if (context != null) {
        throw 'Timeout';
      }
    }

    // Handle unauthorized access
    if (_isUnauthorized(response)) {
      log("UNAUTHORIZED");
      await _handleUnauthorizedAccess();
      return response;
    }

    // Handle token refresh scenarios
    // if (_needsTokenRefresh(response)) {
    //   final context = Get.context;
    //   if (context != null) {
    //     // Retry the request after token refresh
    //     switch (method.toUpperCase()) {
    //       case 'GET':
    //         return await get(url, body: body as Map<String, String?>?);
    //       case 'POST':
    //         return await post(url, body: body, files: files);
    //       case 'PUT':
    //         return await put(url, body: body, files: files);
    //       case 'DELETE':
    //         return await delete(url, body: body as Map<String, String?>?);
    //     }
    //   }
    // }

    return response;
  }

  /// Check if response indicates unauthorized access
  bool _isUnauthorized(http.Response response) {
    return (response.statusCode == 401 && !_isTokenError(response.body)) ||
        response.body.contains("Unauthenticated");
  }

  /// Check if response indicates token error
  bool _isTokenError(String responseBody) {
    return responseBody.contains("invalid token") ||
        responseBody.contains("expired token");
  }

  /// Check if token needs refresh
  bool _needsTokenRefresh(http.Response response) {
    return _isTokenError(response.body);
  }

  /// Handle unauthorized access by clearing preferences and redirecting
  Future<void> _handleUnauthorizedAccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final session = Get.find<SessionController>();
    session.loginModel.value = LoginModel();
    session.logout();

    final context = Get.context;
    if (context != null) {
      log("CONTEXT NOT NULL");
      Get.offAndToNamed(AppRoute.LOGIN);
    }
  }

  /// Perform GET request
  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Map<String, String?>? body,
  }) async {
    try {
      final requestHeaders = await _buildHeaders(additionalHeaders: headers);

      // Build URL with query parameters
      final uri = Uri.parse(AppUrl.BASE_API_FULL + url);
      final finalUri = body != null ? uri.replace(queryParameters: body) : uri;

      _logRequest(method: 'GET', url: finalUri.toString(), body: body);

      final response = await http
          .get(finalUri, headers: requestHeaders)
          .timeout(
            const Duration(seconds: _timeoutSeconds),
            onTimeout: () => http.Response("Timeout", 504),
          );

      _logResponse(method: 'GET', url: url, response: response);

      return await _handleResponse(response, url, body: body, method: 'GET');
    } catch (e) {
      log("GET request error: $e");
      rethrow;
    }
  }

  /// Perform POST request
  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    List<http.MultipartFile>? files,
    bool isJsonEncode = false,
  }) async {
    // try {
    _logRequest(method: 'POST', url: url, body: body, files: files);

    if (files == null) {
      return await _performSimplePost(
        url,
        headers,
        body,
        isJsonEncode: isJsonEncode,
      );
    } else {
      return await _performMultipartPost(url, headers, body, files);
    }
    // } catch (e) {
    //   log("POST request error: $e");
    //   rethrow;
    // }
  }

  /// Perform simple POST request without files
  Future<http.Response> _performSimplePost(
    String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body, {
    bool isJsonEncode = false,
  }) async {
    final requestHeaders = await _buildHeaders(additionalHeaders: headers);

    final response = await http
        .post(
          Uri.parse(AppUrl.BASE_API_FULL + url),
          headers: requestHeaders,
          body: isJsonEncode ? jsonEncode(body) : body,
          encoding: Encoding.getByName("utf-8"),
        )
        .timeout(
          const Duration(seconds: _timeoutSeconds),
          onTimeout: () => http.Response("Timeout", 504),
        );

    _logResponse(method: 'POST', url: url, response: response);
    return await _handleResponse(response, url, body: body, method: 'POST');
  }

  /// Perform multipart POST request with files
  Future<http.Response> _performMultipartPost(
    String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    List<http.MultipartFile> files,
  ) async {
    final requestHeaders = await _buildHeaders(
      additionalHeaders: headers,
      isMultipart: true,
    );

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(AppUrl.BASE_API_FULL + url),
    );
    request.headers.addAll(requestHeaders);

    if (body != null) {
      request.fields.addAll(
        body.map((key, value) => MapEntry(key, value.toString())),
      );
    }

    request.files.addAll(files);

    final response = await http.Response.fromStream(
      await request.send(),
    ).timeout(
      const Duration(seconds: _timeoutSeconds),
      onTimeout: () => http.Response("Timeout", 504),
    );

    _logResponse(method: 'POST', url: url, response: response);
    return await _handleResponse(
      response,
      url,
      body: body,
      files: files,
      method: 'POST',
    );
  }

  /// Perform PUT request
  Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    List<http.MultipartFile>? files,
  }) async {
    try {
      _logRequest(method: 'PUT', url: url, body: body, files: files);

      if (files == null) {
        return await _performSimplePut(url, headers, body);
      } else {
        return await _performMultipartPut(url, headers, body, files);
      }
    } catch (e) {
      log("PUT request error: $e");
      rethrow;
    }
  }

  /// Perform simple PUT request without files
  Future<http.Response> _performSimplePut(
    String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  ) async {
    final requestHeaders = await _buildHeaders(additionalHeaders: headers);

    final response = await http
        .put(
          Uri.parse(AppUrl.BASE_API_FULL + url),
          headers: requestHeaders,
          body: body,
          encoding: Encoding.getByName("utf-8"),
        )
        .timeout(
          const Duration(seconds: _timeoutSeconds),
          onTimeout: () => http.Response("Timeout", 504),
        );

    _logResponse(method: 'PUT', url: url, response: response);
    return await _handleResponse(response, url, body: body, method: 'PUT');
  }

  /// Perform multipart PUT request with files
  Future<http.Response> _performMultipartPut(
    String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    List<http.MultipartFile> files,
  ) async {
    final requestHeaders = await _buildHeaders(
      additionalHeaders: headers,
      isMultipart: true,
    );

    // Note: Using POST for multipart PUT as HTTP doesn't support multipart PUT directly
    final request = http.MultipartRequest(
      "PUT",
      Uri.parse(AppUrl.BASE_API_FULL + url),
    );
    request.headers.addAll(requestHeaders);

    if (body != null) {
      request.fields.addAll(
        body.map((key, value) => MapEntry(key, value.toString())),
      );
    }

    request.files.addAll(files);

    final response = await http.Response.fromStream(
      await request.send(),
    ).timeout(
      const Duration(seconds: _timeoutSeconds),
      onTimeout: () => http.Response("Timeout", 504),
    );

    _logResponse(method: 'PUT', url: url, response: response);
    return await _handleResponse(
      response,
      url,
      body: body,
      files: files,
      method: 'PUT',
    );
  }

  /// Perform DELETE request
  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, String?>? body,
  }) async {
    try {
      final requestHeaders = await _buildHeaders(additionalHeaders: headers);

      _logRequest(method: 'DELETE', url: url, body: body);

      final response = await http
          .delete(
            Uri.parse(AppUrl.BASE_API_FULL + url),
            headers: requestHeaders,
          )
          .timeout(
            const Duration(seconds: _timeoutSeconds),
            onTimeout: () => http.Response("Timeout", 504),
          );

      _logResponse(method: 'DELETE', url: url, response: response);
      return await _handleResponse(response, url, body: body, method: 'DELETE');
    } catch (e) {
      log("DELETE request error: $e");
      rethrow;
    }
  }

  /// Show/hide loading indicator
  Future<void> loading(bool show) async {
    // Implement loading logic here
    // if (show) {
    //   await Utils.showLoading();
    // } else {
    //   await Utils.dismissLoading();
    // }
  }
}
