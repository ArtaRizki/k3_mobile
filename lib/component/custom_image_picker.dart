import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k3_mobile/component/compress_image.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_sheet.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';

class CustomImagePicker {
  static Future<XFile?> takeSelfie() async {
    XFile? f = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 480,
      maxHeight: 480,
      imageQuality: Platform.isAndroid ? 55 : 1,
      preferredCameraDevice: CameraDevice.front,
    );
    return f;
  }

  static Future<XFile?> takePhoto() async {
    XFile? f = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    return f;
  }

  static Future<XFile?> selectImageFromGallery() async {
    XFile? f = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 480,
      maxHeight: 480,
      imageQuality: Platform.isAndroid ? 55 : 1,
    );
    return f;
  }

  static Future<File?> cameraOrGallery(BuildContext context) async {
    File? f;
    await AppSheet.showModalBottomDraggable(
      initialChildSize: 0.3,
      context: context,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                final image = await takeSelfie();
                if (image == null) return;
                f = await compressImage(File(image.path));
                log("FILE COMPRESS : ${f?.path}");
                Navigator.pop(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                child: Row(
                  children: [
                    Image.asset(Assets.iconsIcCamera, width: 32, height: 32),
                    SizedBox(width: 16),
                    Text(
                      'Ambil gambar',
                      style: AppTextStyle.bodyM
                          .copyWith(color: AppColor.neutralDarkMedium),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final image = await selectImageFromGallery();
                if (image == null) return;
                f = File(image.path);
                Navigator.pop(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                child: Row(
                  children: [
                    Image.asset(Assets.iconsIcCamera, width: 32, height: 32),
                    SizedBox(width: 16),
                    Text(
                      'Pilih dari galeri',
                      style: AppTextStyle.bodyM
                          .copyWith(color: AppColor.neutralDarkMedium),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return f;
  }
}
