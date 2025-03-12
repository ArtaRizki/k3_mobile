import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';

class InspectionView extends GetView {
  InspectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutralLightLightest,
      appBar: AppAppbar.basicAppbar(title: 'Inspeksi'),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              card(
                onTap: () async {
                  Get.toNamed(AppRoute.INSPECTION_ROUTINE);
                },
                title: 'Inspeksi Rutin',
                iconPath: Assets.iconsIcCardRoutineInspection,
              ),
              SizedBox(height: 24),
              card(
                onTap: () async {
                  Get.toNamed(AppRoute.INSPECTION_PROJECT);
                },
                title: 'Inspeksi Proyek',
                iconPath: Assets.iconsIcCardProjectInspection,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget card({
    required GestureTapCallback onTap,
    required String title,
    required String iconPath,
  }) {
    return AppCard.basicCard(
      onTap: onTap,
      radius: 24,
      padding: EdgeInsets.all(24),
      color: AppColor.highlightLightest,
      child: Row(
        children: [
          Image.asset(iconPath, width: 32, height: 32),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: AppTextStyle.actionL.copyWith(
                  color: AppColor.neutralDarkMedium,
                ),
              ),
            ),
          ),
          Image.asset(Assets.iconsIcArrowRight, width: 12, height: 24),
        ],
      ),
    );
  }
}
