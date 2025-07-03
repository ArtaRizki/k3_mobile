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
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_controller.dart';
import 'package:k3_mobile/src/apd/apd_reception/model/apd_reception_param.dart';
import 'package:k3_mobile/src/apd/apd_reception/model/apd_reception_view_model.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_view_model.dart';
import 'package:k3_mobile/src/apd/model/expenditure_select_model.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class ApdReceptionCreateController extends GetxController {
  loc.Location location = loc.Location();
  var currentPosition = LatLng(0, 0).obs;
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
  var signature = Rxn<File>();
  var dateTime = Rx<DateTime?>(null);
  var selectedStatus = Rx<String?>(null);

  var apdRecListC = <TextEditingController>[];

  // for create
  var apdRequestViewModel = ApdRequestViewModel().obs;
  // for send and edit
  var apdRecList = <ApdReceptionParamDataApdReceive>[].obs;
  var indexData = 0.obs;

  var viewData = ApdReceptionViewModel().obs;

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
    // if (noteC.value.text.isEmpty) return false;
    if (apdRecList.isEmpty) return false;
    if (apdRecListC.any((e) => e.text.isEmpty)) return false;
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

  Future<void> initImages() async {
    if (viewData.value.data != null) {
      final data = viewData.value.data?.gambarPenerimaan ?? [];
      if (data.isNotEmpty) {
        images.clear();
        update();
        for (var item in data) {
          if (item?.file != null) {
            final downloadedFile = await downloadAndCacheImage(
              item?.file ?? '',
              item?.filename ?? '',
            );
            if (downloadedFile != null) images.add(downloadedFile);
          }
        }
      }
    }
    update();
  }

  Future<void> initSignature() async {
    if (viewData.value.data != null) {
      final data = viewData.value.data;
      if (data != null) {
        signature.value = await downloadAndCacheImage(
          data.fileTtd ?? '',
          data.filenameTtd ?? '',
        );
      }
    }
    update();
  }

  Future<void> init() async {
    Utils.showLoading();
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
    // for (var item in apdReqList) apdRecListC.add(TextEditingController());
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
      noteC.value.text = data?.keterangan ?? '';
      selectedApdReq.value = ApdRequestModelData(
        id: data?.permintaanId ?? '',
        docDate: data?.permintaanDate,
        code: data?.permintaanCode,
      );
      selectedExp.value = ExpenditureSelectModelData(
        id: data?.pengeluaranId,
        docDate: data?.pengeluaranDate,
        code: data?.pengeluaranCode,
      );
      update();
      // selectedStatus.value = data.status;
      // images.assignAll(data.images.map((e) => File(e)).toList());
      apdRecList.assignAll(
        data?.daftarPenerimaan?.map((e) {
              return ApdReceptionParamDataApdReceive(
                id: e?.apdId ?? '',
                name: e?.apdName ?? '',
                qtyDiterima: e?.qtyDiterima ?? 0,
                code: e?.apdCode ?? '',
                warna: e?.warna ?? '',
                ukuranBaju: e?.ukuranBaju ?? '',
                ukuranCelana: e?.ukuranCelana ?? '',
                ukuranSepatu: e?.ukuranSepatu ?? '',
                jenisSepatu: e?.jenisSepatu ?? '',
              );
            }).toList() ??
            [],
      );
      apdRecListC.assignAll(
        (data?.daftarPenerimaan ?? []).map(
          (e) => TextEditingController(text: '${e?.qtyDiterima ?? 0}'),
        ),
      );
      initImages();

      // skip signature gabisa load
      // apdReqList.assignAll(data.recList);
      validateForm();
    }
    update();
    Utils.dismissLoading();
  }

  Future<void> getSelectApdRequest() async {
    if (!loading.value) {
      loading(true);
      final response = await req.get('/get-data-permintaan');
      if (response.statusCode == 200) {
        final apdRequest = ApdRequestModel.fromJson(jsonDecode(response.body));
        final list =
            (apdRequest.data ?? [])
                .where(
                  (e) =>
                      e?.docStatus == '1' &&
                      (e?.detailPermintaan?.any(
                            (e) => (e?.qtyAvailable ?? 0) > 0,
                          ) ??
                          false),
                )
                .toList();
        apdReqSelectList.value = list;
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
        final expList = ExpenditureSelectModel.fromJson(
          jsonDecode(response.body),
        );
        final list =
            (expList.data ?? [])
                .where(
                  (e) =>
                      e?.status == 'Disetujui' &&
                      (e?.detailPengeluaran?.any(
                            (e) => (e?.qtyAvailable ?? 0) > 0,
                          ) ??
                          false),
                )
                .toList();
        expSelectList.value = list;
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
        viewData.value = ApdReceptionViewModel.fromJson(
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
          apdRecListC.add(TextEditingController(text: '${item?.qty}'));
          apdRecList.add(
            ApdReceptionParamDataApdReceive(
              id: item?.apdId,
              code: item?.code,
              name: item?.apdName,
              qtyDiterima: item?.qty,
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

  /// Shows GPS enable dialog to user
  Future<void> _showGpsDialog() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Enable GPS'),
        content: const Text('Please enable GPS to use this feature.'),
        actions: [
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings();
              Get.back();
            },
            child: const Text('Settings'),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  /// Gets current location with proper permission handling
  Future<void> getLocation() async {
    try {
      // Check and request location service
      final serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        await _showGpsDialog();
        return;
      }
      // Handle location permissions
      await _handleLocationPermissions();
      // Get current position
      final position = await _getCurrentPosition();
      if (position != null)
        currentPosition.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      // Handle errors appropriately
      debugPrint('Error getting location: $e');
      rethrow;
    }
  }

  /// Handles location permission requests and checks
  Future<void> _handleLocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  /// Gets current position with fallback to last known position
  Future<Position?> _getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          forceLocationManager: true,
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 5),
        ),
      ).timeout(const Duration(seconds: 30));
    } catch (e) {
      debugPrint('Failed to get current position, trying last known: $e');
      return await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true,
      );
    }
  }

  Future<void> saveDraftApdReception() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSaveDraftApd(true);
    update();
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

    var apdRecFinal = apdRecList;
    for (int i = 0; i < apdRecFinal.length; i++)
      apdRecFinal[i].qtyDiterima = int.tryParse(apdRecListC[i].text) ?? 0;
    update();
    await getLocation();
    var body = ApdReceptionParam(
      id: viewData.value.data?.id,
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      permintaanId: selectedApdReq.value?.id ?? '',
      pengeluaranId: selectedExp.value?.id ?? '',
      keterangan: noteC.value.text.isEmpty ? '' : noteC.value.text,
      dataApdReceive: apdRecFinal,
      buktiFoto: jsonEncode(await generateBase64Photo()),
      ttdFoto: 'data:image/jpeg;base64,${base64Image}',
      action: 'draft',
      latitude: '${currentPosition.value.latitude}',
      longitude: '${currentPosition.value.longitude}',
    );
    final response = await req.post(
      '/save-data-penerimaan',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdReceptionController>().getData();
      if (viewData.value.data != null) Get.back();
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

  Future<void> sendApdReception() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);
    update();
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

    var apdRecFinal = apdRecList;
    for (int i = 0; i < apdRecFinal.length; i++)
      apdRecFinal[i].qtyDiterima = int.tryParse(apdRecListC[i].text) ?? 0;
    update();
    await getLocation();
    var body = ApdReceptionParam(
      id: viewData.value.data?.id,
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      permintaanId: selectedApdReq.value?.id ?? '',
      pengeluaranId: selectedExp.value?.id ?? '',
      keterangan: noteC.value.text.isEmpty ? '' : noteC.value.text,
      dataApdReceive: apdRecFinal,
      buktiFoto: jsonEncode(await generateBase64Photo()),
      ttdFoto: 'data:image/jpeg;base64,${base64Image}',
      action: null,
      latitude: '${currentPosition.value.latitude}',
      longitude: '${currentPosition.value.longitude}',
    );
    final response = await req.post(
      '/save-data-penerimaan',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdReceptionController>().getData();
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
  }

  Future<void> editSendApdReception() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingSendApd(true);
    update();
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

    var apdRecFinal = apdRecList;
    for (int i = 0; i < apdRecFinal.length; i++)
      apdRecFinal[i].qtyDiterima = int.tryParse(apdRecListC[i].text) ?? 0;
    update();
    await getLocation();
    var body = ApdReceptionParam(
      id: viewData.value.data?.id ?? '',
      docDate: DateFormat(
        'yyyy-MM-dd',
      ).format(dateTime.value ?? DateTime.now()),
      permintaanId: selectedApdReq.value?.id ?? '',
      pengeluaranId: selectedExp.value?.id ?? '',
      keterangan: noteC.value.text.isEmpty ? '' : noteC.value.text,
      dataApdReceive: apdRecFinal,
      buktiFoto: jsonEncode(await generateBase64Photo()),
      ttdFoto: 'data:image/jpeg;base64,${base64Image}',
      action: null,
      latitude: '${currentPosition.value.latitude}',
      longitude: '${currentPosition.value.longitude}',
    );
    final response = await req.post(
      '/save-data-penerimaan',
      body: body.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.find<ApdReceptionController>().getData();
      Get.back();
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

    // var listC = Get.find<ApdReceptionController>();
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

  /// Download dan cache file gambar dari URL menggunakan http
  Future<File?> downloadAndCacheImage(String imageUrl, String filename) async {
    // Cek apakah file sudah ada di cache
    if (images.any((e) => e.path.contains(filename))) {
      final tmp = images.where((e) => e.path.contains(filename)).first;
      final cachedFile = tmp;
      if (await cachedFile.exists()) {
        d.log("DOWNLOAD IMAGE RESPONSE : $filename EXISTED");
        return cachedFile;
      }
    }

    // Download file menggunakan http
    final response = await http.get(Uri.parse(imageUrl));
    d.log(
      "DOWNLOAD IMAGE RESPONSE : ${response.statusCode == 200 ? 'SUCCESS' : 'FAILED'}",
    );

    if (response.statusCode == 200) {
      // Simpan ke cache directory
      final file = await _saveToCache(response.bodyBytes, filename);
      return file;
    } else {
      d.log('Error downloading $filename image: $e');
    }

    return null;
  }

  /// Simpan bytes ke cache directory
  Future<File> _saveToCache(Uint8List bytes, String filename) async {
    final cacheDir = await getTemporaryDirectory();
    final file = File(path.join(cacheDir.path, 'apd_images', filename));

    // Buat directory jika belum ada
    await file.parent.create(recursive: true);

    // Tulis file
    return await file.writeAsBytes(bytes);
  }

  /// Get cached file by filename
  File? getCachedFile(String filename) {
    final tmp = images.where((e) => e.path.contains(filename)).first;
    return tmp;
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final apdImagesDir = Directory(path.join(cacheDir.path, 'apd_images'));

      if (await apdImagesDir.exists()) {
        await apdImagesDir.delete(recursive: true);
      }
    } catch (e) {
      d.log('Error clearing cache: $e');
    }
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
