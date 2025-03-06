import 'package:get/get.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/src/home/controller/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionController extends FullLifeCycleController
    with FullLifeCycleMixin {
  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    prefs.clear();
    Get.delete<HomeController>(force: true);
    Get.appUpdate();
  }

  Future<bool> isUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    var token = prefs.getString(AppSharedPreferenceKey.kSetPrefToken);
    if (token == null) return false;
    return true;
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
