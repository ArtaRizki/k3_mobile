import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/custom_date_picker.dart';
import 'package:k3_mobile/component/custom_image_picker.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/multipart.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/controller/inspection_routine_controller.dart';
import 'package:k3_mobile/src/inspection/model/inspection_param.dart';

class InspectionRoutineCreateController extends GetxController {
  var req = HttpRequestClient();
  var loading = false.obs;
  var isValidated = false.obs;
  var isViewMode = false.obs;

  final unitC = TextEditingController(text: 'INS/2025/II/002').obs,
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

  var viewData =
      InspectionParam().obs;

  List<String> categoryList = [
    'Unsafe Action',
    'Unsafe Condition',
    'Near Miss',
    'Safety Suggestion',
    'Positive Action',
  ];

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  init() async {
    if (Get.arguments != null) {
      isViewMode.value = true;
      viewData.value = Get.arguments;
      final data = viewData.value;
      // unitC.value.text = data.unit;
      // dateC.value.text = data.date;
      // dateTime.value = DateFormat('dd/MM/yyyy').parse(data.date);
      // timeC.value.text = data.time;
      // categoryC.value.text = data.category;
      // riskC.value.text = data.risk;
      // eventLocationC.value.text = data.location;
      // eventChronologyC.value.text = data.eventDescription;
      // if (data.actionTaken) {
      //   actionTakenYes.value = true;
      //   actionTakenNo.value = false;
      // } else {
      //   actionTakenNo.value = true;
      //   actionTakenYes.value = false;
      // }
      // reasonC.value.text = data.reason;
      // actionDetailC.value.text = data.actionDetails;
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
        dateTime.value?.add(Duration(hours: time.hour, minutes: time.minute));
        timeC.value.text =
            '${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}';
      }
    } else {
      Utils.showFailed(msg: 'Harap Pilih Tanggal Terlebih Dahulu');
    }
    update();
  }

  Future<void> sendInspectionRoutine() async {
    loading(true);
    var param = InspectionParam();
    var body = param.toJson();

    List<http.MultipartFile> files = [];
    if (pictureList.isNotEmpty) {
      for (int i = 0; i < pictureList.length; i++) {
        final item = pictureList[i];
        files.add(await getMultipart('upload[$i]', File(item.path)));
      }
    }
    // menunggu api
    // --------
    // final response = await req.post(
    //     // Constant.BASE_API_FULL + '/${isEdit ? 'edit' : 'create'}produkseller',
    //     'create',
    //     body: body,
    //     files: files.isEmpty ? null : files);

    // if (response.statusCode == 201 || response.statusCode == 200) {
    //   // productDetailSellerModel =
    //   //     ProdukDetailSellerModel.fromJson(jsonDecode(response.body));
    //   update();
    //   loading(false);
    // } else {
    //   final message = jsonDecode(response.body)["messages"]["error"];
    //   loading(false);
    //   throw Exception(message);
    // }
    var listC = Get.find<InspectionRoutineController>();
    // listC.inspections.add(dataForList);
    // listC.inspectionsCreate.add(param);

    listC.filteredInspections.assignAll(listC.inspectionsCreate);
    listC.refresh();
    log("LIST LENGTH : ${listC.inspectionsCreate.length}");
    await Future.delayed((Duration(seconds: 3)));
    loading(false);
    Get.back();
    listC.update();
    Utils.showSuccess(msg: '');
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
