import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_view_controller.dart';

class ApdReturnViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdReturnViewController());
  }
}
