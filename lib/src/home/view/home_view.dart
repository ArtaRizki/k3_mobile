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
          onRefresh: () async => controller.getData(),
          child: Obx(
            () => SingleChildScrollView(
              child: Container(
                color: AppColor.neutralLightLightest,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _sectionTitle('Inspeksi'),
                    _buildInspectionCard(),
                    _sectionTitle('Manajemen APD'),
                    _buildApdManagementCard(),
                    _sectionTitle('Linimasa'),
                    _buildTimeline(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = controller.loginModel.value?.data;
    return InkWell(
      onTap: () => Get.find<MainHomeController>().selectedIndex.value = 4,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            Image.asset(Assets.iconsIcAvatar, width: 45, height: 45),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? '',
                    style: AppTextStyle.h3.copyWith(
                      color: AppColor.highlightDarkest,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.unitName ?? '',
                    style: AppTextStyle.bodyS.copyWith(
                      color: AppColor.neutralDarkLightest,
                    ),
                  ),
                ],
              ),
            ),
            _iconButton(
              Assets.iconsIcNotification,
              () => Get.toNamed(AppRoute.NOTIFICATION),
            ),
            const SizedBox(width: 24),
            _iconButton(Assets.iconsIcLogout, () async {
              await Get.find<SessionController>().logout();
              Get.offAllNamed(AppRoute.LOGIN);
            }),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(String assetPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(assetPath, width: 24, height: 24),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        text,
        style: AppTextStyle.actionL.copyWith(color: AppColor.neutralDarkLight),
      ),
    );
  }

  Widget _buildInspectionCard() {
    final inspeksi = controller.homeModel.value.data?.inspeksi;
    return Row(
      children: [
        _inspectionItem(
          image: Assets.imagesImgOftenInspection,
          icon: Assets.iconsIcOftenInspection,
          value: inspeksi?.rutin ?? '',
          label: 'Inspeksi Rutin',
          color: AppColor.successMedium,
        ),
        const SizedBox(width: 12),
        _inspectionItem(
          image: Assets.imagesImgProjectInspection,
          icon: Assets.iconsIcProjectInspection,
          value: inspeksi?.proyek ?? '',
          label: 'Inspeksi Proyek',
          color: AppColor.errorMedium,
        ),
      ],
    );
  }

  Widget _inspectionItem({
    required String image,
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(icon, width: 24, height: 24),
                const SizedBox(width: 10),
                Text(value, style: AppTextStyle.h1.copyWith(color: color)),
              ],
            ),
            const SizedBox(height: 10),
            Text(label, style: AppTextStyle.bodyM.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildApdManagementCard() {
    final apd = controller.homeModel.value.data?.manajemenApd;
    return SizedBox(
      height: 126,
      child: Row(
        children: [
          _apdCard(
            'Permintaan',
            apd?.permintaan ?? '',
            AppColor.highlightLightest,
            AppColor.highlightDarkest,
          ),
          const SizedBox(width: 10),
          _apdCard(
            'Penerimaan',
            apd?.penerimaan ?? '',
            AppColor.warningLight,
            AppColor.warningDark,
          ),
          const SizedBox(width: 10),
          _apdCard(
            'Pengembalian',
            apd?.pengembalian ?? '',
            AppColor.neutralLightMedium,
            AppColor.neutralDarkLight,
          ),
        ],
      ),
    );
  }

  Widget _apdCard(String title, String value, Color bgColor, Color textColor) {
    return Expanded(
      child: AppCard.basicCard(
        color: bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyM.copyWith(color: textColor),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: AppTextStyle.h1.copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final linimasa = controller.homeModel.value.data?.linimasa ?? [];
    if (linimasa.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    return ListView.separated(
      itemCount: linimasa.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final item = linimasa[i];
        return AppCard.listCard(
          color: AppColor.neutralLightLightest,
          child: Row(
            children: [
              Image.asset(Assets.iconsIcListDashboard, width: 52, height: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 3),
                    Text(
                      item?.code ?? '',
                      style: AppTextStyle.h4.copyWith(
                        color: AppColor.highlightDarkest,
                      ),
                    ),
                    Text(
                      item?.description ?? '',
                      style: AppTextStyle.bodyS.copyWith(
                        color: AppColor.neutralDarkDarkest,
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
