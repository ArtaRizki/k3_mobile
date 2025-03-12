import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_text_style.dart';

class EmptyList {
  static Widget textEmptyList({
    required double minHeight,
    required Future<void> Function() onRefresh,
  }) {
    return Expanded(
      child: RefreshIndicator(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Column(
              children: [
                SizedBox(height: Get.size.height * .12),
                Center(
                  child: Text(
                    'Tidak ada data',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.actionM,
                  ),
                ),
              ],
            ),
          ),
        ),
        onRefresh: onRefresh,
      ),
    );
  }
}
