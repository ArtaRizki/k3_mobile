import 'package:get/get.dart';
import 'package:k3_mobile/component/page/image_preview/controller/image_preview_controller.dart';

class ImagePreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ImagePreviewController());
  }
}
