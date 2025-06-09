import 'dart:developer' as d;
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/custom_date_picker.dart';
import 'package:k3_mobile/component/custom_image_picker.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_controller.dart';
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_model.dart';
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_param.dart';
import 'package:k3_mobile/src/apd/model/expenditure_select_model.dart';
import 'package:path_provider/path_provider.dart';

class ApdReturnCreateController extends GetxController {
  var req = HttpRequestClient();
  var loading = false.obs;
  var loadingSendApd = false.obs;
  var loadingSaveDraftApd = false.obs;
  var loadingAddApd = false.obs;
  var isExpanded = false.obs;
  var isValidated = false.obs;
  var isValidatedAddApd = false.obs;
  var isEditMode = false.obs;

  var signKey = GlobalKey<SignatureState>().obs;
  var showHintSignature = true.obs;

  var searchApdRequestC = TextEditingController().obs,
      searchExpenditureC = TextEditingController().obs,
      dateC = TextEditingController().obs,
      apdReqNumberC = TextEditingController().obs,
      expNumberC = TextEditingController().obs,
      vendorC = TextEditingController().obs,
      noteC = TextEditingController().obs;
  var images = <File>[].obs;
  var dateTime = Rx<DateTime?>(null);
  var selectedStatus = Rx<String?>(null);

  var apdRetListC = <TextEditingController>[];
  var apdRetList =
      <ApdReturnParamDataApdRtn>[
        // ApdReturnModel(
        //   code: 'APD001',
        //   name: 'Helm Proyek',
        //   qty: '10',
        //   remainingQty: '10',
        //   returnQty: '',
        // ),
        // ApdReturnModel(
        //   code: 'APD002',
        //   name: 'Sepatu Safety',
        //   qty: '50',
        //   remainingQty: '50',
        //   returnQty: '',
        // ),
        // ApdReturnModel(
        //   code: 'APD003',
        //   name: 'Sarung Tangan',
        //   qty: '2',
        //   remainingQty: '2',
        //   returnQty: '',
        // ),
        // ApdReturnModel(
        //   code: 'APD004',
        //   name: 'Rompi',
        //   qty: '15',
        //   remainingQty: '15',
        //   returnQty: '',
        // ),
      ].obs;
  var indexData = 0.obs;

  var viewData =
      ApdReturnParam().obs;

  var filteredApdReqSelectList = <ApdRequestModelData>[].obs;
  var filteredApdExpSelectList = <ExpenditureSelectModelData>[].obs;

  var apdReqSelectList = [
    // ApdSelect(
    //   date: '15/02/2025',
    //   reqNumber: 'ARQ/2025/II/001',
    //   note: 'Minta Helm & Rompi',
    // ),
    // ApdSelect(
    //   date: '15/02/2025',
    //   reqNumber: 'ARQ/2025/II/001',
    //   note: 'Minta Sepatu Safety',
    // ),
    // ApdSelect(
    //   date: '15/02/2025',
    //   reqNumber: 'ARQ/2025/II/001',
    //   note: 'Minta Lagi',
    // ),
  ];

  var apdExpSelectList = [
    // ExpenditureSelectModel(
    //   date: '15/02/2025',
    //   expNumber: 'GDI/2025/II/001',
    //   vendor: 'Kantor Pusat',
    // ),
    // ExpenditureSelectModel(
    //   date: '15/02/2025',
    //   expNumber: 'GDI/2025/II/001',
    //   vendor: 'Vendor A',
    // ),
    // ExpenditureSelectModel(
    //   date: '15/02/2025',
    //   expNumber: 'GDI/2025/II/001',
    //   vendor: 'Vendor B',
    // ),
  ];

  List<String> statusList = ['Draft', 'Diajukan', 'Disetujui', 'Ditolak'];

  bool validate() {
    if (dateC.value.text.isEmpty) return false;
    if (apdReqNumberC.value.text.isEmpty) return false;
    if (expNumberC.value.text.isEmpty) return false;
    if (vendorC.value.text.isEmpty) return false;
    // if (noteC.value.text.isEmpty) return false;
    // if (apdRetList.isEmpty) return false;
    // if (images.isEmpty) return false;
    // var file = await signKey.value.currentState!.getData();
    // if (file.height <= 0) return false;
    return true;
  }

  validateForm() {
    isValidated.value = validate();
    d.log("IS VALIDATED : ${isValidated.value}");
    update();
  }

  addPicture() async {
    var file = await CustomImagePicker.cameraOrGallery(Get.context!);
    if (file != null) {
      images.add(file);
    }
    update();
  }

  removePicture(int i) {
    images.removeAt(i);
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

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    // filteredApdReqSelectList.assignAll(apdReqSelectList);
    searchApdRequestC.value.addListener(_onSearchApdChanged);
    // filteredApdExpSelectList.assignAll(apdExpSelectList);
    searchExpenditureC.value.addListener(_onSearchExpChanged);

    // add daftar apd TextEditingController
    for (var item in apdRetList) apdRetListC.add(TextEditingController());
    // jika edit mode
    if (Get.arguments != null) {
      isEditMode.value = true;
      viewData.value = Get.arguments[1];
      indexData.value = Get.arguments[0];
      final data = viewData.value;
      // dateC.value.text = data.date;
      // apdReqNumberC.value.text = data.reqNumber;
      // expNumberC.value.text = data.expNumber;
      // vendorC.value.text = data.vendor;
      // noteC.value.text = data.note;
      // selectedStatus.value = data.status;
      // images.assignAll(data.images.map((e) => File(e)).toList());
      // for (var item in data.recList)
      //   apdRetListC.assignAll(
      //     data.recList
      //         .map((e) => TextEditingController(text: e.returnQty))
      //         .toList(),
      //   );
      // skip signature gabisa load
      // apdRetList.assignAll(data.recList);
      validateForm();
    }
    update();
  }

  void _onSearchApdChanged() {
    String query = searchApdRequestC.value.text.toLowerCase();
    if (query.isEmpty) {
      // filteredApdReqSelectList.assignAll(apdReqSelectList);
    } else {
      // filteredApdReqSelectList.assignAll(
      //   apdReqSelectList.where((apd) {
      //     return apd.date.toLowerCase().contains(query) ||
      //         apd.note.toLowerCase().contains(query) ||
      //         apd.reqNumber.toLowerCase().contains(query);
      //   }).toList(),
      // );
    }
  }

  void _onSearchExpChanged() {
    String query = searchExpenditureC.value.text.toLowerCase();
    if (query.isEmpty) {
      // filteredApdExpSelectList.assignAll(apdExpSelectList);
    } else {
      // filteredApdExpSelectList.assignAll(
      //   apdExpSelectList.where((exp) {
      //     return exp.date.toLowerCase().contains(query) ||
      //         exp.expNumber.toLowerCase().contains(query) ||
      //         exp.vendor.toLowerCase().contains(query);
      //   }).toList(),
      // );
    }
  }

  Future<void> saveDraftApdReturn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSaveDraftApd(true);

    var param = ApdReturnParam();

    var listC = Get.find<ApdReturnController>();
    // listC.apdRet.add(param);
    // listC.filteredapdRet.assignAll(listC.apdRet);
    listC.refresh();

    // d.log("LIST LENGTH : ${listC.apdRet.length}");
    loadingSaveDraftApd(false);
    Get.back();
    listC.update();
    Utils.showSuccess(msg: '');
  }

  Future<void> sendApdReturn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);
    // get signature
    final sign = signKey.value.currentState!;
    final image = await sign.getData();
    var data = await image.toByteData(format: ImageByteFormat.png);
    final dir = await getTemporaryDirectory();
    final nameFile = '${dir.path}/signature${Random().nextInt(100)}.png';
    if (data != null) {
      final file = File(nameFile);
      if (file.existsSync()) {
        file.deleteSync();
      }
      file.writeAsBytesSync(data.buffer.asUint8List(), flush: true);
      sign.clear();
    } else {
      sign.clear();
    }
    var param = ApdReturnParam(
      // id: 'ARQ/2025/II/001',
      // unit: 'Unit Kalimantan',
      // date: dateC.value.text,
      // note: noteC.value.text,
      // status: selectedStatus.value ?? '',
      // recList: apdRetList,
      // reqNumber: apdReqNumberC.value.text,
      // expNumber: expNumberC.value.text,
      // vendor: vendorC.value.text,
      // images: images.map((e) => e.path).toList(),
      // signature: nameFile,
    );

    var listC = Get.find<ApdReturnController>();
    // listC.apdRet.add(param);
    // listC.filteredapdRet.assignAll(listC.apdRet);
    listC.refresh();

    // d.log("LIST LENGTH : ${listC.apdRet.length}");
    loadingSendApd(false);
    Get.back();
    listC.update();
    Utils.showSuccess(msg: '');
    Utils.showSuccess(msg: '');
  }

  Future<void> editSendApdReturn(int i) async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);
    // get signature
    final sign = signKey.value.currentState!;
    final image = await sign.getData();
    var data = await image.toByteData(format: ImageByteFormat.png);
    final dir = await getTemporaryDirectory();
    final nameFile = '${dir.path}/signature${Random().nextInt(100)}.png';
    if (data != null) {
      final file = File(nameFile);
      if (file.existsSync()) {
        file.deleteSync();
      }
      file.writeAsBytesSync(data.buffer.asUint8List(), flush: true);
      sign.clear();
    } else {
      sign.clear();
    }
    var param = ApdReturnParam(
      // id: 'ARQ/2025/II/001',
      // unit: 'Unit Kalimantan',
      // date: dateC.value.text,
      // note: noteC.value.text,
      // status: selectedStatus.value ?? '',
      // recList: apdRetList,
      // reqNumber: apdReqNumberC.value.text,
      // expNumber: expNumberC.value.text,
      // vendor: vendorC.value.text,
      // images: images.map((e) => e.path).toList(),
      // signature: nameFile,
    );

    var listC = Get.find<ApdReturnController>();
    // listC.apdRet.replaceRange(i, i + 1, [param]);
    // listC.filteredapdRet.assignAll(listC.apdRet);
    listC.refresh();

    // d.log("LIST LENGTH : ${listC.apdRet.length}");
    loadingSendApd(false);
    Get.back();
    Get.back();
    listC.update();
    Utils.showSuccess(msg: '');
  }

  void clearSearchApdField() {
    searchApdRequestC.value.clear();
    update();
  }

  void clearSearchExpField() {
    searchExpenditureC.value.clear();
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
