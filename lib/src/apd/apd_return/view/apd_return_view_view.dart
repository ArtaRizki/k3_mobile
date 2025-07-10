import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_dialog.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_view_controller.dart';

class ApdReturnViewView extends GetView<ApdReturnViewController> {
  ApdReturnViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.viewData.value.data;
      final buktiFoto = data?.daftarFoto ?? [];
      final fileTtd = data?.ttdFile ?? '';
      String ttdUrl = fileTtd
      /*.replaceAll(
        '/file_ttd_pengembalian/file_ttd_pengembalian/',
        '/file_ttd_pengembalian/',
      )*/
      ;
      return Scaffold(
        appBar: AppAppbar.basicAppbar(
          // harusnya penerimaanCode atau code saja
          title: controller.viewData.value.data?.code ?? '',
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
                            String fileUrl = item?.file ?? '';
                            // Menghapus duplikasi path
                            String imagesUrl = fileUrl;
                            final latitude = data?.latitude ?? '';
                            final longitude = data?.longitude ?? '';
                            final dateTime = data?.docDate ?? '';
                            return InkWell(
                              onTap: () async {
                                await Geolocator.requestPermission;
                                LocationPermission permission =
                                    await Geolocator.checkPermission();
                                if (permission != LocationPermission.always) {
                                  await Geolocator.requestPermission();
                                  if (permission ==
                                          LocationPermission.deniedForever ||
                                      permission == LocationPermission.denied)
                                    Utils.displaySnackBar(
                                      'Izinkan akses lokasi',
                                    );
                                } else {
                                  await Get.toNamed(
                                    AppRoute.IMAGE_PREVIEW,
                                    arguments: [
                                      '${longitude},${latitude}',
                                      dateTime,
                                      data?.ttdFile ?? '',
                                    ],
                                  );
                                }
                              },
                              child: Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(color: Colors.white),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    // File(item),
                                    imagesUrl,
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
                  // Text(
                  //   'Tanda tangan',
                  //   style: AppTextStyle.actionL.copyWith(
                  //     color: AppColor.neutralDarkDarkest,
                  //   ),
                  // ),
                  // SizedBox(height: 6),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     border: Border.all(color: AppColor.neutralLightDarkest),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   height: 158,
                  //   child: Stack(
                  //     children: [
                  //       InkWell(
                  //         onTap: () async {
                  //           final latitude = data?.latitude ?? '';
                  //           final longitude = data?.longitude ?? '';
                  //           final dateTime = data?.docDate ?? '';
                  //           await Get.toNamed(
                  //             AppRoute.IMAGE_PREVIEW,
                  //             arguments: [
                  //               '${longitude},${latitude}',
                  //               dateTime,
                  //               data?.ttdFile ?? '',
                  //             ],
                  //           );
                  //         },
                  //         child: Center(
                  //           child: Image.network(
                  //             data?.ttdFile ?? '',
                  //             height: 138,
                  //           ),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         top: 125,
                  //         left: 0,
                  //         right: 0,
                  //         child: Text(
                  //           data?.ttdName ?? '',
                  //           textAlign: TextAlign.center,
                  //           style: AppTextStyle.bodyS.copyWith(
                  //             color: AppColor.neutralDarkLight,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _showShippingDataDialog() async {
    controller.shippingNumberC.value.clear();
    controller.expeditionNameC.value.clear();
    await AppDialog.showBasicDialog(
      title: 'Data Pengiriman',
      content: _shippingDataDialog(),
      btn: _sendShippingDataBtn(),
    );
    // Get.back();
  }

  Widget _shippingDataDialog() {
    return GetBuilder<ApdReturnViewController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField.basicTextField(
                hintText: 'Nomor Resi',
                label: 'Nomor Resi',
                controller: controller.shippingNumberC.value,
                onChanged: (p0) => controller.update(),
              ),
              SizedBox(height: 24),
              AppTextField.basicTextField(
                hintText: 'Nama Ekspedisi',
                label: 'Nama Ekspedisi',
                controller: controller.expeditionNameC.value,
                onChanged: (p0) => controller.update(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sendShippingDataBtn({bool isEdit = false, int? index}) {
    return GetBuilder<ApdReturnViewController>(
      builder: (controller) {
        final enable = controller.validateShippingData();
        return AppButton.basicButton(
          enable: enable,
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (enable) await controller.setApdStatus('0');
          },
          width: double.infinity,
          color: AppColor.highlightDarkest,
          height: 50,
          radius: 12,
          padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Text(
            'Ajukan',
            textAlign: TextAlign.center,
            style: AppTextStyle.actionL.copyWith(
              color: AppColor.neutralLightLightest,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActionButtons() {
    final status = controller.viewData.value.data?.docStatus ?? '';
    return [
      if (status == '2')
        _buildActionButton('Ajukan', AppColor.warningDark, () async {
          // ajukan
          _showShippingDataDialog();
        }),
      if (status == '2' || status == '3')
        _buildActionButton('Edit', AppColor.highlightDarkest, () async {
          Get.toNamed(
            AppRoute.APD_RETURN_CREATE,
            arguments: controller.viewData.value.data?.id ?? '',
          );
        }),
      if (status == '2')
        _buildActionButton('Hapus', AppColor.errorDark, () async {
          await controller.setApdStatus('99');
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
      headerItem('Keterangan', data?.description ?? ''),
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
    final data = controller.viewData.value.data?.daftarPengeluaran ?? [];
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
                  titleSubtitle('Sisa', '${item?.qtySisa ?? '0'}', 2),
                  SizedBox(width: 6),
                  titleSubtitle(
                    'Dikembalikan',
                    '${item?.qtyDikembalikan ?? '0'}',
                    2,
                  ),
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
