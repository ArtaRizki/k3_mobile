import 'package:get/get.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/controller/inspection_routine_create_controller.dart';

class InspectionRoutineCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InspectionRoutineCreateController());
  }
}
