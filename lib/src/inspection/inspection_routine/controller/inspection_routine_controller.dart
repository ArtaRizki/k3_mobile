import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/inspection/model/inspection_model.dart';

class InspectionRoutineController extends GetxController {
  final searchC = TextEditingController().obs;
  var filteredInspections = <InspectionModelData?>[].obs;
  var inspectionList = <InspectionModelData?>[].obs;
  var loading = false.obs;

  @override
  void onInit() async {
    getData();
    super.onInit();
  }

  void onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredInspections.assignAll(inspectionList);
    } else {
      filteredInspections.assignAll(
        inspectionList.where((inspection) {
          return (inspection?.code ?? '').toLowerCase().contains(query) ||
              (inspection?.docDate ?? '').toLowerCase().contains(query) ||
              (inspection?.resiko ?? '').toLowerCase().contains(query) ||
              (inspection?.kategoriName ?? '').toLowerCase().contains(query) ||
              (inspection?.lokasi ?? '').toLowerCase().contains(query) ||
              Utils.getDocStatusName(
                inspection?.docStatus ?? '',
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
      final httpClient = HttpRequestClient();
      final response = await httpClient.get(
        '/get-data-inspeksi',
        body: {'tipe': '0'},
      );
      if (response.statusCode == 200) {
        final inspections = InspectionModel.fromJson(jsonDecode(response.body));
        loading(false);
        inspectionList.value = inspections.data ?? [];
        filteredInspections.assignAll(inspections.data ?? []);
        searchC.value.addListener(onSearchChanged);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }
}
