import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        backgroundColor: AppColor.neutralLightLightest,
        leadingWidth: 72,
        leading: InkWell(
          onTap: () async {
            Get.back();
          },
          child: SizedBox(
            width: 24,
            height: 24,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Transform.scale(
                scale: 0.5,
                child: Image.asset(
                  Assets.iconsIcArrowBack,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Inspeksi',
          style: AppTextStyle.h4.copyWith(
            color: AppColor.neutralDarkLight,
          ),
        ),
      ),
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
              AppCard.basicCard(
                onTap: () async {
                  Get.toNamed(AppRoute.INSPECTION_ROUTINE);
                },
                radius: 24,
                padding: EdgeInsets.all(24),
                color: AppColor.highlightLightest,
                child: Row(
                  children: [
                    Image.asset(
                      Assets.iconsIcCardRoutineInspection,
                      width: 32,
                      height: 32,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Inspeksi Rutin',
                          style: AppTextStyle.actionL.copyWith(
                            color: AppColor.neutralDarkMedium,
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      Assets.iconsIcArrowRight,
                      width: 12,
                      height: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              AppCard.basicCard(
                onTap: () async {
                  Get.toNamed(AppRoute.INSPECTION_PROJECT);
                },
                radius: 24,
                padding: EdgeInsets.all(24),
                color: AppColor.highlightLightest,
                child: Row(
                  children: [
                    Image.asset(
                      Assets.iconsIcCardProjectInspection,
                      width: 36,
                      height: 36,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Inspeksi Proyek',
                          style: AppTextStyle.actionL.copyWith(
                            color: AppColor.neutralDarkMedium,
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      Assets.iconsIcArrowRight,
                      width: 12,
                      height: 24,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
