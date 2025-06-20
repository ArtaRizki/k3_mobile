import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:k3_mobile/component/firebase_and_notif.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadFile(
  BuildContext context,
  String link, {
  required String filename,
  bool openAfterDownload = false,
  required String typeFile,
}) async {
  try {
    // Request permission
    await _requestStoragePermissions();

    final uri = Uri.parse(link);
    final response = await HttpClient().getUrl(uri).then((req) => req.close());

    if (response.statusCode != 200) {
      log('Failed to download. Status code: ${response.statusCode}');
      return;
    }

    Utils.showSuccess(msg: 'Download Berhasil');

    final bytes = await consolidateHttpClientResponseBytes(response);
    final directory = await _getDownloadDirectory();
    final folder = Directory('${directory.path}/K3Mobile');

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final filePath = '${folder.path}/$filename.$typeFile';
    final file = await File(filePath).writeAsBytes(bytes);

    final notifications = FlutterLocalNotificationsPlugin();
    await _showDownloadNotification(
      notifications,
      file,
      filename,
      openAfterDownload,
    );
  } catch (e) {
    log('Download failed: $e');
  }
}

Future<void> _requestStoragePermissions() async {
  await [
    Permission.storage,
    if (Platform.isAndroid) Permission.manageExternalStorage,
    Permission.photos,
  ].request();
}

Future<Directory> _getDownloadDirectory() async {
  if (Platform.isAndroid) {
    return await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
  }
  return await getApplicationDocumentsDirectory();
}

Future<void> _showDownloadNotification(
  FlutterLocalNotificationsPlugin plugin,
  File file,
  String filename,
  bool openAfterDownload,
) async {
  await plugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      if (!openAfterDownload && response != null) {
        OpenFile.open(file.path);
      }
    },
  );

  final message =
      openAfterDownload
          ? "Download berhasil disimpan di ${file.path}"
          : "Download berhasil, Ketuk untuk buka file";

  await plugin.show(0, filename, message, notificationDetails);

  if (openAfterDownload) {
    await OpenFile.open(file.path);
  }
}
