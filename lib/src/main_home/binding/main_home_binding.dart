import 'package:get/get.dart';
import 'package:k3_mobile/src/guide/controller/guide_controller.dart';
import 'package:k3_mobile/src/home/controller/home_controller.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';
import 'package:k3_mobile/src/profile/controller/profile_controller.dart';

class MainHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainHomeController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => GuideController());
  }
}
