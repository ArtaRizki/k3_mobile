import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';

class MainHomeView extends GetView<MainHomeController> {
  MainHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value)
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      final selectedIndex = controller.selectedIndex.value;
      return Scaffold(
        body:
            controller.pages.isNotEmpty
                ? controller.pages[selectedIndex]
                : Center(child: Text('No pages available')),
        bottomNavigationBar:
            controller.labels.isNotEmpty
                ? Theme(
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
                      items: List.generate(controller.labels.length, (index) {
                        return _navItem(
                          label: controller.labels[index],
                          iconPath: controller.icons[index],
                          isSelected: selectedIndex == index,
                        );
                      }),
                    ),
                  ),
                )
                : null,
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
