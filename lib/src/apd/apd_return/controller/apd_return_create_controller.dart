import 'dart:convert';
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
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_controller.dart';
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_param.dart';
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_view_model.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_view_model.dart';
import 'package:k3_mobile/src/apd/model/expenditure_select_model.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApdReturnCreateController extends GetxController {
  var req = HttpRequestClient();
  var loginModel = Rxn<LoginModel>(); // Make it reactive
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

  // for create
  var apdRequestViewModel = ApdRequestViewModel().obs;
  // for send and edit
  var apdRetList = <ApdReturnParamDataApdRtn>[].obs;
  var indexData = 0.obs;

  var viewData = ApdReturnViewModel().obs;

  var filteredApdReqSelectList = <ApdRequestModelData?>[].obs;
  var filteredExpSelectList = <ExpenditureSelectModelData?>[].obs;

  var apdReqSelectList = <ApdRequestModelData?>[].obs;
  var expSelectList = <ExpenditureSelectModelData?>[].obs;

  var selectedApdReq = Rx<ApdRequestModelData?>(null);
  var selectedExp = Rx<ExpenditureSelectModelData?>(null);

  List<String> statusList = ['Draft', 'Diajukan', 'Disetujui', 'Ditolak'];

  Future<bool> validate() async {
    if (dateC.value.text.isEmpty) return false;
    if (apdReqNumberC.value.text.isEmpty) return false;
    if (expNumberC.value.text.isEmpty) return false;
    if (vendorC.value.text.isEmpty) return false;
    if (noteC.value.text.isEmpty) return false;
    if (apdRetList.isEmpty) return false;
    if (images.isEmpty) return false;
    var file = await signKey.value.currentState!.getData();
    if (file.height <= 0) return false;
    return true;
  }

  validateForm() async {
    isValidated.value = await validate();
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
    var prefs = await SharedPreferences.getInstance();
    var loginDataKey = prefs.getString(
      AppSharedPreferenceKey.kSetPrefLoginModel,
    );
    if (loginDataKey != null) {
      loginModel.value = LoginModel.fromJson(jsonDecode(loginDataKey));
    }
    await getSelectApdRequest();
    await getSelectExpenditure();
    // filteredApdReqSelectList.assignAll(apdReqSelectList);
    searchApdRequestC.value.addListener(_onSearchApdChanged);
    // filteredExpSelectList.assignAll(expSelectList);
    searchExpenditureC.value.addListener(_onSearchExpChanged);

    // add daftar apd TextEditingController
    // for (var item in apdReqList) apdRetListC.add(TextEditingController());
    // jika edit mode
    if (Get.arguments != null) {
      await getData();
      isEditMode.value = true;
      final data = viewData.value.data;
      String formattedDate = data?.docDate ?? '';
      dateC.value.text = DateFormat(
        'dd-MM-yyyy',
      ).format(DateFormat('dd/MM/yyyy').parse(formattedDate));
      dateTime.value = DateFormat('dd-MM-yyyy').parse(dateC.value.text);
      apdReqNumberC.value.text = data?.permintaanCode ?? '';
      expNumberC.value.text = data?.pengeluaranCode ?? '';
      vendorC.value.text = data?.vendorName ?? '';
      noteC.value.text = data?.description ?? '';
      // selectedStatus.value = data.status;
      // images.assignAll(data.images.map((e) => File(e)).toList());
      apdRetList.assignAll(
        data?.daftarPengeluaran?.map((e) {
              return ApdReturnParamDataApdRtn(
                id: e?.apdId ?? '',
                name: e?.apdName ?? '',
                qtyDikembalikan: e?.qtyDikembalikan ?? 0,
                code: e?.code ?? '',
                warna: e?.warna ?? '',
                ukuranBaju: e?.ukuranBaju ?? '',
                ukuranCelana: e?.ukuranCelana ?? '',
                ukuranSepatu: e?.ukuranSepatu ?? '',
                jenisSepatu: e?.jenisSepatu ?? '',
              );
            }).toList() ??
            [],
      );
      apdRetListC.assignAll(
        (data?.daftarPengeluaran ?? []).map(
          (e) => TextEditingController(text: '${e?.qtyDikembalikan ?? 0}'),
        ),
      );

      // skip signature gabisa load
      // apdReqList.assignAll(data.recList);
      validateForm();
    }
    update();
  }

  Future<void> getSelectApdRequest() async {
    if (!loading.value) {
      loading(true);
      final response = await req.get('/get-data-permintaan');
      if (response.statusCode == 200) {
        apdReqSelectList.value =
            ApdRequestModel.fromJson(jsonDecode(response.body)).data ?? [];
        filteredApdReqSelectList.assignAll(apdReqSelectList);
        loading(false);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  Future<void> getSelectExpenditure() async {
    if (!loading.value) {
      loading(true);
      final response = await req.get('/get-data-pengeluaran-barang');
      if (response.statusCode == 200) {
        expSelectList.value =
            ExpenditureSelectModel.fromJson(jsonDecode(response.body)).data ??
            [];
        filteredExpSelectList.assignAll(expSelectList);
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
        '/get-data-penerimaan-by-id',
        body: {'id': '${Get.arguments}'},
      );
      if (response.statusCode == 200) {
        viewData.value = ApdReturnViewModel.fromJson(jsonDecode(response.body));
        loading(false);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  Future<void> getApdPermintaanById(String id) async {
    if (!loading.value) {
      loading(true);
      final response = await req.post(
        '/get-data-permintaan-by-id',
        body: {'id': '$id'},
      );
      if (response.statusCode == 200) {
        apdRequestViewModel.value = ApdRequestViewModel.fromJson(
          jsonDecode(response.body),
        );
        final daftarPermintaan =
            apdRequestViewModel.value.data?.daftarPermintaan ?? [];
        for (var item in daftarPermintaan) {
          apdRetListC.add(TextEditingController(text: '${item?.qty}'));
          apdRetList.add(
            ApdReturnParamDataApdRtn(
              id: item?.apdId,
              code: item?.code,
              name: item?.apdName,
              qtyDikembalikan: item?.qty,
              qtyJumlah: item?.qty,
              qtySisa: '${item?.qty ?? 0}',
            ),
          );
          update();
        }
        loading(false);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
        loading(false);
      }
    }
  }

  void _onSearchApdChanged() {
    String query = searchApdRequestC.value.text.toLowerCase();

    if (query.isEmpty) {
      filteredApdReqSelectList.assignAll(apdReqSelectList);
    } else {
      filteredApdReqSelectList.assignAll(
        apdReqSelectList.where((apd) {
          return (apd?.createdAt ?? '').toLowerCase().contains(query) ||
              (apd?.code ?? '').toLowerCase().contains(query) ||
              (apd?.unitName ?? '').toLowerCase().contains(query) ||
              (apd?.description ?? '').toLowerCase().contains(query) ||
              (apd?.docDate ?? '').toLowerCase().contains(query) ||
              Utils.getDocStatusName(
                (apd?.docStatus ?? ''),
              ).toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  void _onSearchExpChanged() {
    String query = searchExpenditureC.value.text.toLowerCase();
    if (query.isEmpty) {
      filteredExpSelectList.assignAll(expSelectList);
    } else {
      filteredExpSelectList.assignAll(
        expSelectList.where((exp) {
          return (exp?.code ?? '').toLowerCase().contains(query) ||
              (exp?.deskripsi ?? '').toLowerCase().contains(query) ||
              (exp?.docDate ?? '').toLowerCase().contains(query) ||
              (exp?.requestCode ?? '').toLowerCase().contains(query) ||
              (exp?.vendorName ?? '').toLowerCase().contains(query) ||
              (exp?.status ?? '').toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  Future<List<String>> generateBase64Photo() async {
    if (images.isNotEmpty) {
      List<String> list = [];
      for (int i = 0; i < images.length; i++) {
        final item = images[i];
        final byteImage = await item.readAsBytesSync();
        final base64Image = base64Encode(byteImage);
        list.add('data:image/jpeg;base64,${base64Image}');
      }
      return list;
    }
    return [];
  }

  Future<void> saveDraftApdReturn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSaveDraftApd(true);
    String base64Image = '';
    final sign = signKey.value.currentState!;
    final image = await sign.getData();
    var data = await image.toByteData(format: ImageByteFormat.png);
    final dir = await getTemporaryDirectory();
    final nameFile = '${dir.path}/signature${Random().nextInt(100)}.png';
    if (data != null) {
      base64Image = base64Encode(data.buffer.asUint8List());
      final file = File(nameFile);
      if (file.existsSync()) {
        file.deleteSync();
      }
      file.writeAsBytesSync(data.buffer.asUint8List(), flush: true);
      // sign.clear();
    } else {
      // sign.clear();
    }

    var apdRecFinal = apdRetList;
    for (int i = 0; i < apdRecFinal.length; i++)
      apdRecFinal[i].qtyDikembalikan = int.tryParse(apdRetListC[i].text) ?? 0;
    update();
    var body = ApdReturnParam(
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      requestId: selectedApdReq.value?.id ?? '',
      pengeluaranId: selectedExp.value?.id ?? '',
      description: noteC.value.text,
      dataApdRtn: apdRecFinal,
      buktiFoto: jsonEncode(await generateBase64Photo()),
      ttdFoto: 'data:image/jpeg;base64,${base64Image}',
      action: 'draft',
    );
    final response = await req.post(
      '/save-data-pengembalian-barang',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdReturnController>().getData();
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
    loadingSaveDraftApd(false);
  }

  Future<void> sendApdReturn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);
    String base64Image = '';
    final sign = signKey.value.currentState!;
    final image = await sign.getData();
    var data = await image.toByteData(format: ImageByteFormat.png);
    final dir = await getTemporaryDirectory();
    final nameFile = '${dir.path}/signature${Random().nextInt(100)}.png';
    if (data != null) {
      base64Image = base64Encode(data.buffer.asUint8List());
      final file = File(nameFile);
      if (file.existsSync()) {
        file.deleteSync();
      }
      file.writeAsBytesSync(data.buffer.asUint8List(), flush: true);
      // sign.clear();
    } else {
      // sign.clear();
    }

    var apdRecFinal = apdRetList;
    for (int i = 0; i < apdRecFinal.length; i++)
      apdRecFinal[i].qtyDikembalikan = int.tryParse(apdRetListC[i].text) ?? 0;
    update();
    var body = ApdReturnParam(
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      requestId: selectedApdReq.value?.id ?? '',
      pengeluaranId: selectedExp.value?.id ?? '',
      description: noteC.value.text,
      dataApdRtn: apdRecFinal,
      buktiFoto: jsonEncode(await generateBase64Photo()),
      ttdFoto: 'data:image/jpeg;base64,${base64Image}',
      action: null,
    );
    final response = await req.post(
      '/save-data-pengembalian-barang',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdReturnController>().getData();
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      AppSnackbar.showSnackBar(Get.context!, message, true);
      loading(false);
      loadingSendApd(false);
      throw Exception(message);
    }
    loadingSendApd(false);
  }

  Future<void> editSendApdReturn(int i) async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);
    String base64Image = '';
    final sign = signKey.value.currentState!;
    final image = await sign.getData();
    var data = await image.toByteData(format: ImageByteFormat.png);
    final dir = await getTemporaryDirectory();
    final nameFile = '${dir.path}/signature${Random().nextInt(100)}.png';
    if (data != null) {
      base64Image = base64Encode(data.buffer.asUint8List());
      final file = File(nameFile);
      if (file.existsSync()) {
        file.deleteSync();
      }
      file.writeAsBytesSync(data.buffer.asUint8List(), flush: true);
      // sign.clear();
    } else {
      // sign.clear();
    }

    var apdRecFinal = apdRetList;
    for (int i = 0; i < apdRecFinal.length; i++)
      apdRecFinal[i].qtyDikembalikan = int.tryParse(apdRetListC[i].text) ?? 0;
    update();
    var body = ApdReturnParam(
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      requestId: selectedApdReq.value?.id ?? '',
      pengeluaranId: selectedExp.value?.id ?? '',
      description: noteC.value.text,
      dataApdRtn: apdRecFinal,
      buktiFoto: jsonEncode(await generateBase64Photo()),
      ttdFoto: 'data:image/jpeg;base64,${base64Image}',
      action: null,
    );
    final response = await req.post(
      '/save-data-pengembalian-barang',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdReturnController>().getData();
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
    loadingSendApd(false);

    // var listC = Get.find<ApdReturnController>();
    // // listC.apdReqList.add(param);
    // listC.filteredApdRec.assignAll(listC.apdRecList);
    // listC.refresh();

    // d.log("LIST LENGTH : ${listC.apdRecList.length}");
    // loadingSendApd(false);
    // Get.back();
    // listC.update();
    // Utils.showSuccess(msg: '');
    // Utils.showSuccess(msg: '');
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
