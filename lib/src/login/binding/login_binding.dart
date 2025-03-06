import 'package:get/get.dart';
import 'package:k3_mobile/src/home/controller/home_controller.dart';
import 'package:k3_mobile/src/login/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
