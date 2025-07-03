import 'dart:convert';

import 'package:get/get.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var loading = false.obs;
  var loginModel = Rxn<LoginModel>(); // Make it reactive

  @override
  void onInit() async {
    // Initialize from SessionController if available
    final sessionController = Get.find<SessionController>();
    loginModel.value = sessionController.loginModel.value;
    await getData();
    super.onInit();
  }

  Future<void> getData() async {
    var prefs = await SharedPreferences.getInstance();
    var loginDataKey = prefs.getString(
      AppSharedPreferenceKey.kSetPrefLoginModel,
    );
    if (loginDataKey != null) {
      loginModel.value = LoginModel.fromJson(jsonDecode(loginDataKey));
    }
  }
}
