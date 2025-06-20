import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/notification/controller/notification_controller.dart';
import 'package:k3_mobile/src/notification/view/widget/notification_list_view.dart';

class NotReadTab extends StatefulWidget {
  const NotReadTab({super.key});
  @override
  State<NotReadTab> createState() => _NotReadTabState();
}

class _NotReadTabState extends State<NotReadTab>
/*with AutomaticKeepAliveClientMixin */ {
  final controller = Get.find<NotificationController>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return NotificationListView(
      scrollController: scrollController,
      iconPath: Assets.iconsIcListDashboard,
      status: '0',
      textColor: AppColor.highlightDarkest,
      subtitleColor: AppColor.neutralDarkDarkest,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
