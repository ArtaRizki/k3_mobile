import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_create_controller.dart';

class ApdReturnCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApdReturnCreateController());
  }
}
