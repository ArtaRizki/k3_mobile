import 'package:get/get.dart';
import 'package:k3_mobile/src/inspection/inspection_pdf/inspection_pdf_controller.dart';

class InspectionPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InspectionPdfController());
  }
}
