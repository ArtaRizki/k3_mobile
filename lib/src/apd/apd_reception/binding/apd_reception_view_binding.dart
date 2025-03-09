import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_view_controller.dart';

class ApdReceptionViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdReceptionViewController());
  }
}
