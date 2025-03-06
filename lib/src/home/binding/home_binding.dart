import 'package:get/get.dart';
import 'package:k3_mobile/src/home/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
  }
}
