import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabC;
  @override
  void onInit() async {
    super.onInit();
    tabC = TabController(length: 2, vsync: this);
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    tabC.dispose();
    super.onClose();
  }
}
