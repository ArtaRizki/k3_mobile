import 'package:flutter/material.dart';
import 'package:k3_mobile/const/app_color.dart';

class AppButton {
  static Widget basicButton({
    required Color color,
    double radius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      vertical: 24,
      horizontal: 16,
    ),
    BoxBorder? border,
    Function()? onTap,
    double? width,
    double? height,
    Widget? child,
    bool enable = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(radius),
          color: enable ? color : AppColor.neutralDarkLight,
        ),
        child: child,
      ),
    );
  }
}
