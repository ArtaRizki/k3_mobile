import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/profile/controller/profile_controller.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

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
          'Profil',
          style: AppTextStyle.h4.copyWith(
            color: AppColor.neutralDarkLight,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: AppColor.neutralLightLightest,
            padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Image.asset(
                      Assets.iconsIcAvatar,
                      width: 88,
                      height: 88,
                    ),
                  ),
                ),
                text('Nama', 'Riowaldy Indrawan'),
                SizedBox(height: 32),
                text('Unit', 'Unit Kalimantan'),
                SizedBox(height: 32),
                text('Jabatan', 'Supervisor'),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          await Get.find<SessionController>().logout();
          Get.offAllNamed(AppRoute.LOGIN);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 16),
          child: AppButton.basicButton(
            enable: true,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            color: AppColor.neutralLightLightest,
            radius: 30,
            border: Border.all(
              color: AppColor.errorDark,
              width: 1,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.iconsIcLogout, width: 24, height: 24),
                SizedBox(width: 3.5),
                Text(
                  'Keluar',
                  style: AppTextStyle.actionL.copyWith(
                    color: AppColor.errorDark,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget text(String title, String subtitle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkMedium,
            ),
          ),
          SizedBox(height: 12),
          Text(
            subtitle,
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkDarkest,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
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

  final controller = Get.put(ProfileController());
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
  final controller = Get.put(ProfileController());

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
