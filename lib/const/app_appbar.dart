import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';

class AppAppbar {
  static PreferredSizeWidget basicAppbar({
    required String title,
  }) {
    return AppBar(
      surfaceTintColor: AppColor.neutralLightLightest,
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
        title,
        style: AppTextStyle.h4.copyWith(
          color: AppColor.neutralDarkLight,
        ),
      ),
    );
  }
}
