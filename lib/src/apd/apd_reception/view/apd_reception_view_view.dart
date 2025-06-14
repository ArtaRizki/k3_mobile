import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_controller.dart';
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_view_controller.dart';

class ApdReceptionViewView extends GetView<ApdReceptionViewController> {
  ApdReceptionViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final buktiFoto =
          (controller.viewData.value.data?.gambarPenerimaan ?? []);
      return Scaffold(
        appBar: AppAppbar.basicAppbar(
          // harusnya penerimaanCode atau code saja
          title: controller.viewData.value.data?.permintaanCode ?? '',
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
            child: SingleChildScrollView(
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
                    style: AppTextStyle.actionL.copyWith(
                      color: AppColor.neutralDarkDarkest,
                    ),
                  ),
                  SizedBox(height: 12),
                  list(),
                  SizedBox(height: 12),
                  Text(
                    'Gambar',
                    style: AppTextStyle.actionL.copyWith(
                      color: AppColor.neutralDarkDarkest,
                    ),
                  ),
                  SizedBox(height: 6),
                  if (buktiFoto.isEmpty) ...[
                    Center(child: Text('Tidak ada gambar')),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Wrap(
                        spacing: 10,
                        children: List.generate(
                          buktiFoto.isEmpty ? 1 : buktiFoto.length,
                          (i) {
                            final item = buktiFoto[i];
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
                                decoration: BoxDecoration(color: Colors.white),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    // File(item),
                                    item?.filename ?? '',
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
                    ),
                  ],
                  SizedBox(height: 12),
                  Text(
                    'Tanda tangan',
                    style: AppTextStyle.actionL.copyWith(
                      color: AppColor.neutralDarkDarkest,
                    ),
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
                          child: Image.network(
                            controller.viewData.value.data?.fileTtd ?? '',
                            height: 138,
                          ),
                        ),
                        Positioned(
                          top: 125,
                          left: 0,
                          right: 0,
                          child: Text(
                            controller.viewData.value.data?.filenameTtd ?? '',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodyS.copyWith(
                              color: AppColor.neutralDarkLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildActionButtons() {
    final status = controller.viewData.value.data?.docStatus ?? '';
    return [
      if (status == '2')
        _buildActionButton('Ajukan', AppColor.warningDark, () async {
          // ajukan
          await controller.setApdStatus('0');
          Get.back();
        }),
      if (status == '2' || status == '3')
        _buildActionButton('Edit', AppColor.highlightDarkest, () async {
          Get.toNamed(
            AppRoute.APD_RECEPTION_CREATE,
            arguments: controller.viewData.value.data?.id ?? '',
          );
        }),
      if (status == '2')
        _buildActionButton('Hapus', AppColor.errorDark, () async {
          var c = Get.find<ApdReceptionController>();
          await c.deleteApdReceptionModel(controller.indexData.value);
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
        child: Text(label, style: AppTextStyle.bodyM.copyWith(color: color)),
      ),
    );
  }

  List<Widget> header() {
    final data = controller.viewData.value.data;
    return [
      headerItem('Tanggal', data?.docDate ?? ''),
      SizedBox(height: 9),
      headerItem('Unit', data?.unitName ?? ''),
      SizedBox(height: 9),
      headerItem('Keterangan', data?.keterangan ?? ''),
      SizedBox(height: 9),
      headerItem(
        'Status',
        Utils.getDocStatusName(data?.docStatus ?? ''),
        valueColor: Utils.getDocStatusColor(data?.docStatus ?? ''),
      ),
      SizedBox(height: 9),
    ];
  }

  List<Widget> headerApdRequest() {
    final data = controller.viewData.value.data;
    return [
      headerItem('Permintaan APD No', data?.permintaanCode ?? ''),
      SizedBox(height: 9),
      headerItem('Tanggal', data?.permintaanDate ?? ''),
    ];
  }

  List<Widget> headerOutcome() {
    final data = controller.viewData.value.data;
    return [
      headerItem('Pengeluaran barang No', data?.pengeluaranCode ?? ''),
      SizedBox(height: 9),
      headerItem('Tanggal', data?.docDate ?? ''),
      SizedBox(height: 9),
      headerItem('Vendor', data?.vendorName ?? ''),
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
    final data = controller.viewData.value.data?.daftarPenerimaan ?? [];
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
          color:
              i % 2 == 0
                  ? AppColor.highlightLightest
                  : AppColor.neutralLightLightest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // harusnya kode
                  titleSubtitle('Kode', item?.code ?? '', 3),
                  SizedBox(width: 6),
                  titleSubtitle('Nama', item?.apdName ?? '', 4),
                  SizedBox(width: 6),
                  titleSubtitle('Jumlah', '${item?.qtyJumlah ?? 0}', 2),
                  SizedBox(width: 6),
                  titleSubtitle('Sisa', '${item?.qtySisa ?? 0}', 2),
                  SizedBox(width: 6),
                  titleSubtitle('Diterima', '${item?.qtyDiterima ?? 0}', 2),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleSubtitle('Warna', item?.warna ?? '-', 5),
                  SizedBox(width: 12),
                  titleSubtitle('Baju', item?.ukuranBaju ?? '-', 4),
                  SizedBox(width: 12),
                  titleSubtitle('Celana', item?.ukuranCelana ?? '-', 5),
                  SizedBox(width: 12),
                  titleSubtitle('Jenis', '${item?.jenisSepatu ?? '-'}', 5),
                  SizedBox(width: 12),
                  titleSubtitle('Ukuran', '${item?.ukuranSepatu ?? '-'}', 5),
                ],
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
