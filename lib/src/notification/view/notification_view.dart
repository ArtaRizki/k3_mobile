import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/notification/controller/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutralLightLightest,
      appBar: AppBar(
        backgroundColor: AppColor.neutralLightLightest,
        leadingWidth: 72,
        leading: InkWell(
        onTap: () async {
            Get.back();
          },
          child: SizedBox(
            width: 24,
            height: 24,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Transform.scale(
                scale: 0.5,
                child: Image.asset(
                  Assets.iconsIcArrowBack,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Notifikasi',
          style: AppTextStyle.h4.copyWith(
            color: AppColor.neutralDarkLight,
          ),
        ),
        bottom: TabBar(
          padding: EdgeInsets.symmetric(horizontal: 24),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: AppTextStyle.bodyM.copyWith(
            color: AppColor.highlightDarkest,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: AppTextStyle.bodyM.copyWith(
            color: AppColor.neutralLightDarkest,
            fontWeight: FontWeight.normal,
          ),
          controller: controller.tabC,
          labelColor: AppColor.highlightDarkest,
          dividerColor: Colors.transparent,
          indicatorColor: AppColor.highlightDarkest,
          unselectedLabelColor: AppColor.neutralLightDarkest,
          tabs: [
            Tab(
              text: 'Belum dibaca',
            ),
            Tab(
              text: 'Sudah dibaca',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: TabBarView(
            controller: controller.tabC,
            children: [
              NotReadTab(),
              ReadTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class NotReadTab extends StatefulWidget {
  @override
  _NotReadTabState createState() => _NotReadTabState();
}

class _NotReadTabState extends State<NotReadTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  final controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure the keep-alive works
    return ListView.separated(
      controller: _scrollController,
      itemCount: 10,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (c, i) {
        return Padding(
          padding:
              EdgeInsets.only(top: i == 0 ? 12 : 0, bottom: i == 9 ? 24 : 0),
          child: AppCard.listCard(
            color: AppColor.neutralLightLightest,
            child: Row(
              children: [
                Image.asset(
                  Assets.iconsIcListDashboard,
                  width: 52,
                  height: 52,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '12/02/2025',
                              style: AppTextStyle.bodyS.copyWith(
                                color: AppColor.neutralDarkMedium,
                              ),
                            ),
                          ),
                          Text(
                            '15.51',
                            style: AppTextStyle.bodyS.copyWith(
                              color: AppColor.neutralDarkMedium,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 3),
                      Flexible(
                        child: Text(
                          'Permintaan APD : ARQ/2025/II/001',
                          style: AppTextStyle.h4.copyWith(
                            color: AppColor.highlightDarkest,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Pengeluaran barang telah disetujui oleh Sigid',
                          style: AppTextStyle.bodyS.copyWith(
                            color: AppColor.neutralDarkDarkest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true; // Keep the state alive
}

class ReadTab extends StatefulWidget {
  @override
  _ReadTabState createState() => _ReadTabState();
}

class _ReadTabState extends State<ReadTab> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure the keep-alive works
    return ListView.separated(
      controller: _scrollController,
      itemCount: 10,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (c, i) {
        return AppCard.listCard(
          color: AppColor.neutralLightLightest,
          child: Row(
            children: [
              Image.asset(
                Assets.iconsIcListDashboardGray,
                width: 52,
                height: 52,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '12/02/2025',
                            style: AppTextStyle.bodyS.copyWith(
                              color: AppColor.neutralDarkLightest,
                            ),
                          ),
                        ),
                        Text(
                          '15.51',
                          style: AppTextStyle.bodyS.copyWith(
                            color: AppColor.neutralDarkLightest,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 3),
                    Flexible(
                      child: Text(
                        'Permintaan APD : ARQ/2025/II/001',
                        style: AppTextStyle.h4.copyWith(
                          color: AppColor.neutralDarkLightest,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Pengeluaran barang telah disetujui oleh Sigid',
                        style: AppTextStyle.bodyS.copyWith(
                          color: AppColor.neutralDarkLightest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true; // Keep the state alive
}
