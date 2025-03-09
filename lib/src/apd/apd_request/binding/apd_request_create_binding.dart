import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_create_controller.dart';

class ApdRequestCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdRequestCreateController());
  }
}
