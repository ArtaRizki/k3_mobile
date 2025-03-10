import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/custom_date_picker.dart';
import 'package:k3_mobile/component/custom_image_picker.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:path_provider/path_provider.dart';

class ApdReceptionCreateController extends GetxController {
  var loading = false.obs;
  var isExpanded = false.obs;
  var isValidated = false.obs;
  var isEdit = false.obs;

  var signKey = GlobalKey<SignatureState>().obs;
  var showHintSignature = true.obs;

  var searchApdRequestC = TextEditingController().obs,
      searchOutcomeC = TextEditingController().obs,
      searchVendorC = TextEditingController().obs,
      dateC = TextEditingController().obs,
      apdReceptionNumberC = TextEditingController().obs,
      outcomeNumberC = TextEditingController().obs,
      vendorC = TextEditingController().obs,
      noteC = TextEditingController().obs;
  var pictureList = <File>[].obs;
  var dateTime = Rx<DateTime?>(null);

  bool validate() {
    if (dateC.value.text.isEmpty) return false;
    if (noteC.value.text.isEmpty) return false;
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
      }
    } else {
      Utils.showFailed(msg: 'Harap Pilih Tanggal Terlebih Dahulu');
    }
    update();
  }

  Future<void> sendApdReception() async {
    loading(true);
    // get signature
    final sign = signKey.value.currentState!;
    final image = await sign.getData();
    var data = await image.toByteData(format: ImageByteFormat.png);
    final dir = await getTemporaryDirectory();

    if (data != null) {
      final file = File('${dir.path}/signature.png');
      if (file.existsSync()) {
        file.deleteSync();
      }
      file.writeAsBytesSync(data.buffer.asUint8List(), flush: true);
      sign.clear();
    } else {
      sign.clear();
    }

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
