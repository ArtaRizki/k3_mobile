import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/custom_date_picker.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_controller.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_param.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_view_model.dart';
import 'package:k3_mobile/src/apd/model/apd_select_model.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApdRequestCreateController extends GetxController {
  var req = HttpRequestClient();
  var loginModel = LoginModel().obs;
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
  var apdReqList = <ApdRequestParamDataApd>[].obs;
  var indexData = 0.obs;

  var viewData = ApdRequestViewModel().obs;

  var filteredApdSelectList = <ApdSelectModelData?>[].obs;

  List<String> statusList = ['Draft', 'Diajukan', 'Disetujui', 'Ditolak'];

  var apdSelectList = <ApdSelectModelData?>[].obs;

  bool validate() => dateC.value.text.isNotEmpty && apdReqList.isNotEmpty;

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
    await getSelectApd();
    // filteredApdSelectList.assignAll(apdSelectList);
    searchApdC.value.addListener(_onSearchApdChanged);
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppSharedPreferenceKey.kSetPrefLoginModel);
    if (data != null) {
      loginModel.value = LoginModel.fromJson(jsonDecode(data));
      final user = loginModel.value.data;
      log("USER NAME : ${user?.name ?? ''}");
      log("USER UNIT : ${user?.unitName ?? ''}");
      update();
    }
    if (Get.arguments != null) {
      await getData();
      isEditMode.value = true;
      final data = viewData.value.data;
      String formattedDate = data?.docDate ?? '';
      dateC.value.text = DateFormat(
        'dd-MM-yyyy',
      ).format(DateFormat('dd/MM/yyyy').parse(formattedDate));
      dateTime.value = DateFormat('dd-MM-yyyy').parse(dateC.value.text);
      noteC.value.text = data?.description ?? '';
      // selectedStatus.value = data?.docStatus;
      apdReqList.assignAll(
        data?.daftarPermintaan
                ?.map(
                  (e) => ApdRequestParamDataApd(
                    id: e?.id ?? '',
                    apdId: e?.apdId ?? '',
                    apdName: e?.apdName ?? '',
                    qty: e?.qty ?? 0,
                    code: e?.code ?? '',
                    warna: e?.warna ?? '',
                    ukuranBaju: e?.ukuranBaju ?? '',
                    ukuranCelana: e?.ukuranCelana ?? '',
                    ukuranSepatu: e?.ukuranSepatu ?? '',
                    jenisSepatu: e?.jenisSepatu ?? '',
                  ),
                )
                .toList() ??
            [],
      );
      validateForm();
    }
    update();
  }

  Future<void> getSelectApd() async {
    if (!loading.value) {
      loading(true);
      final response = await req.get('/get-data-select-apd');
      if (response.statusCode == 200) {
        apdSelectList.value =
            ApdSelectModel.fromJson(jsonDecode(response.body)).data ?? [];
        filteredApdSelectList.assignAll(apdSelectList);
        loading(false);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
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

  void _onSearchApdChanged() {
    String query = searchApdC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdSelectList.assignAll(apdSelectList);
    } else {
      filteredApdSelectList.assignAll(
        apdSelectList.where((apd) {
          return (apd?.name ?? '').toLowerCase().contains(query) ||
              (apd?.code ?? '').toLowerCase().contains(query) ||
              (apd?.warna ?? '').toLowerCase().contains(query) ||
              (apd?.ukuranBaju ?? '').toLowerCase().contains(query) ||
              (apd?.ukuranCelana ?? '').toLowerCase().contains(query) ||
              (apd?.ukuranSepatu ?? '').toLowerCase().contains(query) ||
              (apd?.jenisSepatu ?? '').toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  Future<void> saveDraftApdRequest() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSaveDraftApd(true);
    update();

    var body = ApdRequestParam(
      id: viewData.value.data?.id,
      unit: loginModel.value.data?.unitId ?? '',
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      description: noteC.value.text,
      action: 'draft',
      dataApd: apdReqList,
    );
    final response = await req.post(
      '/save-permintaan-apd',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdRequestController>().getData();
      if (viewData.value.data != null) Get.back();
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      loading(false);
      AppSnackbar.showSnackBar(Get.context!, message, true);
      throw Exception(message);
    }
    loadingSaveDraftApd(false);
  }

  Future<void> sendApdRequest() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);
    update();

    var body = ApdRequestParam(
      unit: loginModel.value.data?.unitId ?? '',
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      description: noteC.value.text,
      action: null,
      dataApd: apdReqList,
    );
    final response = await req.post(
      '/save-permintaan-apd',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdRequestController>().getData();
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      loading(false);
      AppSnackbar.showSnackBar(Get.context!, message, true);
      throw Exception(message);
    }
    loadingSendApd(false);
  }

  Future<void> editSendApdRequest() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);
    update();

    var body = ApdRequestParam(
      id: viewData.value.data?.id,
      unit: loginModel.value.data?.unitId ?? '',
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      description: noteC.value.text,
      action: null,
      dataApd: apdReqList,
    );
    final response = await req.post(
      '/save-permintaan-apd',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdRequestController>().getData();
      Get.back();
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      loading(false);
      AppSnackbar.showSnackBar(Get.context!, message, true);
      throw Exception(message);
    }
    loadingSendApd(false);
  }

  Future<void> addApdRequest() async {
    loadingAddApd(true);
    log("ADDED APD : ${searchC.value.text}");
    for (var item in apdSelectList) {
      log("APD SELECT LIST : ${item?.id}");
    }
    final getApd =
        (filteredApdSelectList.where(
          (e) => e?.code == searchC.value.text,
        )).first;
    log("ADDED APD : ${getApd?.id ?? ''}");
    apdReqList.add(
      ApdRequestParamDataApd(
        id: getApd?.id ?? '',
        apdId: getApd?.id ?? '',
        apdName: apdNameC.value.text,
        qty: int.parse(amountC.value.text),
        code: searchC.value.text,
        warna: getApd?.warna ?? '',
        ukuranBaju: getApd?.ukuranBaju ?? '',
        ukuranCelana: getApd?.ukuranCelana ?? '',
        ukuranSepatu: getApd?.ukuranSepatu ?? '',
        jenisSepatu: getApd?.jenisSepatu ?? '',
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
    log("ADDED APD : ${searchC.value.text}");
    for (var item in apdSelectList) {
      log("APD SELECT LIST : ${item?.id}");
    }
    final getApd =
        (filteredApdSelectList.where(
          (e) => e?.code == searchC.value.text,
        )).first;
    log("ADDED APD : ${getApd?.id ?? ''}");
    apdReqList.replaceRange(i, i + 1, [
      ApdRequestParamDataApd(
        id: getApd?.id ?? '',
        apdId: getApd?.id ?? '',
        apdName: apdNameC.value.text,
        qty: int.parse(amountC.value.text),
        code: searchC.value.text,
        warna: getApd?.warna ?? '',
        ukuranBaju: getApd?.ukuranBaju ?? '',
        ukuranCelana: getApd?.ukuranCelana ?? '',
        ukuranSepatu: getApd?.ukuranSepatu ?? '',
        jenisSepatu: getApd?.jenisSepatu ?? '',
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
    apdSelectList.removeAt(i);
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
