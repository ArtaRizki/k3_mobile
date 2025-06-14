import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/guide/model/guide_model.dart';

class GuideController extends GetxController {
  final searchC = TextEditingController().obs;
  var filteredGuides = <GuideModelData?>[].obs;
  List<GuideModelData?> guides = [];
  var loading = false.obs;

  @override
  void onInit() async {
    getData();
    super.onInit();
  }

  void _onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredGuides.assignAll(guides);
    } else {
      filteredGuides.assignAll(
        guides.where((guide) {
          return (guide?.nomor ?? '').toLowerCase().contains(query) ||
              (guide?.tanggal ?? '').toLowerCase().contains(query) ||
              (guide?.kategoriName ?? '').toLowerCase().contains(query)
          // (guide?.judul ?? '').toLowerCase().contains(query) ||
          // Utils.getDocStatusName(
          //   guide?.docStatus ?? '',
          // ).toLowerCase().contains(query)
          ;
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
      // update();
      final httpClient = HttpRequestClient();
      final response = await httpClient.get('/get-data-pedoman');
      if (response.statusCode == 200) {
        final guides = GuideModel.fromJson(jsonDecode(response.body));
        filteredGuides.assignAll(guides.data ?? []);
        searchC.value.addListener(_onSearchChanged);
        // update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }
}
