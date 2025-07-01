import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_page.dart';
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

  Future<void> navigateDetailNotification(NotificationModelData? item) async {
    if (item?.inspeksiId != null)
      Get.toNamed(
        AppRoute.INSPECTION_ROUTINE_CREATE,
        arguments: item?.inspeksiId,
      );
    // else if (item?.inspeksiId != null)
    //   Get.toNamed(AppRoute.INSPECTION_PROJECT_CREATE, arguments: item?.id);
    else if (item?.trsRequestId != null)
      Get.toNamed(AppRoute.APD_REQUEST_VIEW, arguments: item?.trsRequestId);
    else if (item?.trsReceiveMaterialId != null)
      Get.toNamed(
        AppRoute.APD_RECEPTION_VIEW,
        arguments: item?.trsReceiveMaterialId,
      );
    else if (item?.trsGoodReturnId != null)
      Get.toNamed(
        AppRoute.APD_RECEPTION_VIEW,
        arguments: item?.trsGoodReturnId,
      );
  }

  Future<void> readNotification(String id) async {
    if (!loading.value) {
      loading(true);
      try {
        final response = await req.post(
          '/save-read-notification',
          body: {'id': id},
        );

        if (response.statusCode != 200) {
          final msg = jsonDecode(response.body)['message'] ?? 'Unknown error';
          if (msg.isNotEmpty) {
            AppSnackbar.showSnackBar(Get.context!, msg, true);
          }
        } else {
          getData();
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
