import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_controller.dart';

class ApdReceptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdReceptionController());
  }
}
