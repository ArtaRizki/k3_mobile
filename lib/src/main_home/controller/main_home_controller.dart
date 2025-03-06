import 'package:get/get.dart';

class MainHomeController extends GetxController {
  var selectedIndex = 0.obs;

  onItemTapped(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
