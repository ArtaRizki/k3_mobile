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

  // Daftar widget untuk setiap halaman
  final List<Widget> _pages = [
    HomeView(),
    InspectionView(),
    ApdView(),
    GuideView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var selectedIndex = controller.selectedIndex.value;
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
              enableFeedback: false,
              iconSize: 32,
              backgroundColor: AppColor.neutralLightLightest,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    Assets.iconsIcHome,
                    width: 32,
                    height: 32,
                    color:
                        selectedIndex == 0
                            ? AppColor.highlightDarkest
                            : AppColor.neutralLightDarkest,
                  ),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    Assets.iconsIcInspection,
                    width: 32,
                    height: 32,
                    color:
                        selectedIndex == 1
                            ? AppColor.highlightDarkest
                            : AppColor.neutralLightDarkest,
                  ),
                  label: 'Inspeksi',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    Assets.iconsIcApd,
                    width: 32,
                    height: 32,
                    color:
                        selectedIndex == 2
                            ? AppColor.highlightDarkest
                            : AppColor.neutralLightDarkest,
                  ),
                  label: 'APD',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    Assets.iconsIcGuide,
                    width: 32,
                    height: 32,
                    color:
                        selectedIndex == 3
                            ? AppColor.highlightDarkest
                            : AppColor.neutralLightDarkest,
                  ),
                  label: 'Pedoman',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    Assets.iconsIcProfile,
                    width: 32,
                    height: 32,
                    color:
                        selectedIndex == 4
                            ? AppColor.highlightDarkest
                            : AppColor.neutralLightDarkest,
                  ),
                  label: 'Profil',
                ),
              ],
              currentIndex: selectedIndex,
              showUnselectedLabels: true,
              useLegacyColorScheme: false,
              selectedItemColor: AppColor.highlightDarkest,
              unselectedItemColor: AppColor.neutralLightDarkest,
              onTap: controller.onItemTapped,
              unselectedLabelStyle: AppTextStyle.actionM.copyWith(
                color: AppColor.neutralLightDarkest,
              ),
              selectedLabelStyle: AppTextStyle.actionM.copyWith(
                color: AppColor.highlightDarkest,
              ),
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      );
    });
  }
}

void main() {
  runApp(MaterialApp(home: MainHomeView()));
}
