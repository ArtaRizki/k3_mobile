import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/notification/controller/notification_controller.dart';
import 'package:k3_mobile/src/notification/view/widget/notification_list_view.dart';

class ReadTab extends StatefulWidget {
  const ReadTab({super.key});
  @override
  State<ReadTab> createState() => _ReadTabState();
}

class _ReadTabState
    extends State<ReadTab> /*with AutomaticKeepAliveClientMixin*/ {
  final controller = Get.find<NotificationController>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return NotificationListView(
      scrollController: scrollController,
      iconPath: Assets.iconsIcListDashboardGray,
      isRead: true,
      textColor: AppColor.neutralDarkLightest,
      subtitleColor: AppColor.neutralDarkLightest,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
