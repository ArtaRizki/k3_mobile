import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
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
      appBar: AppAppbar.basicAppbar(title: 'Manajemen APD'),
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
                  Get.toNamed(AppRoute.APD_REQUEST);
                },
                title: 'Permintaan APD',
                iconPath: Assets.iconsIcCardApdRequest,
              ),
              SizedBox(height: 24),
              card(
                onTap: () async {
                  Get.toNamed(AppRoute.APD_RECEPTION);
                },
                title: 'Penerimaan APD',
                iconPath: Assets.iconsIcCardApdReception,
              ),
              SizedBox(height: 24),
              card(
                onTap: () async {
                  Get.toNamed(AppRoute.APD_RETURN);
                },
                title: 'Pengembalian APD',
                iconPath: Assets.iconsIcCardApdReturn,
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
          Image.asset(iconPath, width: 36, height: 36),
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
