import 'package:get/get.dart';
import 'package:k3_mobile/src/inspection/inspection_project/controller/inspection_project_create_controller.dart';

class InspectionProjectCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InspectionProjectCreateController());
  }
}
