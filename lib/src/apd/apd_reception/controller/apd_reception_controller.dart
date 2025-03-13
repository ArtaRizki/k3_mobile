import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/src/apd/apd_reception/model/apd_reception_param.dart';

class ApdReceptionController extends GetxController {
  final searchC = TextEditingController().obs;
  var apdRec = <ApdReceptionParam>[].obs;
  var filteredApdRec = <ApdReceptionParam>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredApdRec.assignAll(apdRec);
    searchC.value.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdRec.assignAll(apdRec);
    } else {
      filteredApdRec.assignAll(apdRec.where((apd) {
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

  Color statusColor(String status) {
    switch (status) {
      case 'Draft':
        return AppColor.highlightDarkest;
      case 'Diajukan':
        return AppColor.warningDark;
      case 'Disetujui':
        return AppColor.successMedium;
      case 'Ditolak':
        return AppColor.errorDark;
      default:
        return AppColor.neutralDarkDarkest;
    }
  }

  Future<void> deleteApdReceptionParam(int index) async {
    filteredApdRec.removeAt(index);
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchC.value.dispose();
    super.onClose();
  }
}
