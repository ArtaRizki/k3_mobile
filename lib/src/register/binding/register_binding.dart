import 'package:get/get.dart';
import 'package:k3_mobile/src/register/controller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}
