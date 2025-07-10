import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/src/inspection/inspection_pdf/inspection_pdf_controller.dart';

class InspectionPdfView extends GetView<InspectionPdfController> {
  InspectionPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          Scaffold(appBar: _buildAppBar(), body: SafeArea(child: _buildBody())),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppAppbar.basicAppbar(
      title:
          controller.title.value.isEmpty
              ? 'PDF Inspection'
              : controller.title.value,
      centerTitle: true,
      onBack: () => Get.back(),
      action: _buildDownloadAction(),
    );
  }

  List<Widget> _buildDownloadAction() {
    return [
      Obx(() {
        // if (controller.isDownloading.value) {
        //   return Padding(
        //     padding: const EdgeInsets.only(right: 24),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         SizedBox(
        //           width: 16,
        //           height: 16,
        //           child: CircularProgressIndicator(
        //             strokeWidth: 2,
        //             value:
        //                 controller.downloadProgress.value > 0
        //                     ? controller.downloadProgress.value
        //                     : null,
        //           ),
        //         ),
        //         const SizedBox(width: 8),
        //         Text(
        //           controller.downloadProgress.value > 0
        //               ? '${(controller.downloadProgress.value * 100).toInt()}%'
        //               : 'Unduh',
        //           style: AppTextStyle.actionM.copyWith(color: Colors.blue),
        //         ),
        //       ],
        //     ),
        //   );
        // } else {
        return InkWell(
          onTap:
              controller.localPdfPath.value.isNotEmpty
                  ? controller.handleDownload
                  : null,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Text(
              'Unduh',
              style: AppTextStyle.actionM.copyWith(
                color:
                    controller.localPdfPath.value.isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
              ),
            ),
          ),
        );
        // }
      }),
    ];
  }

  Widget _buildBody() {
    return Container(
      color: AppColor.neutralLightLightest,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        } else if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        } else if (controller.localPdfPath.value.isNotEmpty) {
          return _buildPdfView(controller.localPdfPath.value);
        } else {
          return _buildEmptyState();
        }
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Memuat PDF...',
            style: AppTextStyle.bodyM.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat PDF',
            style: AppTextStyle.h3.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              style: AppTextStyle.bodyS.copyWith(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.retryDownload,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf_outlined, size: 64, color: Colors.black54),
          const SizedBox(height: 16),
          Text(
            'Tidak ada PDF untuk ditampilkan',
            style: AppTextStyle.h3.copyWith(color: Colors.black87),
          ),
        ],
      ),
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
      child: PDFView(
        filePath: path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        onRender: (pages) {
          print('PDF rendered with $pages pages');
        },
        onError: (error) {
          print('PDF Error: $error');
          controller.errorMessage.value = 'Error rendering PDF: $error';
        },
        onPageError: (page, error) {
          print('Page $page Error: $error');
        },
      ),
    );
  }
}
