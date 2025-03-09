import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_controller.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';

class ApdRequestViewView extends GetView<ApdRequestController> {
  ApdRequestViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.neutralLightLightest,
        leadingWidth: 72,
        titleSpacing: 0,
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
        title: Text(
          'ARQ/2025/II/001',
          style: AppTextStyle.h4.copyWith(
            color: AppColor.neutralDarkDarkest,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                'Ajukan',
                style: AppTextStyle.bodyM.copyWith(
                  color: AppColor.warningDark,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                'Edit',
                style: AppTextStyle.bodyM.copyWith(
                  color: AppColor.highlightDarkest,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(left: 6, right: 24),
              child: Text(
                'Hapus',
                style: AppTextStyle.bodyM.copyWith(
                  color: AppColor.errorDark,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    ...header(),
                    SizedBox(height: 24),
                    Text(
                      'Daftar permintaan',
                      style: AppTextStyle.bodyM.copyWith(
                        color: AppColor.neutralDarkLight,
                      ),
                    ),
                    SizedBox(height: 6),
                    list(),
                    timeline(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> header() {
    return [
      headerItem('Tanggal', '12/02/2025'),
      SizedBox(height: 9),
      headerItem('Unit', 'Kalimantan'),
      SizedBox(height: 9),
      headerItem('Keterangan', 'Deskripsi dokumen'),
      SizedBox(height: 9),
      headerItem(
        'Status',
        'Draft',
        valueColor: controller.statusColor('Draft'),
      ),
      // headerItem('Status', 'Diajukan'),
      // headerItem('Status', 'Disetujui'),
      // headerItem('Status', 'Ditolak'),
      SizedBox(height: 9),
    ];
  }

  Widget headerItem(String title, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: AppTextStyle.bodyM.copyWith(
              color: AppColor.neutralDarkLight,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: AppTextStyle.actionL.copyWith(
              color: valueColor ?? AppColor.neutralDarkDarkest,
            ),
          ),
        ),
      ],
    );
  }

  Widget list() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (c, i) {
        return AppCard.listCard(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          color: i % 2 == 0
              ? AppColor.highlightLightest
              : AppColor.neutralLightLightest,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleSubtitle(
                'Kode',
                'APD00${i + 1}',
                3,
              ),
              SizedBox(width: 12),
              titleSubtitle(
                'Nama',
                'Helm Proyek',
                5,
              ),
              SizedBox(width: 12),
              titleSubtitle(
                'Jumlah',
                '${(i + 1) * 10}',
                2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget titleSubtitle(String title, String subtitle, int flex) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkLightest,
            ),
          ),
          SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyle.bodyM.copyWith(
              color: AppColor.neutralDarkDarkest,
            ),
          ),
        ],
      ),
    );
  }

  Widget timeline() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24),
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Linimasa',
            style: AppTextStyle.bodyM.copyWith(
              color: AppColor.neutralDarkLight,
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: List.generate(
                2,
                (i) {
                  return timelineItem(
                      '14/02/2025\n14:00', 'Permintaan APD diajukan', 'Siti');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timelineItem(String t1, String t2, String t3) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              t1,
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkLightest,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              t2,
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkLightest,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'oleh: $t3',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkLightest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
