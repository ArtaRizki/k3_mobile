import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/home/controller/home_controller.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.getData();
          },
          child: SingleChildScrollView(
            child: Obx(
              () => Container(
                color: AppColor.neutralLightLightest,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 16),
                    header(),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 12),
                      child: Text(
                        'Inspeksi',
                        textAlign: TextAlign.left,
                        style: AppTextStyle.actionL.copyWith(
                          color: AppColor.neutralDarkLight,
                        ),
                      ),
                    ),
                    inspectionCard(),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 12),
                      child: Text(
                        'Manajemen APD',
                        textAlign: TextAlign.left,
                        style: AppTextStyle.actionL.copyWith(
                          color: AppColor.neutralDarkLight,
                        ),
                      ),
                    ),
                    apdManagementCard(),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 12),
                      child: Text(
                        'Linimasa',
                        textAlign: TextAlign.left,
                        style: AppTextStyle.actionL.copyWith(
                          color: AppColor.neutralDarkLight,
                        ),
                      ),
                    ),
                    timeline(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    final user = controller.loginModel.value?.data;
    return InkWell(
      onTap: () async {
        Get.find<MainHomeController>().selectedIndex.value = 4;
      },
      child: Row(
        children: [
          Image.asset(Assets.iconsIcAvatar, width: 45, height: 45),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    user?.name ?? '',
                    style: AppTextStyle.h3.copyWith(
                      color: AppColor.highlightDarkest,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    user?.unitName ?? '',
                    style: AppTextStyle.bodyS.copyWith(
                      color: AppColor.neutralDarkLightest,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Get.toNamed(AppRoute.NOTIFICATION);
            },
            child: Image.asset(
              Assets.iconsIcNotification,
              width: 24,
              height: 24,
            ),
          ),
          SizedBox(width: 24),
          InkWell(
            onTap: () async {
              await Get.find<SessionController>().logout();
              Get.offAllNamed(AppRoute.LOGIN);
            },
            child: Image.asset(Assets.iconsIcLogout, width: 24, height: 24),
          ),
        ],
      ),
    );
  }

  Widget inspectionCard() {
    final inspeksi = controller.homeModel.value.data?.inspeksi;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 130,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesImgOftenInspection),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Assets.iconsIcOftenInspection,
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      inspeksi?.rutin ?? '',
                      style: AppTextStyle.h1.copyWith(
                        color: AppColor.successMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Inspeksi Rutin',
                  style: AppTextStyle.bodyM.copyWith(
                    color: AppColor.successMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(24),
            constraints: BoxConstraints(minHeight: 132),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesImgProjectInspection),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Assets.iconsIcProjectInspection,
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      inspeksi?.proyek ?? '',
                      style: AppTextStyle.h1.copyWith(
                        color: AppColor.errorMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Inspeksi Proyek',
                  style: AppTextStyle.bodyM.copyWith(
                    color: AppColor.errorMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget apdManagementCard() {
    final apd = controller.homeModel.value.data?.manajemenApd;
    return SizedBox(
      height: 126,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AppCard.basicCard(
              color: AppColor.highlightLightest,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Permintaan',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyM.copyWith(
                        color: AppColor.highlightDarkest,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      apd?.permintaan ?? '',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h1.copyWith(
                        color: AppColor.highlightDarkest,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: AppCard.basicCard(
              color: AppColor.warningLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Penerimaan',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyM.copyWith(
                        color: AppColor.warningDark,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      apd?.penerimaan ?? '',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h1.copyWith(
                        color: AppColor.warningDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: AppCard.basicCard(
              color: AppColor.neutralLightMedium,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Pengembalian',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyM.copyWith(
                        color: AppColor.neutralDarkLight,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      apd?.pengembalian ?? '',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h1.copyWith(
                        color: AppColor.neutralDarkLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeline() {
    final linimasa = controller.homeModel.value.data?.linimasa ?? [];
    if (linimasa.isEmpty) return Center(child: Text('Tidak ada data'));
    return ListView.separated(
      itemCount: linimasa.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (c, i) {
        final item = controller.homeModel.value.data?.linimasa?[i];
        return AppCard.listCard(
          color: AppColor.neutralLightLightest,
          child: Row(
            children: [
              Image.asset(Assets.iconsIcListDashboard, width: 52, height: 52),
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
                            item?.createdDate ?? '',
                            style: AppTextStyle.bodyS.copyWith(
                              color: AppColor.neutralDarkMedium,
                            ),
                          ),
                        ),
                        Text(
                          item?.createdTime ?? '',
                          style: AppTextStyle.bodyS.copyWith(
                            color: AppColor.neutralDarkMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Flexible(
                      child: Text(
                        item?.code ?? '',
                        style: AppTextStyle.h4.copyWith(
                          color: AppColor.highlightDarkest,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        item?.description ?? '',
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
        );
      },
    );
  }
}
