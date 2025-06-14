import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';

class ApdRequestController extends GetxController {
  final searchC = TextEditingController().obs;
  var apdReqList = <ApdRequestModelData?>[].obs;
  var filteredApdReq = <ApdRequestModelData?>[].obs;
  var loading = false.obs;

  @override
  void onInit() async {
    getData();
    super.onInit();
  }

  void onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdReq.assignAll(apdReqList);
    } else {
      filteredApdReq.assignAll(
        apdReqList.where((apdReq) {
          return (apdReq?.code ?? '').toLowerCase().contains(query) ||
              (apdReq?.docDate ?? '').toLowerCase().contains(query) ||
              (apdReq?.unitName ?? '').toLowerCase().contains(query) ||
              (apdReq?.description ?? '').toLowerCase().contains(query) ||
              Utils.getDocStatusName(
                apdReq?.docStatus ?? '',
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
      final httpClient = HttpRequestClient();
      final response = await httpClient.get('/get-data-permintaan');
      if (response.statusCode == 200) {
        final apdReqs = ApdRequestModel.fromJson(jsonDecode(response.body));
        loading(false);
        apdReqList.value = apdReqs.data ?? [];
        filteredApdReq.assignAll(apdReqs.data ?? []);
        searchC.value.addListener(onSearchChanged);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg != '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  Future<void> deleteApdRequestModel(int index) async {
    filteredApdReq.removeAt(index);
    update();
  }
}
