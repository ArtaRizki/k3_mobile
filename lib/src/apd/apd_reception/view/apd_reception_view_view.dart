import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_controller.dart';
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_view_controller.dart';

class ApdReceptionViewView extends GetView<ApdReceptionViewController> {
  ApdReceptionViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(
        title: controller.viewData.value.id,
        centerTitle: false,
        titleSpacing: 0,
        titleStyle: AppTextStyle.h4.copyWith(
          color: AppColor.neutralDarkDarkest,
        ),
        action: _buildActionButtons(),
      ),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Obx(
            () {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ...header(),
                    SizedBox(height: 24),
                    ...headerApdRequest(),
                    SizedBox(height: 24),
                    ...headerOutcome(),
                    SizedBox(height: 24),
                    Text(
                      'Daftar APD',
                      style: AppTextStyle.actionL
                          .copyWith(color: AppColor.neutralDarkDarkest),
                    ),
                    SizedBox(height: 12),
                    list(),
                    SizedBox(height: 12),
                    Text(
                      'Gambar',
                      style: AppTextStyle.actionL
                          .copyWith(color: AppColor.neutralDarkDarkest),
                    ),
                    SizedBox(height: 6),
                    if (controller.viewData.value.images.isEmpty) ...[
                      Center(child: Text('Tidak ada gambar')),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Wrap(
                          spacing: 10,
                          children: List.generate(
                            controller.viewData.value.images.isEmpty
                                ? 1
                                : controller.viewData.value.images.length,
                            (i) {
                              final item = controller.viewData.value.images[i];
                              return InkWell(
                                onTap: () async {
                                  await Get.toNamed(
                                    AppRoute.IMAGE_PREVIEW,
                                    arguments: item,
                                  );
                                },
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(item),
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                    SizedBox(height: 12),
                    Text(
                      'Tanda tangan',
                      style: AppTextStyle.actionL
                          .copyWith(color: AppColor.neutralDarkDarkest),
                    ),
                    SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColor.neutralLightDarkest),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 158,
                      child: Stack(
                        children: [
                          Center(
                            child: Image.file(
                              File(controller.viewData.value.signature),
                              height: 138,
                            ),
                          ),
                          Positioned(
                            top: 125,
                            left: 0,
                            right: 0,
                            child: Text(
                              'Riowaldy Indrawan',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.bodyS
                                  .copyWith(color: AppColor.neutralDarkLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    final status = controller.viewData.value.status;
    return [
      if (status == 'Draft')
        _buildActionButton('Ajukan', AppColor.warningDark, () => Get.back()),
      if (status == 'Draft' || status == 'Ditolak')
        _buildActionButton('Edit', AppColor.highlightDarkest, () async {
          Get.toNamed(AppRoute.APD_REQUEST_CREATE, arguments: [
            controller.indexData.value,
            controller.viewData.value,
          ]);
        }),
      if (status == 'Draft')
        _buildActionButton('Hapus', AppColor.errorDark, () async {
          var c = Get.find<ApdReceptionController>();
          await c.deleteApdReceptionParam(controller.indexData.value);
          c.update();
          Get.back();
        }),
      SizedBox(width: 18),
    ];
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          label,
          style: AppTextStyle.bodyM.copyWith(color: color),
        ),
      ),
    );
  }

  List<Widget> header() {
    final data = controller.viewData.value;
    return [
      headerItem('Tanggal', data.date),
      SizedBox(height: 9),
      headerItem('Unit', data.unit),
      SizedBox(height: 9),
      headerItem('Keterangan', data.note),
      SizedBox(height: 9),
      headerItem(
        'Status',
        data.status,
        valueColor: controller.statusColor(data.status),
      ),
      SizedBox(height: 9),
    ];
  }

  List<Widget> headerApdRequest() {
    final data = controller.viewData.value;
    return [
      headerItem('Permintaan APD No', data.reqNumber),
      SizedBox(height: 9),
      headerItem('Tanggal', data.date),
    ];
  }

  List<Widget> headerOutcome() {
    final data = controller.viewData.value;
    return [
      headerItem('Pengeluaran barang No', data.expNumber),
      SizedBox(height: 9),
      headerItem('Tanggal', data.date),
      SizedBox(height: 9),
      headerItem('Vendor', data.vendor),
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
    final data = controller.viewData.value.recList;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (c, i) {
        final item = data[i];
        return AppCard.listCard(
          onTap: () async {
            Get.back();
          },
          padding: EdgeInsets.all(6),
          color: i % 2 == 0
              ? AppColor.highlightLightest
              : AppColor.neutralLightLightest,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleSubtitle('Kode', item.code, 3),
              SizedBox(width: 6),
              titleSubtitle('Nama', item.name, 4),
              SizedBox(width: 6),
              titleSubtitle('Jumlah', item.qty, 2),
              SizedBox(width: 6),
              titleSubtitle('Sisa', item.remainingQty, 2),
              SizedBox(width: 6),
              titleSubtitle('Diterima', item.receivedQty, 2),
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

  Widget titleSubtitleSelect(String title, String subtitle, int flex) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.bodyXS.copyWith(
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
}
