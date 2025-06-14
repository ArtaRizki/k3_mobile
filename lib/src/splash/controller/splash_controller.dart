import 'dart:developer';

import 'package:get/get.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  var _session = Get.put(SessionController(), permanent: true);
  final error = false.obs;
  final loading = false.obs;

  @override
  void onInit() async {
    await check();
    super.onInit();
  }

  Future<void> check() async {
    error(false);
    loading(true);
    _session = Get.put(SessionController(), permanent: true);
    final prefs = await SharedPreferences.getInstance();

    var token = prefs.getString(AppSharedPreferenceKey.kSetPrefToken);
    var loginModel = _session.loginModel.value;
    log("LOGIN MODEL TOKEN : ${loginModel.token}");
    log("LOGIN MODEL TOKEN 2 : $token");
    if (token != null) {
      Get.offAllNamed(AppRoute.MAIN_HOME);
    } else {
      _session.logout();
      Get.offAllNamed(AppRoute.LOGIN);
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final isLoggedIn =
    //     prefs.getString(AppSharedPreferenceKey.kSetPrefToken)?.isNotEmpty ?? false;

    // Timer(
    //   Duration(seconds: 1),
    //   () => Navigator.pushNamedAndRemoveUntil(
    //       context, isLoggedIn ? '/home' : '/login', (route) => false),
    // );
  }
}
