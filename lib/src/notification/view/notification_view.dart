import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/src/notification/controller/notification_controller.dart';
import 'package:k3_mobile/src/notification/view/widget/not_read_tab.dart';
import 'package:k3_mobile/src/notification/view/widget/read_tab.dart';

class NotificationView extends GetView<NotificationController> {
  NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutralLightLightest,
      appBar: AppAppbar.basicAppbar(
        title: 'Notifikasi',
        bottom: _buildTabBar(),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TabBarView(
            controller: controller.tabC,
            children: const [NotReadTab(), ReadTab()],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: controller.tabC,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColor.highlightDarkest,
      unselectedLabelColor: AppColor.neutralLightDarkest,
      dividerColor: Colors.transparent,
      indicatorColor: AppColor.highlightDarkest,
      labelStyle: AppTextStyle.bodyM.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: AppTextStyle.bodyM,
      tabs: const [Tab(text: 'Belum dibaca'), Tab(text: 'Sudah dibaca')],
    );
  }
}
