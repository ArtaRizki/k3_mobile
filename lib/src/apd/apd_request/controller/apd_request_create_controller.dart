import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/custom_date_picker.dart';
import 'package:k3_mobile/component/custom_image_picker.dart';
import 'package:k3_mobile/component/utils.dart';

class ApdRequestCreateController extends GetxController {
  var loading = false.obs;
  var loadingSendApd = false.obs;
  var loadingSaveDraftApd = false.obs;
  var loadingAddApd = false.obs;
  var isExpanded = false.obs;
  var isValidated = false.obs;
  var isValidatedAddApd = false.obs;

  final searchC = TextEditingController().obs,
      searchApdC = TextEditingController().obs,
      dateC = TextEditingController().obs,
      noteC = TextEditingController().obs,
      apdNameC = TextEditingController().obs,
      amountC = TextEditingController().obs;
  // var pictureList = <File>[].obs;
  var dateTime = Rx<DateTime?>(null);

  bool validate() {
    if (dateC.value.text.isEmpty) return false;
    // if (pictureList.isEmpty) return false;
    return true;
  }

  validateForm() {
    isValidated.value = validate();
    log("IS VALIDATED : ${isValidated.value}");
    update();
  }

  bool validateAddApd() {
    if (apdNameC.value.text.isEmpty) return false;
    if (amountC.value.text.isEmpty) return false;
    return true;
  }

  validateAddApdForm() {
    isValidatedAddApd.value = validateAddApd();
    update();
  }

  addPicture() async {
    var file = await CustomImagePicker.cameraOrGallery(Get.context!);
    if (file != null) {
      // pictureList.add(file);
    }
    update();
  }

  removePicture(int i) {
    // pictureList.removeAt(i);
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
        // dateC.value.text = '${date.day}-${date.month}-${date.year}';
        // timeC.value.text = DateFormat('HH:MM').format(date);
        // timeC.value.text = '${date.hour} ${date.minute}';
      }
    }
    update();
  }

  pickTime() async {
    if (Get.context != null && dateTime.value != null) {
      var time = await CustomDatePicker.pickTime(Get.context!);
      if (time != null) {
        dateTime.value?.add(Duration(hours: time.hour, minutes: time.minute));
      }
    } else {
      Utils.showFailed(msg: 'Harap Pilih Tanggal Terlebih Dahulu');
    }
    update();
  }

  Future<void> saveDraftApdRequest() async {
    loadingSaveDraftApd(true);
    await Future.delayed((Duration(seconds: 3)));
    loadingSaveDraftApd(false);
    Utils.showSuccess(msg: '');
  }

  Future<void> sendApdRequest() async {
    loadingSendApd(true);
    await Future.delayed((Duration(seconds: 3)));
    loadingSendApd(false);
    Utils.showSuccess(msg: '');
  }

  Future<void> addApdRequest() async {
    loadingAddApd(true);
    await Future.delayed((Duration(seconds: 3)));
    loadingAddApd(false);
    Utils.showSuccess(msg: '');
  }

  List<String> categoryList = [
    'Unsafe Action',
    'Near Miss',
    'Safety Suggestion',
    'Positive Action',
  ];

  @override
  void onInit() async {
    super.onInit();
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
