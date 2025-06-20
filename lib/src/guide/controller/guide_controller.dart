import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/guide/model/guide_model.dart';

class GuideController extends GetxController {
  var req = HttpRequestClient();
  final searchC = TextEditingController().obs;
  var filteredGuides = <GuideModelData?>[].obs;
  var guideList = <GuideModelData?>[].obs;
  var loading = false.obs;

  @override
  void onInit() async {
    getData();
    super.onInit();
  }

  void onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredGuides.assignAll(guideList);
    } else {
      filteredGuides.assignAll(
        guideList.where((guide) {
          return (guide?.nomor ?? '').toLowerCase().contains(query) ||
              (guide?.tanggal ?? '').toLowerCase().contains(query) ||
              (guide?.kategoriName ?? '').toLowerCase().contains(query) ||
              (guide?.judul ?? '').toLowerCase().contains(query) ||
              Utils.getDocStatusName(
                guide?.docStatus ?? '',
              ).toLowerCase().contains(query);
        }).toList(),
      );
    }
    update();
    refresh();
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
      final response = await req.get('/get-data-pedoman');
      if (response.statusCode == 200) {
        final guides = GuideModel.fromJson(jsonDecode(response.body));
        guideList.value = guides.data ?? [];
        filteredGuides.assignAll(guides.data ?? []);
        searchC.value.addListener(onSearchChanged);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }
}
