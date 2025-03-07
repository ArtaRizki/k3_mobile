import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/download.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/guide/controller/guide_preview_controller.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';

class GuidePreviewView extends GetView<GuidePreviewController> {
  GuidePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.neutralLightLightest,
        leadingWidth: 72,
        leading: InkWell(
          onTap: () async {
            Get.find<MainHomeController>().selectedIndex.value = 3;
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
          'Permenaker Nomor 11 Tahun 2023',
          style: AppTextStyle.h4.copyWith(
            color: AppColor.neutralDarkLight,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              downloadFile(
                context,
                controller.pdfUrl.value,
                filename: controller.pdfUrl.value.split('/').last,
                typeFile: 'pdf',
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                'Unduh',
                style: AppTextStyle.bodyS.copyWith(
                  color: AppColor.highlightDarkest,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => Container(
            color: AppColor.neutralLightLightest,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: controller.localPdfPath.value == ''
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ]),
                      child: PDFView(
                        filePath: controller.localPdfPath.value,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
