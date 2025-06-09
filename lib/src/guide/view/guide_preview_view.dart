import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/download.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/src/guide/controller/guide_preview_controller.dart';

class GuidePreviewView extends GetView<GuidePreviewController> {
  GuidePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(
        title: 'Permenaker Nomor 11 Tahun 2023',
        centerTitle: true,
        onBack: () async {
          Get.back();
        },
        action: actionWidget(controller),
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

  List<Widget> actionWidget(GuidePreviewController controller) {
    return [
      InkWell(
        onTap: () async {
          downloadFile(
            Get.context!,
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
    ];
  }
}
