import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_view_controller.dart';

class ApdRequestViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdRequestViewController());
  }
}
