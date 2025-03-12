import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_param.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_select.dart';

class ApdRequestController extends GetxController {
  final searchC = TextEditingController().obs;
  var apdReq = <ApdRequestParam>[].obs;
  var filteredApdReq = <ApdRequestParam>[].obs;

  @override
  void onInit() async {
    filteredApdReq.assignAll(apdReq);
    searchC.value.addListener(_onSearchChanged);
    super.onInit();
  }

  void _onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdReq.assignAll(apdReq);
    } else {
      filteredApdReq.assignAll(apdReq.where((apd) {
        return apd.id.toLowerCase().contains(query) ||
            apd.date.toLowerCase().contains(query) ||
            apd.unit.toLowerCase().contains(query) ||
            apd.note.toLowerCase().contains(query);
      }).toList());
    }
  }

  void clearField() {
    searchC.value.clear();
    update();
  }

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

  deleteApdRequestParam(int i) async {
    filteredApdReq.removeAt(i);
    update();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    searchC.value.dispose();
    super.onClose();
  }
}
