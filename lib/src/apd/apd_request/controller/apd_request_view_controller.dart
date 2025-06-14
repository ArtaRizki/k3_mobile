import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_controller.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_view_model.dart';

class ApdRequestViewController extends GetxController {
  var req = HttpRequestClient();
  var loading = false.obs;
  var viewData = ApdRequestViewModel().obs;
  var indexData = 0.obs;

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  init() async {
    if (Get.arguments != null) {
      await getData();
    }
  }

  Future<void> getData() async {
    if (!loading.value) {
      loading(true);
      final response = await req.post(
        '/get-data-permintaan-by-id',
        body: {'id': '${Get.arguments}'},
      );
      if (response.statusCode == 200) {
        viewData.value = ApdRequestViewModel.fromJson(
          jsonDecode(response.body),
        );
        loading(false);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  Future<void> setApdStatus(String status) async {
    if (!loading.value) {
      loading(true);
      final response = await req.post(
        '/set-status-permintaan',
        body: {'id': '${Get.arguments}', 'status': status},
        // isJsonEncode: true,
      );
      if (response.statusCode == 204) {
        final msg = 'Data berhasil disimpan';
        await Utils.showSuccess(msg: msg);
        loading(false);
        Get.find<ApdRequestController>().getData();
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
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
