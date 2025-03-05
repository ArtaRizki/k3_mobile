import 'package:flutter/material.dart';

class AppCard {
  static Widget basicCard({
    required Color color,
    double radius = 24,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
    BoxBorder? border,
    Function()? onTap,
    double? width,
    double? height,
    Widget? child,
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
          color: color,
        ),
        child: child,
      ),
    );
  }

  static Widget listCard({
    required Color color,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 6,
    ),
    Function()? onTap,
    double? width,
    double? height,
    Widget? child,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(color: color),
        child: child,
      ),
    );
  }
}
