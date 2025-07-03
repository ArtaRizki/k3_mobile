import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:k3_mobile/component/firebase_and_notif.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const MethodChannel _channel = MethodChannel('download_channel');

Future<void> downloadFile(
  BuildContext context,
  String link, {
  required String filename,
  required String typeFile,
  bool openAfterDownload = false,
  void Function(double progress)? onProgress, // optional callback
  bool allowCustomSaveLocation = false,
}) async {
  try {
    if (Platform.isAndroid) {
      final hasPermission = await _checkAndRequestPermissions();
      if (!hasPermission) {
        Utils.showFailed(msg: 'Permission denied');
        return;
      }
    }

    final uri = Uri.parse(link);
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    if (response.statusCode != 200) {
      log('Failed to download. Status code: ${response.statusCode}');
      Utils.showFailed(msg: 'Download gagal');
      return;
    }

    final contentLength = response.contentLength;
    List<int> bytes = [];
    int received = 0;

    final completer = Completer<Uint8List>();

    response.listen(
      (chunk) {
        bytes.addAll(chunk);
        received += chunk.length;
        if (onProgress != null && contentLength > 0) {
          onProgress(received / contentLength);
        }
      },
      onDone: () => completer.complete(Uint8List.fromList(bytes)),
      onError: (e) {
        Utils.showFailed(msg: 'Download error: $e');
        completer.completeError(e);
      },
      cancelOnError: true,
    );

    final data = await completer.future;
    final fullName = '$filename.$typeFile';
    final mimeType = _getMimeType(typeFile);
    bool saved = false;

    if (allowCustomSaveLocation) {
      saved = await _saveWithPicker(data, fullName, typeFile);
    } else if (Platform.isAndroid) {
      saved = await _saveFileToDownloadsAndroid(data, fullName, mimeType);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fullName');
      await file.writeAsBytes(data);
      saved = await file.exists();
    }

    if (saved) {
      Utils.showSuccess(msg: 'Download Berhasil');
      final notifications = FlutterLocalNotificationsPlugin();
      await _showDownloadNotification(
        notifications,
        null,
        fullName,
        openAfterDownload,
        filePathHint: 'Download/K3Mobile/$fullName',
      );
    } else {
      Utils.displaySnackBar('Gagal menyimpan file');
    }
  } catch (e) {
    log('Download failed: $e');
    Utils.showFailed(msg: 'Download gagal: $e');
  }
}

Future<bool> _saveFileToDownloadsAndroid(
  Uint8List bytes,
  String filename,
  String mimeType,
) async {
  try {
    final result = await _channel.invokeMethod('saveFileToDownloads', {
      'bytes': bytes,
      'filename': filename,
      'mimeType': mimeType,
    });
    return result == true;
  } catch (e) {
    debugPrint('Failed saving via MediaStore: $e');
    return false;
  }
}

Future<bool> _saveWithPicker(
  Uint8List data,
  String filename,
  String ext,
) async {
  try {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Simpan file sebagai...',
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: [ext],
      bytes: data,
    );

    // if (path == null) return false;
    // final file = File(path);
    // await file.writeAsBytes(data);
    // return file.existsSync();
    return path != null;
  } catch (e) {
    debugPrint('Save with picker failed: $e');
    return false;
  }
}

String _getMimeType(String ext) {
  switch (ext.toLowerCase()) {
    case 'pdf':
      return 'application/pdf';
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'mp4':
      return 'video/mp4';
    case 'mp3':
      return 'audio/mpeg';
    case 'txt':
      return 'text/plain';
    default:
      return 'application/octet-stream';
  }
}

Future<bool> _checkAndRequestPermissions() async {
  if (!Platform.isAndroid) return true;
  final androidInfo = await DeviceInfoPlugin().androidInfo;

  if (androidInfo.version.sdkInt >= 33) {
    final permissions = <Permission>[
      Permission.photos,
      Permission.videos,
      Permission.audio,
      Permission.manageExternalStorage,
    ];
    final statuses = await permissions.request();
    return statuses.values.any((status) => status.isGranted);
  } else {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}

Future<void> _showDownloadNotification(
  FlutterLocalNotificationsPlugin plugin,
  File? file,
  String filename,
  bool openAfterDownload, {
  String? filePathHint,
}) async {
  await plugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      if (!openAfterDownload && file != null) {
        OpenFile.open(file.path);
      }
    },
  );

  final message =
      openAfterDownload
          ? "Download berhasil disimpan${filePathHint != null ? ' di $filePathHint' : ''}"
          : "Download berhasil, ketuk untuk buka file";

  await plugin.show(0, filename, message, notificationDetails);

  if (openAfterDownload && file != null) {
    await OpenFile.open(file.path);
  }
}
