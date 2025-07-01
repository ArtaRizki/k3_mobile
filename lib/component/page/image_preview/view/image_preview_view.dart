import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/page/image_preview/controller/image_preview_controller.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewView extends GetView<ImagePreviewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: PhotoView(imageProvider: controller.img),
            ),
            if (!controller.loading.value)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColor.neutralDarkDarkest.withOpacity(0.7),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (controller.currentDateTime.value != '')
                        Text(
                          '${controller.currentDateTime.value}',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                      if (controller.currentPosition.value != '')
                        SizedBox(height: 4),
                      if (controller.currentPosition.value != '')
                        Text(
                          '${controller.currentPosition.value?.latitude}, ${controller.currentPosition.value?.longitude}',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                      Text(
                        '${controller.addressData.value.displayName ?? 'N/A'}',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
