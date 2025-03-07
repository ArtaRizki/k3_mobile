import 'package:get/get.dart';
import 'package:k3_mobile/src/guide/controller/guide_controller.dart';
import 'package:k3_mobile/src/guide/controller/guide_preview_controller.dart';

class GuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideController());
    Get.put(GuidePreviewController());
  }
}
