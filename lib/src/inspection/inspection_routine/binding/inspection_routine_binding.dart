import 'package:get/get.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/controller/inspection_routine_controller.dart';

class InspectionRoutineBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InspectionRoutineController());
  }
}
