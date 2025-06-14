import 'dart:convert';

import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/home/model/home_model.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var loading = false.obs;
  var homeModel = HomeModel().obs;
  var loginModel = Rxn<LoginModel>(); // Make it reactive

  @override
  void onInit() async {
    // Initialize from SessionController
    loginModel.value = Get.find<SessionController>().loginModel.value;
    await getData();
    super.onInit();
  }

  Future<void> getData() async {
    var prefs = await SharedPreferences.getInstance();
    var loginDataKey = prefs.getString(
      AppSharedPreferenceKey.kSetPrefLoginModel,
    );
    if (loginDataKey != null) {
      loginModel.value = LoginModel.fromJson(jsonDecode(loginDataKey));
    }

    if (!loading.value) {
      loading(true);
      try {
        final httpClient = HttpRequestClient();
        final response = await httpClient.get('/get-dashboard');

        if (response.statusCode == 200) {
          homeModel.value = HomeModel.fromJson(jsonDecode(response.body));
        } else {
          final msg = jsonDecode(response.body)['message'] ?? 'Unknown error';
          if (msg.isNotEmpty) {
            AppSnackbar.showSnackBar(Get.context!, msg, true);
          }
        }
      } catch (e) {
        print('Error in getData: $e');
        AppSnackbar.showSnackBar(Get.context!, 'Network error occurred', true);
      } finally {
        loading(false);
      }
    }
  }
}
