import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/custom_date_picker.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_controller.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_param.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_select.dart';

class ApdRequestCreateController extends GetxController {
  var req = HttpRequestClient();
  var loading = false.obs;
  var loadingSendApd = false.obs;
  var loadingSaveDraftApd = false.obs;
  var loadingAddApd = false.obs;
  var isExpanded = false.obs;
  var isValidated = false.obs;
  var isValidatedAddApd = false.obs;
  var isEditMode = false.obs;

  final searchC = TextEditingController().obs;
  final searchApdC = TextEditingController().obs;
  final dateC = TextEditingController().obs;
  final noteC = TextEditingController().obs;
  final apdNameC = TextEditingController().obs;
  final amountC = TextEditingController().obs;

  var dateTime = Rx<DateTime?>(null);
  var selectedStatus = Rx<String?>(null);
  var apdReqList = <ApdRequestModel>[].obs;
  var indexData = 0.obs;

  var viewData = ApdRequestParam(
    id: '',
    unit: '',
    date: '',
    note: '',
    status: '',
    reqList: [],
  ).obs;

  var filteredApdSelectList = <ApdRequestSelect>[].obs;

  List<String> statusList = [
    'Draft',
    'Diajukan',
    'Disetujui',
    'Ditolak',
  ];

  var apdSelectList = [
    ApdRequestSelect(code: 'APD001', category: 'Sipil', name: 'Helm Proyek'),
    ApdRequestSelect(code: 'APD002', category: 'Sipil', name: 'Sepatu Safety'),
    ApdRequestSelect(
        code: 'APD003', category: 'Elektrik', name: 'Sarung Tangan'),
    ApdRequestSelect(code: 'APD004', category: 'Sipil', name: 'Rompi'),
    ApdRequestSelect(
        code: 'APD005', category: 'Kesehatan', name: 'Tabung Oksigen'),
    ApdRequestSelect(code: 'APD006', category: 'Kesehatan', name: 'Kaca mata'),
    ApdRequestSelect(code: 'APD007', category: 'Kesehatan', name: 'Masker'),
    ApdRequestSelect(code: 'APD008', category: 'Sipil', name: 'Sabuk pengaman'),
    ApdRequestSelect(code: 'APD009', category: 'Kesehatan', name: 'Earloop'),
  ];

  bool validate() => dateC.value.text.isNotEmpty;

  void validateForm() {
    isValidated.value = validate();
    log("IS VALIDATED : ${isValidated.value}");
    update();
  }

  bool validateAddApd() {
    return apdNameC.value.text.isNotEmpty && amountC.value.text.isNotEmpty;
  }

  void validateAddApdForm() {
    isValidatedAddApd.value = validateAddApd();
    update();
  }

  List<String> month = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  Future<void> pickDate() async {
    if (Get.context != null) {
      var date = await CustomDatePicker.pickDate(Get.context!, DateTime.now());
      if (date != null) {
        dateTime.value = date;
        dateC.value.text = DateFormat('dd-MM-yyyy').format(date);
      }
    }
    update();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    filteredApdSelectList.assignAll(apdSelectList);
    searchApdC.value.addListener(_onSearchApdChanged);

    if (Get.arguments != null) {
      isEditMode.value = true;
      viewData.value = Get.arguments[1];
      final data = viewData.value;
      dateC.value.text = data.date;
      noteC.value.text = data.note;
      selectedStatus.value = data.status;
      apdReqList.assignAll(data.reqList);
      validateForm();
    }
    update();
  }

  void _onSearchApdChanged() {
    String query = searchApdC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdSelectList.assignAll(apdSelectList);
    } else {
      filteredApdSelectList.assignAll(apdSelectList.where((apd) {
        return apd.code.toLowerCase().contains(query) ||
            apd.category.toLowerCase().contains(query) ||
            apd.name.toLowerCase().contains(query);
      }).toList());
    }
  }

  Future<void> saveDraftApdRequest() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSaveDraftApd(true);

    var param = ApdRequestParam(
      id: 'ARQ/2025/II/001',
      unit: 'Unit Kalimantan',
      date: dateC.value.text,
      note: noteC.value.text,
      status: selectedStatus.value ?? '',
      reqList: apdReqList,
    );

    var listC = Get.find<ApdRequestController>();
    listC.apdReq.add(param);
    listC.filteredApdReq.assignAll(listC.apdReq);
    listC.refresh();

    log("LIST LENGTH : ${listC.apdReq.length}");
    loadingSaveDraftApd(false);
    Get.back();
    listC.update();
    Utils.showSuccess(msg: '');
  }

  Future<void> sendApdRequest() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);

    var param = ApdRequestParam(
      id: 'ARQ/2025/II/001',
      unit: 'Unit Kalimantan',
      date: dateC.value.text,
      note: noteC.value.text,
      status: selectedStatus.value ?? '',
      reqList: apdReqList,
    );

    var listC = Get.find<ApdRequestController>();
    listC.apdReq.add(param);
    listC.filteredApdReq.assignAll(listC.apdReq);
    listC.refresh();

    log("LIST LENGTH : ${listC.apdReq.length}");
    loadingSendApd(false);
    Get.back();
    listC.update();
    Utils.showSuccess(msg: '');
  }

  Future<void> editSendApdRequest(int i) async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);

    var param = ApdRequestParam(
      id: 'ARQ/2025/II/001',
      unit: 'Unit Kalimantan',
      date: dateC.value.text,
      note: noteC.value.text,
      status: selectedStatus.value ?? '',
      reqList: apdReqList,
    );

    var listC = Get.find<ApdRequestController>();
    listC.apdReq.replaceRange(i, i + 1, [param]);
    listC.filteredApdReq.assignAll(listC.apdReq);
    listC.refresh();

    log("LIST LENGTH : ${listC.apdReq.length}");
    loadingSendApd(false);
    Get.back();
    Get.back();
    listC.update();
    Utils.showSuccess(msg: '');
  }

  Future<void> addApdRequest() async {
    loadingAddApd(true);

    apdReqList.add(
      ApdRequestModel(
        code: searchC.value.text,
        name: apdNameC.value.text,
        qty: amountC.value.text,
      ),
    );

    searchC.value.clear();
    apdNameC.value.clear();
    amountC.value.clear();
    loadingAddApd(false);

    update();
    Get.back();
  }

  Future<void> editApdRequest(int i) async {
    loadingAddApd(true);

    apdReqList.replaceRange(i, i + 1, [
      ApdRequestModel(
        code: 'APD${i + 1}',
        name: apdNameC.value.text,
        qty: amountC.value.text,
      ),
    ]);

    searchC.value.clear();
    apdNameC.value.clear();
    amountC.value.clear();
    loadingAddApd(false);

    update();
    Get.back();
  }

  Future<void> deleteApdRequest(int i) async {
    loadingAddApd(true);

    apdReqList.removeAt(i);
    searchC.value.clear();
    apdNameC.value.clear();
    amountC.value.clear();

    loadingAddApd(false);
    update();
  }

  void clearSearchApdField() {
    searchApdC.value.clear();
    update();
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
