import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_create_controller.dart';

class ApdReceptionCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdReceptionCreateController());
  }
}
