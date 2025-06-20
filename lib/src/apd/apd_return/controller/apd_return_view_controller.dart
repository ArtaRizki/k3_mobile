import 'dart:convert';

import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_controller.dart';
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_view_model.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApdReturnViewController extends GetxController {
  var req = HttpRequestClient();
  var loginModel = Rxn<LoginModel>(); // Make it reactive
  var loading = false.obs;
  var viewData = ApdReturnViewModel().obs;
  var indexData = 0.obs;

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  init() async {
    var prefs = await SharedPreferences.getInstance();
    var loginDataKey = prefs.getString(
      AppSharedPreferenceKey.kSetPrefLoginModel,
    );
    if (loginDataKey != null) {
      loginModel.value = LoginModel.fromJson(jsonDecode(loginDataKey));
    }
    if (Get.arguments != null) {
      await getData();
    }
  }

  Future<void> getData() async {
    if (!loading.value) {
      loading(true);
      final response = await req.post(
        '/get-data-pengembalian-barang-by-id',
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

  Future<void> setApdStatus(String status) async {
    if (!loading.value) {
      loading(true);
      final response = await req.post(
        '/set-status-pengembalian',
        body: {'id': '${Get.arguments}', 'status': status},
        // isJsonEncode: true,
      );
      if (response.statusCode == 204) {
        final msg = 'Data berhasil ${status == '99' ? 'dihapus' : 'disimpan'}';
        await Utils.showSuccess(msg: msg);
        loading(false);
        Get.find<ApdReturnController>().getData();
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
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
