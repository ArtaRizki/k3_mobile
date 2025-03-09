import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_controller.dart';

class ApdRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdRequestController());
  }
}
