import 'package:get/get.dart';
import 'package:k3_mobile/src/apd/apd_reception/model/apd_reception_view_model.dart';

class ApdReceptionViewController extends GetxController {
  var loading = false.obs;
  var viewData = ApdReceptionViewModelData().obs;
  var indexData = 0.obs;

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  init() async {
    if (Get.arguments != null) {
      viewData.value = Get.arguments[1];
      indexData.value = Get.arguments[0];
    }
  }

  String statusTxt(int i) {
    if (i == 0 || i % 10 == 0) return 'Diajukan';
    if (i == 1 || i % 10 == 1) return 'Draft';
    if (i == 2 || i % 10 == 2) return 'Ditolak';
    if (i == 3 || i % 10 == 3) return 'Disetujui';
    return 'Status';
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
