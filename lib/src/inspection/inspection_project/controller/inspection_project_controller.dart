import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/src/inspection/model/inspection_model.dart';

class InspectionProjectController extends GetxController {
  final searchC = TextEditingController().obs;
  var filteredInspections = <InspectionModelData>[].obs;

  List<InspectionModelData> inspectionsCreate = [];

  @override
  void onInit() async {
    filteredInspections.assignAll(inspectionsCreate);
    searchC.value.addListener(_onSearchChanged);
    super.onInit();
  }

  void _onSearchChanged() {
    String query = searchC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredInspections.assignAll(inspectionsCreate);
    } else {
      // filteredInspections.assignAll(
      //   inspectionsCreate.where((inspection) {
      //     return inspection.projectName.toLowerCase().contains(query) ||
      //         inspection.location.toLowerCase().contains(query) ||
      //         inspection.risk.toLowerCase().contains(query);
      //   }).toList(),
      // );
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
}
