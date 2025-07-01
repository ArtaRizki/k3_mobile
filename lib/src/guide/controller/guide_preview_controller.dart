import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:k3_mobile/component/download.dart';
import 'package:k3_mobile/src/guide/model/guide_model.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

class GuidePreviewController extends GetxController {
  var localPdfPath = ''.obs;
  var pdfUrl = ''.obs;
  var title = ''.obs;

  @override
  void onInit() async {
    if (Get.arguments != null) {
      GuideModelData? data = Get.arguments;
      if (data != null) {
        pdfUrl.value = data.file ?? '';
        title.value = data.judul ?? '';
      }
    }
    _downloadPdf();
    super.onInit();
  }

  Future<void> handleDownload() async {
    final url = pdfUrl.value;
    final filename = url.split('/').last;
    downloadFile(
      Get.context!,
      url,
      filename: filename,
      typeFile: 'pdf',

      // allowCustomSaveLocation: true,
    );
  }

  Future<void> _downloadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      log("PDF URL : ${pdfUrl.value}");
      final file = File(
        '${dir.path}/${pdfUrl.value.replaceAll('/', '_').replaceAll(':', '_')}.pdf',
      );
      if (!await file.exists()) {
        final response = await http.get(Uri.parse(pdfUrl.value));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          throw Exception('Failed to load PDF');
        }
      }
      localPdfPath.value = file.path;
      log("LOCAL PDF PATH : ${localPdfPath.value}");
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
