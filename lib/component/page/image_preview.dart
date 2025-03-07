import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImagePreviewState();
  }
}

class ImagePreviewState extends State<ImagePreview> {
  late Uri path;
  ImageProvider? img;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Get.arguments == null || (Get.arguments as String).isEmpty) {
      // Utils.showToast("Error : Image path not found!");
      Get.back();
      return;
    }

    path = Uri.parse(Get.arguments);
    if (!isFile()) path = path.replace(scheme: 'https');
    img = image() as ImageProvider;

    if ((isFile() && File(path.toString()).existsSync()) || img == null) {
      // Utils.showToast("Error : Image not exist!");
      Get.back();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pratinjau Gambar")),
      // extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: PhotoView(imageProvider: img!),
      ),
    );
  }

  Object? image() {
    return (isFile())
        ? FileImage(File(path.toString()))
        : NetworkImage(path.toString());
  }

  bool isFile() {
    return path.isScheme('file');
  }
}
