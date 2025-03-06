import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/home/controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
    );
  }

  Widget header() {
    return Row(
      children: [
        Image.asset(
          Assets.iconsIcAvatar,
          width: 45,
          height: 45,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Riowaldy indrawan',
                  style: AppTextStyle.h3.copyWith(
                    color: AppColor.highlightDarkest,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Unit Kalimantan',
                  style: AppTextStyle.bodyS.copyWith(
                    color: AppColor.neutralDarkLightest,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () async {},
          child: Image.asset(
            Assets.iconsIcNotification,
            width: 24,
            height: 24,
          ),
        ),
        SizedBox(width: 24),
        InkWell(
          onTap: () async {},
          child: Image.asset(
            Assets.iconsIcLogout,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget inspectionCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 130,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesImgOftenInspection,
                ),
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
                      '321',
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
            height: 130,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesImgProjectInspection,
                ),
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
                      '112',
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
                      '10',
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
                      '8',
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
                      '2',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h1.copyWith(
                        color: AppColor.neutralDarkLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget timeline() {
    return ListView.separated(
      itemCount: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (c, i) {
        return AppCard.listCard(
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
                        'Pengeluaran barang telah disetujui oleh SigidSigidSigidSigidSigid',
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
