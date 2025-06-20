import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/view/apd_view.dart';
import 'package:k3_mobile/src/guide/view/guide_view.dart';
import 'package:k3_mobile/src/home/view/home_view.dart';
import 'package:k3_mobile/src/inspection/view/inspection_view.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';
import 'package:k3_mobile/src/profile/view/profile_view.dart';

class MainHomeView extends GetView<MainHomeController> {
  MainHomeView({super.key});

  final List<Widget> _pages = [
    HomeView(),
    InspectionView(),
    ApdView(),
    GuideView(),
    ProfileView(),
  ];

  final List<String> _labels = [
    'Beranda',
    'Inspeksi',
    'APD',
    'Pedoman',
    'Profil',
  ];

  final List<String> _icons = [
    Assets.iconsIcHome,
    Assets.iconsIcInspection,
    Assets.iconsIcApd,
    Assets.iconsIcGuide,
    Assets.iconsIcProfile,
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;

      return Scaffold(
        body: _pages[selectedIndex],
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: SizedBox(
            height: 89,
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColor.neutralLightLightest,
              selectedItemColor: AppColor.highlightDarkest,
              unselectedItemColor: AppColor.neutralLightDarkest,
              showUnselectedLabels: true,
              selectedLabelStyle: AppTextStyle.actionM.copyWith(
                color: AppColor.highlightDarkest,
              ),
              unselectedLabelStyle: AppTextStyle.actionM.copyWith(
                color: AppColor.neutralLightDarkest,
              ),
              iconSize: 32,
              onTap: controller.onItemTapped,
              items: List.generate(_labels.length, (index) {
                return _navItem(
                  label: _labels[index],
                  iconPath: _icons[index],
                  isSelected: selectedIndex == index,
                );
              }),
            ),
          ),
        ),
      );
    });
  }

  BottomNavigationBarItem _navItem({
    required String label,
    required String iconPath,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        iconPath,
        width: 32,
        height: 32,
        color:
            isSelected
                ? AppColor.highlightDarkest
                : AppColor.neutralLightDarkest,
      ),
      label: label,
    );
  }
}
