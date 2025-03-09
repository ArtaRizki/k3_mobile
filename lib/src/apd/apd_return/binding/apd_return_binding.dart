import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_controller.dart';

class ApdReturnBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdReturnController());
  }
}
