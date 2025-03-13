
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_view_controller.dart';

class ApdReturnViewView extends GetView<ApdReturnViewController> {
  ApdReturnViewView({super.key});

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
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: controller.pictureList.isEmpty
                          ? addImageBtn()
                          : Wrap(
                              spacing: 10,
                              children: List.generate(
                                controller.pictureList.isEmpty
                                    ? 1
                                    : controller.pictureList.length + 1,
                                (i) {
                                  if (i == controller.pictureList.length)
                                    return addImageBtn();
                                  final item = controller.pictureList[i];
                                  return Container(
                                    width: 68,
                                    height: 68,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.file(
                                            item,
                                            width: 68,
                                            height: 68,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          right: -1,
                                          top: -1,
                                          child: GestureDetector(
                                            onTap: () =>
                                                controller.removePicture(i),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: Image.asset(
                                                Assets.iconsIcRemoveImage,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
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
                            child: Image.asset(
                              Assets.imagesImgSampleSignature,
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
                    Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 24),
                      child: AppButton.basicButton(
                        enable: controller.isValidated.value,
                        onTap: () async {
                          if (!controller.loading.value)
                            await controller.sendApdReturn();
                        },
                        width: double.infinity,
                        color: AppColor.highlightDarkest,
                        height: 55,
                        radius: 12,
                        padding: EdgeInsets.fromLTRB(
                            16, controller.loading.value ? 0 : 16, 16, 0),
                        child: controller.loading.value
                            ? Transform.scale(
                                scale: 0.5,
                                child: SizedBox(
                                  width: 16,
                                  height: 6,
                                  child: FittedBox(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                'Kirim',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.actionL.copyWith(
                                  color: AppColor.neutralLightLightest,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
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

  List<Widget> headerApdRequest() {
    return [
      headerItem('Permintaan APD No', 'ARQ/2025/II/001'),
      SizedBox(height: 9),
      headerItem('Tanggal', '12/02/2025'),
    ];
  }

  List<Widget> headerOutcome() {
    return [
      headerItem('Pengeluaran barang No', 'GDI/2025/II/001'),
      SizedBox(height: 9),
      headerItem('Tanggal', '12/02/2025'),
      SizedBox(height: 9),
      headerItem('Vendor', 'Kantor Pusat'),
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
      shrinkWrap: true,
      itemCount: 10,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (c, i) {
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
              titleSubtitle(
                'Kode',
                'APD00${i + 1}',
                3,
              ),
              SizedBox(width: 6),
              titleSubtitle(
                'Nama',
                'Helm Proyek',
                4,
              ),
              SizedBox(width: 6),
              titleSubtitle(
                'Jumlah',
                '${(i + 1) * 10}',
                2,
              ),
              SizedBox(width: 6),
              titleSubtitle(
                'Sisa',
                '${(i + 1) * 10}',
                2,
              ),
              SizedBox(width: 6),
              titleSubtitle(
                'Diterima',
                '${(i + 1) - 1}',
                2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget receive(GestureTapCallback onTap) {
    {
      return Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diterima',
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkLightest,
              ),
            ),
            SizedBox(height: 6),
            AppButton.basicButton(
              enable: true,
              color: AppColor.neutralLightLightest,
              radius: 6,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              border: Border.all(
                width: 0.5,
                color: AppColor.neutralDarkLightest,
              ),
              child: Text(
                'input',
                style: AppTextStyle.bodyS.copyWith(
                  color: AppColor.neutralLightDarkest,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return AppButton.basicButton(
      color: AppColor.neutralLightLightest,
      radius: 6,
      padding: EdgeInsets.symmetric(vertical: 10),
      border: Border.all(
        width: 0.5,
        color: AppColor.neutralDarkLightest,
      ),
      child: Text(
        'Input',
        style: AppTextStyle.bodyS.copyWith(
          color: AppColor.neutralLightDarkest,
        ),
      ),
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

  Widget addImageBtn() {
    return GestureDetector(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        await controller.addPicture();
        controller.validateForm();
      },
      child: DottedBorder(
        dashPattern: [6, 3],
        color: AppColor.highlightDark,
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 26,
                  color: AppColor.highlightDark,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
