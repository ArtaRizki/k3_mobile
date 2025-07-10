import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/src/notification/controller/notification_controller.dart';

class NotificationListView extends StatelessWidget {
  final ScrollController scrollController;
  final String iconPath;
  final bool isRead;
  final Color textColor;
  final Color subtitleColor;

  const NotificationListView({
    required this.scrollController,
    required this.iconPath,
    required this.isRead,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Obx(() {
      final notifications =
          (controller.notificationModel.value.data ?? [])
              .where((e) => e?.isRead == isRead)
              .toList();

      return RefreshIndicator(
        onRefresh: () async => controller.getData(),
        child: ListView.separated(
          controller: scrollController,
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          padding: const EdgeInsets.only(bottom: 24, top: 12),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return AppCard.listCard(
              onTap: () async {
                controller.navigateDetailNotification(item);
                if (item?.isRead == false || item?.isRead == null) {
                  await controller.readNotification(item?.id ?? '');
                  controller.getData();
                }
              },
              color: AppColor.neutralLightLightest,
              child: Row(
                children: [
                  Image.asset(iconPath, width: 52, height: 52),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                Utils.convertDateyyyySlashMMSlashdd(
                                  item?.tanggalAction ?? '',
                                ),
                                style: AppTextStyle.bodyS.copyWith(
                                  color: subtitleColor,
                                ),
                              ),
                            ),
                            Text(
                              Utils.convertDateHHmm(item?.tanggalAction ?? ''),
                              style: AppTextStyle.bodyS.copyWith(
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item?.title ?? '',
                          style: AppTextStyle.h4.copyWith(color: textColor),
                        ),
                        Text(
                          item?.message ?? '',
                          style: AppTextStyle.bodyS.copyWith(
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
