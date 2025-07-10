import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController extends GetxController {
  var req = HttpRequestClient();
  var loginModel = LoginModel().obs;
  var loading = false.obs;
  var isValidated = false.obs;
  var forgotMode = false.obs;

  final currentPassC = TextEditingController().obs,
      newPassC = TextEditingController().obs,
      confirmNewPassC = TextEditingController().obs;

  final currentPassVisible = false.obs,
      newPassVisible = false.obs,
      confirmNewPassVisible = false.obs;

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  init() async {
    if (Get.arguments != null) forgotMode.value = true;
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppSharedPreferenceKey.kSetPrefLoginModel);
    if (data != null) {
      loginModel.value = LoginModel.fromJson(jsonDecode(data));
      final user = loginModel.value.data;
      update();
    }
  }

  bool validate() {
    if (!forgotMode.value) if (currentPassC.value.text.isEmpty) return false;
    if (newPassC.value.text.isEmpty) return false;
    if (confirmNewPassC.value.text.isEmpty) return false;
    if (confirmNewPassC.value.text != newPassC.value.text) return false;
    return true;
  }

  validateForm() {
    isValidated.value = validate();
    log("IS VALIDATED : ${isValidated.value}");
    update();
  }

  Future<void> sendChangePassword() async {
    loading(true);
    final user = loginModel.value.data;
    final response = await req.post(
      '/ubah-password',
      body: {'password': newPassC.value.text, 'user_id': user?.id ?? ''},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      AppSnackbar.showSnackBar(Get.context!, message, true);
      loading(false);
      throw Exception(message);
    }
  }

  Future<void> sendChangePassword2() async {
    loading(true);
    final user = loginModel.value.data;
    final response = await req.post(
      '/change_password',
      body: {'new_pass': newPassC.value.text},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      AppSnackbar.showSnackBar(Get.context!, message, true);
      loading(false);
      throw Exception(message);
    }
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
