import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';

class InspectionView extends GetView {
  InspectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final roleName =
        Get.find<MainHomeController>().loginModel.value?.data?.roleName;
    return Scaffold(
      backgroundColor: AppColor.neutralLightLightest,
      appBar: AppAppbar.basicAppbar(title: 'Inspeksi', noBack: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (roleName != 'Pelaksana Non MKP')
                _buildCard(
                  title: 'Inspeksi Rutin',
                  iconPath: Assets.iconsIcCardRoutineInspection,
                  onTap: () => Get.toNamed(AppRoute.INSPECTION_ROUTINE),
                ),
              if (roleName != 'Pelaksana Non MKP') const SizedBox(height: 24),
              _buildCard(
                title: 'Inspeksi Proyek',
                iconPath: Assets.iconsIcCardProjectInspection,
                onTap: () => Get.toNamed(AppRoute.INSPECTION_PROJECT),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return AppCard.basicCard(
      onTap: onTap,
      radius: 24,
      padding: const EdgeInsets.all(24),
      color: AppColor.highlightLightest,
      child: Row(
        children: [
          Image.asset(iconPath, width: 32, height: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.actionL.copyWith(
                color: AppColor.neutralDarkMedium,
              ),
            ),
          ),
          Image.asset(Assets.iconsIcArrowRight, width: 12, height: 24),
        ],
      ),
    );
  }
}
