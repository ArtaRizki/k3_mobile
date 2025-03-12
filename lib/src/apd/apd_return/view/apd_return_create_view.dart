import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_dialog.dart';
import 'package:k3_mobile/const/app_dropdown.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_create_controller.dart';

class ApdReturnCreateView extends GetView<ApdReturnCreateController> {
  ApdReturnCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Pengembalian APD',
          style: AppTextStyle.h4.copyWith(
            color: AppColor.neutralDarkLight,
          ),
        ),
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
                    AppTextField.basicTextField(
                      readOnly: true,
                      required: true,
                      controller: controller.dateC.value,
                      label: 'Tanggal',
                      hintText: 'dd-mm-yyyy',
                      onTap: () async {
                        await controller.pickDate();
                        FocusManager.instance.primaryFocus?.unfocus();
                        controller.validateForm();
                      },
                      onChanged: (v) {
                        controller.validateForm();
                        controller.update();
                      },
                      prefixIconConstraints: BoxConstraints(maxHeight: 18),
                      prefixIcon: GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: Image.asset(
                            Assets.iconsIcDate,
                            color: AppColor.neutralLightDarkest,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    AppTextField.basicTextField(
                      readOnly: true,
                      required: true,
                      controller: controller.apdReturnNumberC.value,
                      label: 'Permintaan APD No',
                      hintText: 'Pilih',
                      onTap: () async {
                        AppDialog.showBasicDialog(
                          title: 'Pilih Permintaan APD',
                          content: selectApdRequestDialog(),
                        );
                      },
                      onChanged: (v) {
                        controller.validateForm();
                        controller.update();
                      },
                      suffixIconConstraints: BoxConstraints(maxHeight: 18),
                      suffixIcon: GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Image.asset(
                            Assets.iconsIcSearch,
                            color: AppColor.neutralLightDarkest,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    AppTextField.basicTextField(
                      readOnly: true,
                      required: true,
                      controller: controller.outcomeNumberC.value,
                      label: 'Pengeluaran Barang No',
                      hintText: 'Pilih',
                      onTap: () async {
                        AppDialog.showBasicDialog(
                          title: 'Pilih Pengeluaran Barang',
                          content: selectOutcomeDialog(),
                        );
                      },
                      onChanged: (v) {
                        controller.validateForm();
                        controller.update();
                      },
                      suffixIconConstraints: BoxConstraints(maxHeight: 18),
                      suffixIcon: GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Image.asset(
                            Assets.iconsIcSearch,
                            color: AppColor.neutralLightDarkest,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    AppTextField.basicTextField(
                      readOnly: true,
                      required: true,
                      controller: controller.vendorC.value,
                      label: 'Vendor',
                      hintText: 'Pilih',
                      onChanged: (v) {
                        controller.validateForm();
                        controller.update();
                      },
                      suffixIconConstraints: BoxConstraints(maxHeight: 18),
                      suffixIcon: GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Image.asset(
                            Assets.iconsIcSearch,
                            color: AppColor.neutralLightDarkest,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    AppTextField.basicTextField(
                      controller: controller.noteC.value,
                      label: 'Keterangan',
                      hintText: 'Keterangan',
                      onChanged: (v) {
                        controller.validateForm();
                        controller.update();
                      },
                      maxLines: 4,
                    ),
                    SizedBox(height: 12),
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
                          Signature(
                            key: controller.signKey.value,
                            color: Colors.black,
                            strokeWidth: 3,
                            onSign: () {
                              log("ON SIGN");
                              controller.showHintSignature.value = false;
                            },
                          ),
                          if (controller.showHintSignature.value)
                            Center(
                              child: Text(
                                'Tanda tangan di sini',
                                style: AppTextStyle.bodyM.copyWith(
                                    color: AppColor.neutralLightDarkest),
                              ),
                            )
                          else
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
              ? AppColor.neutralLightLightest
              : AppColor.highlightLightest,
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
                'Kategori',
                'Sipil',
                3,
              ),
              SizedBox(width: 6),
              titleSubtitle(
                'Nama',
                'Helm Proyek',
                2,
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
                1,
              ),
              SizedBox(width: 6),
              receive(() {}),
            ],
          ),
        );
      },
    );
  }

  Widget receive(GestureTapCallback onTap) {
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

  Widget selectApdRequestDialog() {
    return SizedBox(
      width: Get.size.width * .8,
      height: Get.size.height * .8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField.loginTextField(
            controller: controller.searchApdRequestC.value,
            hintText: 'Search',
            suffixIconConstraints: BoxConstraints(maxHeight: 18),
            onTap: () async {},
            onChanged: (v) {
              controller.update();
            },
            suffixIcon: GestureDetector(
              onTap: null,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(
                  Assets.iconsIcSearch,
                  color: AppColor.neutralLightDarkest,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (c, i) {
                return AppCard.listCard(
                  onTap: () async {
                    Get.back();
                  },
                  padding: EdgeInsets.all(6),
                  color: i % 2 == 0
                      ? AppColor.neutralLightLightest
                      : AppColor.highlightLightest,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleSubtitleSelect(
                        'Tanggal',
                        '15/02/2025',
                        3,
                      ),
                      SizedBox(width: 12),
                      titleSubtitleSelect(
                        'Permintaan No',
                        'ARQ/2025/II/00$i',
                        3,
                      ),
                      SizedBox(width: 12),
                      titleSubtitleSelect(
                        'Keterangan',
                        'Minta Sepatu safety',
                        4,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget selectOutcomeDialog() {
    return SizedBox(
      width: Get.size.width * .8,
      height: Get.size.height * .8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField.loginTextField(
            controller: controller.searchOutcomeC.value,
            hintText: 'Search',
            suffixIconConstraints: BoxConstraints(maxHeight: 18),
            onTap: () async {},
            onChanged: (v) {
              controller.update();
            },
            suffixIcon: GestureDetector(
              onTap: null,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(
                  Assets.iconsIcSearch,
                  color: AppColor.neutralLightDarkest,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (c, i) {
                return AppCard.listCard(
                  onTap: () async {
                    Get.back();
                  },
                  padding: EdgeInsets.all(6),
                  color: i % 2 == 0
                      ? AppColor.neutralLightLightest
                      : AppColor.highlightLightest,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleSubtitleSelect(
                        'Tanggal',
                        '15/02/2025',
                        3,
                      ),
                      SizedBox(width: 12),
                      titleSubtitleSelect(
                        'Pengeluaran barang No',
                        'GDI/2025/II/00$i',
                        3,
                      ),
                      SizedBox(width: 12),
                      titleSubtitleSelect(
                        'Vendor',
                        'Kantor Pusat',
                        4,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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
