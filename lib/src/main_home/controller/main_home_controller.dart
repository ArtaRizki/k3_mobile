import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/view/apd_view.dart';
import 'package:k3_mobile/src/guide/view/guide_view.dart';
import 'package:k3_mobile/src/home/view/home_view.dart';
import 'package:k3_mobile/src/inspection/view/inspection_view.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:k3_mobile/src/profile/view/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainHomeController extends GetxController {
  var selectedIndex = 0.obs;
  var loginModel = Rxn<LoginModel>();
  var isLoading = true.obs; // Tambahkan loading state

  // Reactive lists
  var pages = <Widget>[].obs;
  var labels = <String>[].obs;
  var icons = <String>[].obs;

  // Original data
  final List<Widget> _originalPages = [
    HomeView(),
    InspectionView(),
    ApdView(),
    GuideView(),
    ProfileView(),
  ];

  final List<String> _originalLabels = [
    'Beranda',
    'Inspeksi',
    'APD',
    'Pedoman',
    'Profil',
  ];

  final List<String> _originalIcons = [
    Assets.iconsIcHome,
    Assets.iconsIcInspection,
    Assets.iconsIcApd,
    Assets.iconsIcGuide,
    Assets.iconsIcProfile,
  ];

  onItemTapped(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize dengan data original
    pages.value = List.from(_originalPages);
    labels.value = List.from(_originalLabels);
    icons.value = List.from(_originalIcons);
    // Panggil init tanpa await
    init();
  }

  init() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var loginDataKey = prefs.getString(
        AppSharedPreferenceKey.kSetPrefLoginModel,
      );

      if (loginDataKey != null) {
        loginModel.value = LoginModel.fromJson(jsonDecode(loginDataKey));
      }

      final roleName = loginModel.value?.data?.roleName;

      if (roleName != null &&
          (roleName == 'Pelaksana Mkp' || roleName == 'Pelaksana Non Mkp')) {
        removeMenu(2);
      }
    } catch (e) {
      print('Error initializing MainHomeController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  removeMenu(int index) {
    if (index < labels.length && index < icons.length && index < pages.length) {
      labels.removeAt(index);
      icons.removeAt(index);
      pages.removeAt(index);

      // Reset selected index jika diperlukan
      if (selectedIndex.value >= pages.length) {
        selectedIndex.value = 0;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
