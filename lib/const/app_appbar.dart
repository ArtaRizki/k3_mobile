import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';

class AppAppbar {
  static PreferredSizeWidget basicAppbar({
    required String title,
    List<Widget>? action,
    bool centerTitle = true,
    TextStyle? titleStyle,
    double? titleSpacing,
    GestureTapCallback? onBack,
    PreferredSizeWidget? bottom,
  }) {
    return AppBar(
      surfaceTintColor: AppColor.neutralLightLightest,
      backgroundColor: AppColor.neutralLightLightest,
      leadingWidth: 72,
      titleSpacing: titleSpacing,
      leading: InkWell(
        onTap: onBack ??
            () async {
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
      centerTitle: centerTitle,
      title: Text(
        title,
        style: titleStyle ??
            AppTextStyle.h4.copyWith(
              color: AppColor.neutralDarkLight,
            ),
      ),
      actions: action,
      bottom: bottom,
    );
  }
}
