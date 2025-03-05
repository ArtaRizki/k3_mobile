import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  SharedPreferences? _preferences;

  Future<SharedPreferences?> preferences() async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  Future<String?> getToken() async {
    return (await preferences())!
        .getString(AppSharedPreferenceKey.kSetPrefToken);
  }

  Future<http.Response> get(String url,
      {Map? headers, Map<String, String?>? body}) async {
    Map<String, String> h = Map<String, String>();
    h.putIfAbsent('Connection', () => 'Keep-Alive');
    h.putIfAbsent('accept', () => 'application/json');
    // final ipv4 = await IpAddress().getIpv4();
    // h.putIfAbsent('X-Real-IP', () => ipv4);
    var token = await getToken();
    if (token != null) h.putIfAbsent('Authorization', () => 'Bearer ' + token);
    if (headers != null) h.addAll(headers as Map<String, String>);

    log("==== PARAMETERS ====");
    // log("IP PUBLIC : $ipv4");
    log("URL : $url");
    log("BODY : $body");
    // log("HEADERS : ${h}");

    String param = Uri(queryParameters: body).query;
    log("PARAM : ${param}");

    final uri = Uri.parse('$url?$param');
    log("URI PATH : ${uri.path}");
    log("URI COMPLETE : ${AppUrl.BASE_API_FULL3 + uri.path + '${body != null ? '?' : ''}' + param}");

    http.Response response = await http
        .get(
            Uri.parse(
              url +
                  '${body != null ? '?' : ''}' +
                  '${body == null ? '' : param}',
            ),
            headers: h)
        .timeout(
          Duration(seconds: 30),
          onTimeout: () => http.Response("Timeout", 504),
        );
    log("RESPONSE GET $url STATUS CODE ${response.statusCode} : ${response.body}");
    log("====================");

    String log2 = "Log : " +
        "==== PARAMETERS ===="
            '\r\n' +
        "URL : $url"
            '\r\n' +
        "HEADERS : $headers"
            '\r\n' +
        "BODY : $body"
            '\r\n' +
        "RESPONSE GET $url : ${response.body}"
            '\r\n' +
        "===================="
            '\r\n';
    // if (kDebugMode) {
    // // XenoLog("GET").save(log2, alwaysLog: true);
    // }
    // Utils.dismissLoading();
    // if (response.body.contains("Timeout")) {
    //   BuildContext? context = Get.context;
    //   if (context != null) {
    //     // CustomAlert.showSnackBar(context, 'Timeout', true);
    //     throw 'Timeout';
    //   }
    // }
    // if (response.statusCode == 401 &&
    //     !(response.body.contains("invalid token") ||
    //         response.body.contains("expired token"))) {
    //   _preferences!.clear();
    //   BuildContext? context = Get.context;
    //   if (context != null)
    //     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    // }
    // if (response.body.contains("Unauthorized") ||
    //     response.body.contains("missing authorization header")) {
    //   _preferences!.clear();
    //   BuildContext? context = Get.context;
    //   if (context != null) {
    //     // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
    //     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    //   }
    // }
    // if (response.body.contains("refresh token tidak valid") ||
    //     response.body.contains("refresh token kedaluarsa")) {
    //   BuildContext? context = Get.context;
    //   _preferences!.clear();
    //   if (context != null) {
    //     // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
    //     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    //   }
    // }
    // if (response.body.contains("invalid token") ||
    //     response.body.contains("expired token")) {
    //   BuildContext? context = Get.context;
    //   if (context != null) {
    //     // await context.read<AuthProvider>().refreshToken();
    //     if (url != 'http://103.59.94.19/turbines') await get(url, body: body);
    //     // Utils.dismissLoading();
    //   }
    // }
    // if (response.body.contains("Gateway time") ||
    //     response.body
    //         .toString()
    //         .toLowerCase()
    //         .contains("Internal Server Error")) {
    //   return response;
    //   // return response.body;
    // }

    return response;
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? body,
      List<http.MultipartFile>? files}) async {
    // print(body);
    Map<String, String> h = Map<String, String>();
    h.putIfAbsent('Connection', () => 'keep-alive');
    h.putIfAbsent('Accept', () => 'application/json');
    // final ipv4 = await IpAddress().getIpv4();
    // h.putIfAbsent('X-Real-IP', () => ipv4);
    var token = await getToken();
    if (token != null) h.putIfAbsent('Authorization', () => 'Bearer ' + token);
    if (headers != null) h.addAll(headers);

    if (files == null) {
      log("==== PARAMETERS ====");
      // log("IP PUBLIC : $ipv4");
      log("URL : $url");
      log("BODY : $body");
      // log("HEADERS : ${h}");
      final uri = Uri.parse(url);
      // final bodyUri = Uri.https(uri.authority, uri.path, body);
      http.Response response = await http
          .post(Uri.parse(url),
              headers: h,
              body: jsonEncode(body),
              encoding: Encoding.getByName("utf-8"))
          .timeout(Duration(seconds: 30),
              onTimeout: () => http.Response("Timeout", 504));
      log("RESPONSE POST $url STATUS CODE : ${response.statusCode}");
      log("RESPONSE POST $url : ${response.body}");
      log("====================");
      String log2 = "Log : " +
          "==== PARAMETERS ===="
              '\r\n' +
          "URL : $url"
              '\r\n' +
          "HEADERS : $headers"
              '\r\n' +
          "BODY : $body"
              '\r\n' +
          "FILES : $files"
              '\r\n' +
          "RESPONSE POST $url : ${response.body}"
              '\r\n' +
          "===================="
              '\r\n';
      // if (kDebugMode) {
      // // XenoLog("POST").save(log2, alwaysLog: true);
      // }
      // Utils.dismissLoading();
      if (response.body.contains("Timeout")) {
        BuildContext? context = Get.context;
        if (context != null) {
          // // CustomAlert.showSnackBar(context, 'Timeout', true);
          throw 'Timeout';
        }
      }
      if (response.statusCode == 401 &&
          !(response.body.contains("invalid token") ||
              response.body.contains("expired token"))) {
        _preferences!.clear();
        BuildContext? context = Get.context;
        if (context != null)
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      if (response.body.contains("Unauthorized") ||
          response.body.contains("missing authorization header")) {
        _preferences!.clear();
        BuildContext? context = Get.context;
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
      if (response.body.contains("refresh token tidak valid") ||
          response.body.contains("refresh token kedaluarsa")) {
        BuildContext? context = Get.context;
        _preferences!.clear();
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
      if (response.body.contains("invalid token") ||
          response.body.contains("expired token")) {
        BuildContext? context = Get.context;
        if (context != null) {
          // await context.read<AuthProvider>().refreshToken();
          await post(url, body: body);
          // Utils.dismissLoading();
        }
      }
      if (response.body.contains("Gateway time") ||
          response.body
              .toString()
              .toLowerCase()
              .contains("Internal Server Error")) {
        return response;
        // return response.body;
      }
      return response;
    } else {
      var req = http.MultipartRequest("POST", Uri.parse(url));
      h.putIfAbsent("Content-Type", () => 'multipart/form-data');
      // final ipv4 = await IpAddress().getIpv4();
      // h.putIfAbsent('X-Real-IP', () => ipv4);
      req.headers.addAll(h);
      if (body != null)
        req.fields
            .addAll(body.map((key, value) => MapEntry(key, value.toString())));
      req.files.addAll(files);
      log("==== PARAMETERS ====");
      // log("IP PUBLIC : $ipv4");
      log("URL : $url");
      log("BODY : $body");
      log("FILES : $files");
      http.Response response = await http.Response.fromStream(await req.send())
          .timeout(Duration(seconds: 30),
              onTimeout: () => http.Response("Timeout", 504));
      log("RESPONSE POST FILE $url : ${response.body}");
      log("====================");
      String log2 = "Log : " +
          "==== PARAMETERS ===="
              '\r\n' +
          "URL : $url"
              '\r\n' +
          "HEADERS : $headers"
              '\r\n' +
          "BODY : $body"
              '\r\n' +
          "FILES : $files"
              '\r\n' +
          "RESPONSE POST $url : ${response.body}"
              '\r\n' +
          "===================="
              '\r\n';
      // if (kDebugMode) {
      // XenoLog("POST").save(log2, alwaysLog: true);
      // }
      // Utils.dismissLoading();
      if (response.body.contains("Timeout")) {
        BuildContext? context = Get.context;
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Timeout', true);
          throw 'Timeout';
        }
      }
      if (response.statusCode == 401 &&
          !(response.body.contains("invalid token") ||
              response.body.contains("expired token"))) {
        _preferences!.clear();
        BuildContext? context = Get.context;
        if (context != null)
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      if (response.body.contains("Unauthorized") ||
          response.body.contains("missing authorization header")) {
        _preferences!.clear();
        BuildContext? context = Get.context;
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
      if (response.body.contains("refresh token tidak valid") ||
          response.body.contains("refresh token kedaluarsa")) {
        BuildContext? context = Get.context;
        _preferences!.clear();
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
      if (response.body.contains("invalid token") ||
          response.body.contains("expired token")) {
        BuildContext? context = Get.context;
        if (context != null) {
          // await context.read<AuthProvider>().refreshToken();
          await post(url, body: body, files: files);
          // Utils.dismissLoading();
        }
      }
      if (response.body.contains("Gateway time") ||
          response.body
              .toString()
              .toLowerCase()
              .contains("Internal Server Error")) {
        return response;
        // return response.body;
      }
      return response;
    }
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? body,
      List<http.MultipartFile>? files}) async {
    // print(body);
    Map<String, String> h = Map<String, String>();
    h.putIfAbsent('Connection', () => 'Keep-Alive');
    h.putIfAbsent('accept', () => 'application/json');
    // final ipv4 = await IpAddress().getIpv4();
    // h.putIfAbsent('X-Real-IP', () => ipv4);
    var token = await getToken();
    if (token != null) h.putIfAbsent('Authorization', () => 'Bearer ' + token);
    if (headers != null) h.addAll(headers);

    if (files == null) {
      log("==== PARAMETERS ====");
      // log("IP PUBLIC : $ipv4");
      log("URL : $url");
      log("BODY : $body");
      http.Response response = await http
          .put(Uri.parse(url),
              headers: h, body: body, encoding: Encoding.getByName("utf-8"))
          .timeout(Duration(seconds: 30),
              onTimeout: () => http.Response("Timeout", 504));
      log("RESPONSE PUT $url : ${response.body}");
      log("====================");
      String log2 = "Log : " +
          "==== PARAMETERS ===="
              '\r\n' +
          "URL : $url"
              '\r\n' +
          "HEADERS : $headers"
              '\r\n' +
          "BODY : $body"
              '\r\n' +
          "FILES : $files"
              '\r\n' +
          "RESPONSE PUT $url : ${response.body}"
              '\r\n' +
          "===================="
              '\r\n';
      // if (kDebugMode) {
      // XenoLog("PUT").save(log2, alwaysLog: true);
      // }
      // Utils.dismissLoading();
      if (response.body.contains("Timeout")) {
        BuildContext? context = Get.context;
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Timeout', true);
          throw 'Timeout';
        }
      }
      if (response.statusCode == 401 &&
          !(response.body.contains("invalid token") ||
              response.body.contains("expired token"))) {
        _preferences!.clear();
        BuildContext? context = Get.context;
        if (context != null)
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      if (response.body.contains("Unauthorized") ||
          response.body.contains("missing authorization header")) {
        _preferences!.clear();
        BuildContext? context = Get.context;
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
      if (response.body.contains("refresh token tidak valid") ||
          response.body.contains("refresh token kedaluarsa")) {
        BuildContext? context = Get.context;
        _preferences!.clear();
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
      if (response.body.contains("invalid token") ||
          response.body.contains("expired token")) {
        BuildContext? context = Get.context;
        if (context != null) {
          // await context.read<AuthProvider>().refreshToken();
          await put(url, body: body);
          // Utils.dismissLoading();
        }
      }
      if (response.body.contains("Gateway time") ||
          response.body
              .toString()
              .toLowerCase()
              .contains("Internal Server Error")) {
        return response;
        // return response.body;
      }
      return response;
    } else {
      var req = http.MultipartRequest("POST", Uri.parse(url));
      h.putIfAbsent("Content-Type", () => 'multipart/form-data');
      req.headers.addAll(h);
      if (body != null)
        req.fields
            .addAll(body.map((key, value) => MapEntry(key, value.toString())));
      req.files.addAll(files);
      log("==== PARAMETERS ====");
      // log("IP PUBLIC : $ipv4");
      log("URL : $url");
      log("BODY : $body");
      log("FILES : $files");
      http.Response response = await http.Response.fromStream(await req.send())
          .timeout(Duration(seconds: 30),
              onTimeout: () => http.Response("Timeout", 504));
      log("RESPONSE PUT FILE $url : ${response.body}");
      log("====================");
      String log2 = "Log : " +
          "==== PARAMETERS ===="
              '\r\n' +
          "URL : $url"
              '\r\n' +
          "HEADERS : $headers"
              '\r\n' +
          "BODY : $body"
              '\r\n' +
          "FILES : $files"
              '\r\n' +
          "RESPONSE PUT $url : ${response.body}"
              '\r\n' +
          "===================="
              '\r\n';
      // if (kDebugMode) {
      // XenoLog("PUT").save(log2, alwaysLog: true);
      // }
      // Utils.dismissLoading();
      if (response.body.contains("Timeout")) {
        BuildContext? context = Get.context;
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Timeout', true);
          throw 'Timeout';
        }
      }
      if (response.statusCode == 401 &&
          !(response.body.contains("invalid token") ||
              response.body.contains("expired token"))) {
        _preferences!.clear();
        BuildContext? context = Get.context;
        if (context != null)
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      if (response.body.contains("Unauthorized") ||
          response.body.contains("missing authorization header")) {
        _preferences!.clear();
        BuildContext? context = Get.context;
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
      if (response.body.contains("refresh token tidak valid") ||
          response.body.contains("refresh token kedaluarsa")) {
        BuildContext? context = Get.context;
        _preferences!.clear();
        if (context != null) {
          // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
      if (response.body.contains("invalid token") ||
          response.body.contains("expired token")) {
        BuildContext? context = Get.context;
        if (context != null) {
          // await context.read<AuthProvider>().refreshToken();
          await post(url, body: body, files: files);
          // Utils.dismissLoading();
        }
      }
      if (response.body.contains("Gateway time") ||
          response.body
              .toString()
              .toLowerCase()
              .contains("Internal Server Error")) {
        return response;
        // return response.body;
      }
      return response;
    }
  }

  Future<http.Response> delete(String url,
      {Map? headers, Map<String, String?>? body}) async {
    Map<String, String> h = Map<String, String>();
    h.putIfAbsent('Connection', () => 'Keep-Alive');
    h.putIfAbsent('accept', () => 'application/json');
    // final ipv4 = await IpAddress().getIpv4();
    // h.putIfAbsent('X-Real-IP', () => ipv4);
    var token = await getToken();
    if (token != null) h.putIfAbsent('Authorization', () => 'Bearer ' + token);
    if (headers != null) h.addAll(headers as Map<String, String>);

    final uri = Uri.parse(url);
    final bodyUri = Uri.https(uri.authority, uri.path, body);

    log("==== PARAMETERS ====");
    // log("IP PUBLIC : $ipv4");
    log("URL : $url");
    log("BODY : $bodyUri");
    http.Response response = await http
        .delete(Uri.parse(url), headers: h)
        .timeout(Duration(seconds: 30),
            onTimeout: () => http.Response("Timeout", 504));
    log("RESPONSE DELETE $url : ${response.body}");
    log("====================");

    String log2 = "Log : " +
        "==== PARAMETERS ===="
            '\r\n' +
        "URL : $url"
            '\r\n' +
        "HEADERS : $headers"
            '\r\n' +
        "BODY : $body"
            '\r\n' +
        "RESPONSE DELETE $url : ${response.body}"
            '\r\n' +
        "===================="
            '\r\n';
    // if (kDebugMode) {
    // XenoLog("DELETE").save(log2, alwaysLog: true);
    // }
    // Utils.dismissLoading();
    if (response.body.contains("Timeout")) {
      BuildContext? context = Get.context;
      if (context != null) {
        // CustomAlert.showSnackBar(context, 'Timeout', true);
        throw 'Timeout';
      }
    }
    if (response.statusCode == 401 &&
        !(response.body.contains("invalid token") ||
            response.body.contains("expired token"))) {
      _preferences!.clear();
      BuildContext? context = Get.context;
      if (context != null)
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
    if (response.body.contains("Unauthorized") ||
        response.body.contains("missing authorization header")) {
      // _preferences!.clear();
      BuildContext? context = Get.context;
      if (context != null) {
        // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
    if (response.body.contains("refresh token tidak valid") ||
        response.body.contains("refresh token kedaluarsa")) {
      BuildContext? context = Get.context;
      _preferences!.clear();
      if (context != null) {
        // CustomAlert.showSnackBar(context, 'Harap Login Ulang', true);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
    if (response.body.contains("invalid token") ||
        response.body.contains("expired token")) {
      BuildContext? context = Get.context;
      if (context != null) {
        // await context.read<AuthProvider>().refreshToken();
        await delete(url, body: body);
        // Utils.dismissLoading();
      }
    }
    if (response.body.contains("Gateway time") ||
        response.body
            .toString()
            .toLowerCase()
            .contains("Internal Server Error")) {
      return response;
      // return response.body;
    }
    return response;
  }

  loading(bool show) async {
    // if (show)
    //   await Utils.showLoading();
    // else
    // await
    // Utils.dismissLoading();
  }
}
