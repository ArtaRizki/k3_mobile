import 'package:get/get.dart';
import 'package:k3_mobile/src/profile/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController(), permanent: true);
  }
}
