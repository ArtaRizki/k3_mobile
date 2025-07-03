import 'dart:convert';

import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/home/model/home_model.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:k3_mobile/src/notification/model/notification_model.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var req = HttpRequestClient();
  var loading = false.obs;
  var homeModel = HomeModel().obs;
  var loginModel = Rxn<LoginModel>(); // Make it reactive
  var notificationCount = 0.obs;

  @override
  void onInit() async {
    // Initialize from SessionController
    loginModel.value = Get.find<SessionController>().loginModel.value;
    await getData();
    super.onInit();
  }

  void updateNotificationCount(int count) {
    notificationCount.value = count;
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
      getNotification();
      loading(true);
      try {
        final response = await req.get('/get-dashboard');

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

  Future<void> getNotification() async {
    if (!loading.value) {
      loading(true);
      try {
        final response = await req.get('/get-notifikasi');

        if (response.statusCode == 200) {
          var notifList =
              NotificationModel.fromJson(jsonDecode(response.body)).data ?? [];
          notificationCount.value =
              notifList.where((e) => e?.status == '0').toList().length;
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
