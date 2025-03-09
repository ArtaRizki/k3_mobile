import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/custom_date_picker.dart';
import 'package:k3_mobile/component/custom_image_picker.dart';
import 'package:k3_mobile/component/utils.dart';

class ApdReturnCreateController extends GetxController {
  var loading = false.obs;
  var isExpanded = false.obs;
  var isValidated = false.obs;

  final unitC = TextEditingController(text: 'Kalimantan').obs,
      dateC = TextEditingController().obs,
      timeC = TextEditingController().obs,
      categoryC = TextEditingController().obs,
      riskC = TextEditingController().obs,
      eventLocationC = TextEditingController().obs,
      eventChronologyC = TextEditingController().obs,
      reasonC = TextEditingController().obs,
      actionDetailC = TextEditingController().obs,
      givenRecommendationC = TextEditingController().obs;
  var actionTakenYes = true.obs;
  var actionTakenNo = false.obs;
  var pictureList = <File>[].obs;
  var dateTime = Rx<DateTime?>(null);

  var selectedCategory = Rx<String?>(null);

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
        // timeC.value.text = DateFormat('HH:mm').format(dateTime.value!);
        timeC.value.text =
            '${time.hour < 10 ? '0${time.hour}' : time.hour} ${time.minute < 10 ? '0${time.minute}' : time.minute}';
      }
    } else {
      Utils.showFailed(msg: 'Harap Pilih Tanggal Terlebih Dahulu');
    }
    update();
  }

  Future<void> sendApdReturn() async {
    loading(true);
    await Future.delayed((Duration(seconds: 3)));
    loading(false);
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
