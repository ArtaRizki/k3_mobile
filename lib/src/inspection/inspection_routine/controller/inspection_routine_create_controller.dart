import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/custom_date_picker.dart';
import 'package:k3_mobile/component/custom_image_picker.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/controller/inspection_routine_controller.dart';
import 'package:k3_mobile/src/inspection/model/inspection_category_model.dart';
import 'package:k3_mobile/src/inspection/model/inspection_param.dart';
import 'package:k3_mobile/src/inspection/model/inspection_view_model.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionRoutineCreateController extends GetxController {
  var req = HttpRequestClient();
  var loginModel = LoginModel().obs;
  var loading = false.obs;
  var isValidated = false.obs;
  var isViewMode = false.obs;

  final unitC = TextEditingController().obs,
      dateC = TextEditingController().obs,
      timeC = TextEditingController().obs,
      categoryC = TextEditingController().obs,
      riskC = TextEditingController().obs,
      eventLocationC = TextEditingController().obs,
      eventChronologyC = TextEditingController().obs,
      reasonC = TextEditingController().obs,
      actionDetailC = TextEditingController().obs,
      givenRecommendationC = TextEditingController().obs;
  var unitId = '0'.obs;
  var categoryId = '0'.obs;
  var actionTakenYes = true.obs;
  var actionTakenNo = false.obs;
  var pictureList = <File>[].obs;
  var dateTime = Rx<DateTime?>(null);
  var selectedCategory = Rx<String?>(null);

  var viewData = InspectionParam().obs;
  var inspectionViewModelData = InspectionViewModel().obs;

  var categoryList = <InspectionCategoryModelData?>[].obs;
  // List<String> categoryList = [
  //   'Unsafe Action',
  //   'Unsafe Condition',
  //   'Near Miss',
  //   'Safety Suggestion',
  //   'Positive Action',
  // ];

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  init() async {
    await getKategori();
    if (Get.arguments != null) {
      await getData();
      isViewMode.value = true;
      // viewData.value = Get.arguments;
      final data = inspectionViewModelData.value.data;
      unitC.value.text = data?.unit ?? '';
      unitId.value = data?.unitId ?? '';
      dateC.value.text = data?.docDate ?? '';
      dateTime.value = DateFormat('dd/MM/yyyy').parse(data?.docDate ?? '');
      timeC.value.text = DateFormat('HH:mm').format(dateTime.value!);
      categoryC.value.text = data?.kategoriName ?? '';
      categoryId.value = data?.kategoriId ?? '';
      if (data?.kategoriId != null)
        selectedCategory.value = data?.kategoriId ?? '';
      update();
      refresh();
      log("selectedCategory: ${selectedCategory.value}");
      log("categoryList: ${categoryList.map((e) => e?.id).toList()}");

      // sementara
      riskC.value.text = data?.resiko ?? '';
      eventLocationC.value.text = data?.lokasi ?? '';
      eventChronologyC.value.text = data?.kronologi ?? '';
      if (data?.dilakukanTindakan == '1') {
        actionTakenYes.value = true;
        actionTakenNo.value = false;
      } else {
        actionTakenNo.value = true;
        actionTakenYes.value = false;
      }
      reasonC.value.text = data?.alasan ?? '';
      actionDetailC.value.text = data?.rincianTindakan ?? '';
      givenRecommendationC.value.text = data?.saran ?? '';
    } else {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(AppSharedPreferenceKey.kSetPrefLoginModel);
      if (data != null) {
        loginModel.value = LoginModel.fromJson(jsonDecode(data));
        final user = loginModel.value.data;
        log("USER NAME : ${user?.name ?? ''}");
        log("USER UNIT : ${user?.unitName ?? ''}");
        unitC.value.text = user?.unitName ?? '';
        unitId.value = user?.unitId ?? '';
        update();
      }
    }
  }

  Future<void> getData() async {
    if (!loading.value) {
      loading(true);
      final response = await req.post(
        '/get-data-inspeksi-by-id',
        body: {'id': '${Get.arguments}'},
      );
      if (response.statusCode == 200) {
        inspectionViewModelData.value = InspectionViewModel.fromJson(
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

  Future<void> getKategori() async {
    if (!loading.value) {
      loading(true);
      final response = await req.get('/get-data-kategori-inspeksi');
      if (response.statusCode == 200) {
        categoryList.value =
            InspectionCategoryModel.fromJson(jsonDecode(response.body)).data ??
            [];
        loading(false);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  bool validate() {
    if (unitC.value.text.isEmpty) return false;
    if (dateC.value.text.isEmpty) return false;
    if (timeC.value.text.isEmpty) return false;
    if (selectedCategory.value == null) return false;
    if (riskC.value.text.isEmpty) return false;
    if (eventLocationC.value.text.isEmpty) return false;
    if (eventChronologyC.value.text.isEmpty) return false;
    if (reasonC.value.text.isEmpty) return false;
    if (actionDetailC.value.text.isEmpty) return false;
    if (givenRecommendationC.value.text.isEmpty) return false;
    if (pictureList.isEmpty) return false;
    return true;
  }

  validateForm() {
    isValidated.value = validate();
    log("IS VALIDATED : ${isValidated.value}");
    update();
  }

  addPicture() async {
    var file = await CustomImagePicker.cameraOrGallery(Get.context!);
    if (file != null) {
      pictureList.add(file);
    }
    update();
  }

  removePicture(int i) {
    pictureList.removeAt(i);
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

  pickDate() async {
    if (Get.context != null) {
      var date = await CustomDatePicker.pickDate(Get.context!, DateTime.now());
      if (date != null) {
        dateTime.value = date;
        dateC.value.text = DateFormat('dd-MM-yyyy').format(date);
      }
    }
    update();
  }

  pickTime() async {
    if (Get.context != null && dateTime.value != null) {
      var time = await CustomDatePicker.pickTime(Get.context!);
      if (time != null) {
        dateTime.value = dateTime.value?.add(
          Duration(hours: time.hour, minutes: time.minute),
        );
        timeC.value.text =
            '${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}';
      }
    } else {
      Utils.showFailed(msg: 'Harap Pilih Tanggal Terlebih Dahulu');
    }
    update();
  }

  Future<List<String>> initFoto() async {
    if (pictureList.isNotEmpty) {
      List<String> list = [];
      for (int i = 0; i < pictureList.length; i++) {
        final item = pictureList[i];
        final byteImage = await item.readAsBytesSync();
        final base64Image = base64Encode(byteImage);
        list.add('data:image/jpeg;base64,${base64Image}');
      }
      return list;
    }
    return [];
  }

  Future<void> sendInspectionRoutine() async {
    loading(true);
    final user = loginModel.value.data;
    var param = InspectionParam(
      name: user?.name ?? '',
      type: '0',
      proyekName: '',
      karyawanId: user?.karyawan?.id ?? '',
      unitId: user?.unitId ?? '',
      docDate: DateFormat(
        'dd/MM/yyyy',
      ).format(dateTime.value ?? DateTime.now()),
      docTime: DateFormat('HH:mm').format(dateTime.value ?? DateTime.now()),
      kategori: selectedCategory.value,
      resiko: riskC.value.text,
      lokasi: eventLocationC.value.text,
      kronologi: eventChronologyC.value.text,
      action: actionTakenYes.value ? '1' : '0',
      alasan: reasonC.value.text,
      saran: givenRecommendationC.value.text,
      rincianTindakan: actionDetailC.value.text,
      foto: await initFoto(),
    );
    var body = param.toJson();
    final response = await req.post(
      '/create-inspeksi',
      body: body,
      // isJsonEncode: true,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // productDetailSellerModel =
      //     ProdukDetailSellerModel.fromJson(jsonDecode(response.body));
      update();
      loading(false);
      Get.find<InspectionRoutineController>().getData();
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      AppSnackbar.showSnackBar(Get.context!, message, true);
      loading(false);
      throw Exception(message);
    }
    // var listC = Get.find<InspectionRoutineController>();
    // listC.inspection.add(dataForList);
    // listC.inspection.add(param);

    // listC.filteredInspections.assignAll(listC.inspections);
    // listC.refresh();
    // log("LIST LENGTH : ${listC.inspections.length}");
    // await Future.delayed((Duration(seconds: 3)));

    // listC.update();
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
