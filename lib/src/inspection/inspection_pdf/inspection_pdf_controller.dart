import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:k3_mobile/component/download.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/inspection/model/inspection_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class InspectionPdfController extends GetxController {
  final req = HttpRequestClient();
  var localPdfPath = ''.obs;
  var pdfUrl = ''.obs;
  var title = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var downloadProgress = 0.0.obs;
  var isDownloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (Get.arguments != null) {
        InspectionModelData? data = Get.arguments;
        if (data != null) {
          pdfUrl.value = data.linkPdf ?? '';
          title.value = data.code ?? '';
          log("Initialized with PDF URL: ${pdfUrl.value}");
        }
      }

      if (pdfUrl.value.isNotEmpty) {
        await _downloadPdf();
      } else {
        errorMessage.value = 'PDF URL tidak ditemukan';
      }
    } catch (e) {
      log('Error initializing controller: $e');
      errorMessage.value = 'Gagal memuat PDF: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getData() async {
    try {
      final response = await req.get('/get-data-inspeksi', body: {'tipe': '0'});
      if (response.statusCode == 200) {
        update();
      } else {
        final responseBody = jsonDecode(response.body);
        final msg = responseBody['message'] ?? 'Terjadi kesalahan';
        if (msg.isNotEmpty) {
          AppSnackbar.showSnackBar(Get.context!, msg, true);
        }
      }
    } catch (e) {
      log('Error getting data: $e');
      AppSnackbar.showSnackBar(
        Get.context!,
        'Error jaringan: ${e.toString()}',
        true,
      );
    }
  }

  Future<void> handleDownload() async {
    if (pdfUrl.value.isEmpty) {
      AppSnackbar.showSnackBar(Get.context!, 'URL PDF tidak tersedia', true);
      return;
    }

    if (isDownloading.value) {
      AppSnackbar.showSnackBar(
        Get.context!,
        'Download sedang berlangsung',
        true,
      );
      return;
    }

    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      final url = pdfUrl.value;
      // Extract filename from URL, remove extension as downloadFile adds it
      final fullFilename = url.split('/').last;
      final filename =
          fullFilename.contains('.')
              ? fullFilename.substring(0, fullFilename.lastIndexOf('.'))
              : fullFilename;

      await downloadFile(
        Get.context!,
        url,
        filename: filename,
        typeFile: 'pdf',
        openAfterDownload: true,
        allowCustomSaveLocation: true,
        onProgress: (progress) {
          downloadProgress.value = progress;
        },
      );
    } catch (e) {
      log('Download error: $e');
      AppSnackbar.showSnackBar(
        Get.context!,
        'Download gagal: ${e.toString()}',
        true,
      );
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  Future<void> _downloadPdf() async {
    if (pdfUrl.value.isEmpty) {
      errorMessage.value = 'URL PDF kosong';
      return;
    }

    try {
      log("Starting PDF download from: ${pdfUrl.value}");

      final dir = await getApplicationDocumentsDirectory();
      final sanitizedFilename = _sanitizeFilename(pdfUrl.value);
      final file = File('${dir.path}/$sanitizedFilename.pdf');

      log("Target file path: ${file.path}");

      if (!await file.exists()) {
        log("File doesn't exist, downloading...");

        final response = await http.get(
          Uri.parse(pdfUrl.value),
          headers: {'Accept': 'application/pdf', 'User-Agent': 'Mobile App'},
        );

        log("HTTP Response Status: ${response.statusCode}");
        log("HTTP Response Headers: ${response.headers}");

        if (response.statusCode == 200) {
          if (response.bodyBytes.isNotEmpty) {
            await file.writeAsBytes(response.bodyBytes);
            log(
              "PDF downloaded successfully, size: ${response.bodyBytes.length} bytes",
            );
          } else {
            throw Exception('Response body is empty');
          }
        } else {
          throw HttpException(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}',
          );
        }
      } else {
        log("PDF already exists locally");
      }

      // Verify file exists and has content
      if (await file.exists()) {
        final fileSize = await file.length();
        log("File exists with size: $fileSize bytes");

        if (fileSize > 0) {
          localPdfPath.value = file.path;
          log("LOCAL PDF PATH SET: ${localPdfPath.value}");
        } else {
          throw Exception('Downloaded file is empty');
        }
      } else {
        throw Exception('File was not created');
      }
    } catch (e) {
      log('Error downloading PDF: $e');
      errorMessage.value = 'Gagal mengunduh PDF: ${e.toString()}';

      // Show user-friendly error message
      if (Get.context != null) {
        AppSnackbar.showSnackBar(Get.context!, 'Gagal memuat PDF', true);
      }
    }
  }

  String _sanitizeFilename(String url) {
    return url
        .replaceAll('/', '_')
        .replaceAll(':', '_')
        .replaceAll('?', '_')
        .replaceAll('&', '_')
        .replaceAll('#', '_')
        .replaceAll(' ', '_');
  }

  // Add retry functionality
  Future<void> retryDownload() async {
    localPdfPath.value = '';
    errorMessage.value = '';
    await _initializeController();
  }
}
