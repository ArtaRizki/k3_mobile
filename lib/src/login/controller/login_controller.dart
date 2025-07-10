import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController nidC = TextEditingController(),
      passwordC = TextEditingController();
  final passwordVisible = false.obs;
  var loading = false.obs;
  var enableLoginBtn = false.obs;

  checkLoginBtnStatus() {
    if (nidC.text.isEmpty)
      enableLoginBtn(false);
    else if (passwordC.text.isEmpty)
      enableLoginBtn(false);
    else
      enableLoginBtn(true);
    update();
  }

  Future<void> login() async {
    if (!loading.value) {
      loading(true);
      update();
      var body = {'nid': nidC.text, 'password': passwordC.text};
      final httpClient = HttpRequestClient();
      final response = await httpClient.post('/login', body: body);
      if (response.statusCode == 200) {
        final loginModel = LoginModel.fromJson(jsonDecode(response.body));
        Get.find<SessionController>().loginModel.value = loginModel;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (loginModel.token != null) {
          prefs.setString(
            AppSharedPreferenceKey.kSetPrefLoginModel,
            response.body,
          );
          prefs.setString(
            AppSharedPreferenceKey.kSetPrefToken,
            loginModel.token!,
          );
        }
        loading(false);
        update();
        Get.toNamed(AppRoute.MAIN_HOME);
      } else {
        loading(false);
        final msg = jsonDecode(response.body)['message'];
        AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
