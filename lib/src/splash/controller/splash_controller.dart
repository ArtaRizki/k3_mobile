import 'package:get/get.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final _session = Get.put(SessionController());
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
    final prefs = await SharedPreferences.getInstance();

    var token = prefs.getString(AppSharedPreferenceKey.kSetPrefToken);
    if (token == null) {
      _session.logout();
      Get.offAllNamed(AppRoute.HOME);
    } else {
      Get.offAllNamed(AppRoute.HOME);
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
