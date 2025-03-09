import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';

class ApdView extends GetView {
  ApdView({super.key});

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
          'Manajemen APD',
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
                  Get.toNamed(AppRoute.APD_REQUEST);
                },
                radius: 24,
                padding: EdgeInsets.all(24),
                color: AppColor.highlightLightest,
                child: Row(
                  children: [
                    Image.asset(
                      Assets.iconsIcCardApdRequest,
                      width: 32,
                      height: 32,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Permintaan APD',
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
                  Get.toNamed(AppRoute.APD_RECEPTION);
                },
                radius: 24,
                padding: EdgeInsets.all(24),
                color: AppColor.highlightLightest,
                child: Row(
                  children: [
                    Image.asset(
                      Assets.iconsIcCardApdReception,
                      width: 36,
                      height: 36,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Penerimaan APD',
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
                  Get.toNamed(AppRoute.APD_RETURN);
                },
                radius: 24,
                padding: EdgeInsets.all(24),
                color: AppColor.highlightLightest,
                child: Row(
                  children: [
                    Image.asset(
                      Assets.iconsIcCardApdReturn,
                      width: 36,
                      height: 36,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Pengembalian APD',
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
            ],
          ),
        ),
      ),
    );
  }
}
