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
    return Obx(
      () =>
          Scaffold(appBar: _buildAppBar(), body: SafeArea(child: _buildBody())),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppAppbar.basicAppbar(
      title: controller.title.value,
      centerTitle: true,
      onBack: () => Get.back(),
      action: _buildDownloadAction(),
    );
  }

  List<Widget> _buildDownloadAction() {
    return [
      InkWell(
        onTap: controller.handleDownload,
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

  Widget _buildBody() {
    final path = controller.localPdfPath.value;
    return Container(
      color: AppColor.neutralLightLightest,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child:
          path.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _buildPdfView(path),
    );
  }

  Widget _buildPdfView(String path) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: PDFView(filePath: path),
    );
  }
}
