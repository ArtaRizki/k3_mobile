import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_model.dart';

class ApdReturnController extends GetxController {
  final searchC = TextEditingController().obs;
  var apdRets = <ApdReturnModelData?>[].obs;
  var filteredApdRet = <ApdReturnModelData?>[].obs;
  var loading = false.obs;

  @override
  void onInit() async {
    getData();
    super.onInit();
  }

  void onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdRet.assignAll(apdRets);
    } else {
      filteredApdRet.assignAll(
        apdRets.where((apdRet) {
          return (apdRet?.code ?? '').toLowerCase().contains(query) ||
              (apdRet?.pengeluaranCode ?? '').toLowerCase().contains(query) ||
              (apdRet?.docDate ?? '').toLowerCase().contains(query) ||
              (apdRet?.vendorName ?? '').toLowerCase().contains(query) ||
              (apdRet?.deskripsi ?? '').toLowerCase().contains(query) ||
              Utils.getDocStatusName(
                apdRet?.status ?? '',
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
      final httpClient = HttpRequestClient();
      final response = await httpClient.get('/get-data-pengembalian-barang');
      if (response.statusCode == 200) {
        final apdRets = ApdReturnModel.fromJson(jsonDecode(response.body));
        loading(false);
        filteredApdRet.assignAll(apdRets.data ?? []);
        searchC.value.addListener(onSearchChanged);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  Future<void> deleteApdReturnModel(int index) async {
    filteredApdRet.removeAt(index);
    update();
  }
}
