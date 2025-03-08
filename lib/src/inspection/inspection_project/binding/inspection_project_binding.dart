import 'package:get/get.dart';
import 'package:k3_mobile/src/inspection/inspection_project/controller/inspection_project_controller.dart';

class InspectionProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InspectionProjectController());
  }
}
