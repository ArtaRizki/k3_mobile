import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/src/inspection/inspection_project/model/inspection_project_create_param.dart';

class InspectionProjectController extends GetxController {
  final searchC = TextEditingController().obs;
  var filteredInspections = <InspectionProjectCreateParam>[].obs;

  List<InspectionProjectCreateParam> inspectionsCreate = [
    InspectionProjectCreateParam(
      projectName: 'INS/2025/II/001',
      date: '12/02/2025',
      time: '00:00',
      category: 'Near Miss',
      risk: 'Risiko sedang',
      location: 'Ruang Meeting Kantor pusat',
      eventDescription: '',
      actionTaken: true,
      reason: '',
      actionDetails: '',
      image: [],
    ),
    InspectionProjectCreateParam(
      projectName: 'INS/2025/II/001',
      date: '12/02/2025',
      time: '00:00',
      category: 'Near Miss',
      risk: 'Risiko sedang',
      location: 'Ruang Meeting Kantor pusat',
      eventDescription: '',
      actionTaken: true,
      reason: '',
      actionDetails: '',
      image: [],
    ),
  ];

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
      filteredInspections.assignAll(inspectionsCreate.where((inspection) {
        return inspection.projectName.toLowerCase().contains(query) ||
            inspection.location.toLowerCase().contains(query) ||
            inspection.risk.toLowerCase().contains(query);
      }).toList());
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
