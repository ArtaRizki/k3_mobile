import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/notification/model/notification_model.dart';
import 'dart:convert';
import 'package:k3_mobile/component/http_request_client.dart';

class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var req = HttpRequestClient();
  var loading = false.obs;
  var notificationModel = NotificationModel().obs;
  late TabController tabC;
  @override
  void onInit() async {
    tabC = TabController(length: 2, vsync: this);
    await getData();
    super.onInit();
  }

  Future<void> getData() async {
    if (!loading.value) {
      loading(true);
      try {
        final response = await req.get('/get-notifikasi');

        if (response.statusCode == 200) {
          notificationModel.value = NotificationModel.fromJson(
            jsonDecode(response.body),
          );
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

  @override
  void onReady() async {
    super.onReady();
    await getData();
  }

  @override
  void onClose() async {
    tabC.dispose();
    super.onClose();
  }
}
