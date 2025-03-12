import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';

class AppDialog {
  static showBasicDialog({
    required String title,
    required Widget content,
    Widget? btn,
  }) {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
            backgroundColor: AppColor.neutralLightLightest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Center(
                      child: Text(
                        title,
                        style: AppTextStyle.h4.copyWith(
                          color: AppColor.neutralDarkLight,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: Icon(
                      Icons.close,
                      color: AppColor.neutralDarkLight,
                    ),
                  ),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: content,
            ),
            actions: btn != null ? [btn] : null,
          );
        });
      },
    );
  }
}
