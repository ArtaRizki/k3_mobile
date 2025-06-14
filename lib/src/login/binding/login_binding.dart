import 'package:get/get.dart';
import 'package:k3_mobile/src/login/controller/login_controller.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
