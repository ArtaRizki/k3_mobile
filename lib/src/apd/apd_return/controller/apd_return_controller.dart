import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_model.dart';
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_param.dart';

class ApdReturnController extends GetxController {
  final searchC = TextEditingController().obs;
  var apdRec = <ApdReturnModelData>[].obs;
  var filteredApdRet = <ApdReturnModelData>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredApdRet.assignAll(apdRec);
    searchC.value.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdRet.assignAll(apdRec);
    } else {
      filteredApdRet.assignAll(apdRec.where((apd) {
        return (apd.id ?? '').toLowerCase().contains(query) ||
            (apd.docDate ?? '').toLowerCase().contains(query) ||
            // aslinya unit name di vendor ini
            (apd.vendorName ?? '').toLowerCase().contains(query) ||
            (apd.deskripsi ?? '').toLowerCase().contains(query);
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

  Future<void> deleteApdReturnParam(int index) async {
    filteredApdRet.removeAt(index);
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
