import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';

class ApdReturnController extends GetxController {
  final searchC = TextEditingController().obs;

  String statusTxt(int i) {
    if (i == 0 || i % 10 == 0) return 'Diajukan';
    if (i == 1 || i % 10 == 1) return 'Draft';
    if (i == 2 || i % 10 == 2) return 'Ditolak';
    if (i == 3 || i % 10 == 3) return 'Disetujui';
    return 'Status';
  }

  Color statusColor(int i) {
    if (i == 0 || i % 10 == 0) return AppColor.warningMedium;
    if (i == 1 || i % 10 == 1) return AppColor.highlightMedium;
    if (i == 2 || i % 10 == 2) return AppColor.errorMedium;
    if (i == 3 || i % 10 == 3) return AppColor.successMedium;
    return AppColor.neutralDarkDarkest;
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
