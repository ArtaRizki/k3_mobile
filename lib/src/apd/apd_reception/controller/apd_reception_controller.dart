import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/apd/apd_reception/model/apd_reception_model.dart';

class ApdReceptionController extends GetxController {
  var req = HttpRequestClient();
  final searchC = TextEditingController().obs;
  var apdRecList = <ApdReceptionModelData?>[].obs;
  var filteredApdRec = <ApdReceptionModelData?>[].obs;
  var loading = false.obs;

  @override
  void onInit() async {
    getData();
    super.onInit();
  }

  void onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdRec.assignAll(apdRecList);
    } else {
      filteredApdRec.assignAll(
        apdRecList.where((apdRec) {
          return (apdRec?.pengeluaranCode ?? '').toLowerCase().contains(
                query,
              ) ||
              (apdRec?.requestCode ?? '').toLowerCase().contains(query) ||
              (apdRec?.docDate ?? '').toLowerCase().contains(query) ||
              (apdRec?.unit ?? '').toLowerCase().contains(query) ||
              (apdRec?.keterangan ?? '').toLowerCase().contains(query) ||
              Utils.getDocStatusName(
                apdRec?.status ?? '',
              ).toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  void clearField() {
    searchC.value.clear();
    update();
  }

  @override
  void dispose() {
    searchC.value.dispose();
    super.dispose();
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

  Future<void> getData() async {
    if (!loading.value) {
      loading(true);
      final response = await req.get('/get-data-penerimaan');
      if (response.statusCode == 200) {
        final apdRecs = ApdReceptionModel.fromJson(jsonDecode(response.body));
        loading(false);
        apdRecList.value = apdRecs.data ?? [];
        filteredApdRec.assignAll(apdRecs.data ?? []);
        searchC.value.addListener(onSearchChanged);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg != '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  Future<void> deleteApdReceptionModel(int index) async {
    filteredApdRec.removeAt(index);
    update();
  }
}
