import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController nameC = TextEditingController(),
      passwordC = TextEditingController();
  final passwordVisible = false.obs;
  var loading = false.obs;
  var enableLoginBtn = false.obs;

  checkLoginBtnStatus() {
    if (nameC.text.isEmpty)
      enableLoginBtn(false);
    else if (passwordC.text.isEmpty)
      enableLoginBtn(false);
    else
      enableLoginBtn(true);
    update();
  }

  Future<void> login() async {
    log("LOGIN");
    if (!loading.value) {
      loading(true);
      update();
      await Future.delayed(Duration(seconds: 10), () {});
      log("LOGIN 2");
      loading(false);
      update();
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
