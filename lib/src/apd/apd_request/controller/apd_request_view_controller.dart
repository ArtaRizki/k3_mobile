import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_param.dart';

class ApdRequestViewController extends GetxController {
  var loading = false.obs;
  var viewData = ApdRequestParam(
    id: '',
    unit: '',
    date: '',
    note: '',
    status: '',
    reqList: [],
  ).obs;
  var indexData = 0.obs;

  String statusTxt(int i) {
    if (i == 0 || i % 10 == 0) return 'Diajukan';
    if (i == 1 || i % 10 == 1) return 'Draft';
    if (i == 2 || i % 10 == 2) return 'Ditolak';
    if (i == 3 || i % 10 == 3) return 'Disetujui';
    return 'Status';
  }

  Color statusColor(String v) {
    if (v == 'Draft') return AppColor.highlightDarkest;
    if (v == 'Diajukan') return AppColor.warningDark;
    if (v == 'Disetujui') return AppColor.successMedium;
    if (v == 'Ditolak') return AppColor.errorDark;
    return AppColor.neutralDarkDarkest;
  }

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

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
