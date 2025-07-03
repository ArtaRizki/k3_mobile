import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/empty_list.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_dialog.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/apd_return/controller/apd_return_create_controller.dart';

class ApdReturnCreateView extends GetView<ApdReturnCreateController> {
  ApdReturnCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(title: 'Buat Pengembalian APD'),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Obx(() {
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
                    controller: controller.apdReqNumberC.value,
                    label: 'Permintaan APD No',
                    hintText: 'Pilih',
                    onTap: () async {
                      controller.searchApdRequestC.value.clear();
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
                    controller: controller.expNumberC.value,
                    label: 'Pengeluaran Barang No',
                    hintText: 'Pilih',
                    onTap: () async {
                      if (controller.apdReqNumberC.value.text.isNotEmpty) {
                        controller.searchExpenditureC.value.clear();
                        await AppDialog.showBasicDialog(
                          title: 'Pilih Pengeluaran Barang',
                          content: selectOutcomeDialog(),
                        );
                      }
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
                  // AppDropdown.normalDropdown(
                  //   label: 'Status',
                  //   hintText: 'Pilih Kategori',
                  //   selectedItem: controller.selectedStatus.value,
                  //   onChanged: (v) {
                  //     controller.selectedStatus.value = v;
                  //     controller.validateForm();
                  //     FocusManager.instance.primaryFocus?.unfocus();
                  //     controller.update();
                  //   },
                  //   list:
                  //       controller.statusList.map((item) {
                  //         return DropdownMenuItem(
                  //           value: item,
                  //           child: Text(
                  //             item,
                  //             style: AppTextStyle.bodyM.copyWith(
                  //               color: AppColor.neutralDarkMedium,
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  // ),
                  // SizedBox(height: 12),
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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child:
                        controller.images.isEmpty
                            ? addImageBtn()
                            : Wrap(
                              spacing: 10,
                              children: List.generate(
                                controller.images.isEmpty
                                    ? 1
                                    : controller.images.length + 1,
                                (i) {
                                  if (i == controller.images.length)
                                    return addImageBtn();
                                  final item = controller.images[i];
                                  return InkWell(
                                    onTap: () async {
                                      await Get.toNamed(
                                        AppRoute.IMAGE_PREVIEW,
                                        arguments: [null, null, item.path],
                                      );
                                    },
                                    child: Container(
                                      width: 68,
                                      height: 68,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                              onTap:
                                                  () => controller
                                                      .removePicture(i),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                  ),
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
                        Signature(
                          key: controller.signKey.value,
                          color: Colors.black,
                          strokeWidth: 3,
                          onSign: () {
                            log("ON SIGN");
                            controller.showHintSignature.value = false;
                            controller.validateForm();
                          },
                        ),
                        if (controller.showHintSignature.value)
                          Center(
                            child: Text(
                              'Tanda tangan di sini',
                              style: AppTextStyle.bodyM.copyWith(
                                color: AppColor.neutralLightDarkest,
                              ),
                            ),
                          )
                        else
                          Positioned(
                            top: 125,
                            left: 0,
                            right: 0,
                            child: Text(
                              controller.loginModel.value?.data?.name ?? '',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.bodyS.copyWith(
                                color: AppColor.neutralDarkLight,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget list() {
    if (controller.apdRetList.isEmpty) {
      return EmptyList.textEmptyListNoScroll(
        minHeight: Get.size.height * .15,
        onRefresh: () async {
          controller.update();
        },
      );
    }
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.apdRetList.length,
      itemBuilder: (c, i) {
        final item = controller.apdRetList[i];
        return AppCard.listCard(
          onTap: () async {
            // Get.back();
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
                  titleSubtitle('Kode', item.code ?? '', 3),
                  SizedBox(width: 6),
                  titleSubtitle('Nama', item.name ?? '', 3),
                  SizedBox(width: 6),
                  titleSubtitle('Jumlah', '${item.qtyJumlah ?? 0}', 2),
                  SizedBox(width: 6),
                  titleSubtitle('Sisa', '${item.qtySisa ?? 0}', 1),
                  SizedBox(width: 6),
                  returned(() {}, i),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleSubtitle('Warna', item.warna ?? '-', 5),
                  SizedBox(width: 12),
                  titleSubtitle('Baju', item.ukuranBaju ?? '-', 4),
                  SizedBox(width: 12),
                  titleSubtitle('Celana', item.ukuranCelana ?? '-', 5),
                  SizedBox(width: 12),
                  titleSubtitle('Jenis', '${item.jenisSepatu ?? '-'}', 5),
                  SizedBox(width: 12),
                  titleSubtitle('Ukuran', '${item.ukuranSepatu ?? '-'}', 5),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget returned(GestureTapCallback onTap, i) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dikembalikan',
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkLightest,
            ),
          ),
          SizedBox(height: 6),
          AppTextField.basicTextField(
            label: '',
            radius: 6,
            isDense: true,
            prefix: SizedBox(width: 12),
            keyboardType: TextInputType.number,
            controller: controller.apdRetListC[i],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
            ],
            hintText: 'input',
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            onTap: () async {},
            onChanged: (v) {
              controller.apdRetList[i].qtyDikembalikan = int.tryParse(v) ?? 0;
              controller.update();
              controller.validateForm();
            },
          ),
        ],
      ),
    );
  }

  Widget selectApdRequestDialog() {
    return GetBuilder<ApdReturnCreateController>(
      builder: (controller) {
        final query = controller.searchApdRequestC.value.text.isNotEmpty;
        return SizedBox(
          width: Get.size.width * .8,
          height: Get.size.height * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField.loginTextField(
                controller: controller.searchApdRequestC.value,
                hintText: 'Search',
                suffixIconConstraints: BoxConstraints(
                  maxHeight: query ? 23 : 18,
                ),
                onChanged: (v) {
                  controller.update();
                },
                suffixIcon: InkWell(
                  onTap: query ? controller.clearSearchApdField : null,
                  child:
                      query
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(
                              Icons.close,
                              color: AppColor.neutralDarkLight,
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Image.asset(
                              Assets.iconsIcSearch,
                              color: AppColor.neutralLightDarkest,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 24),
              if (controller.filteredApdReqSelectList.isEmpty) ...[
                EmptyList.textEmptyListNoScroll(
                  minHeight: Get.size.height * .25,
                  onRefresh: () async {
                    controller.update();
                  },
                ),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.filteredApdReqSelectList.length,
                    itemBuilder: (c, i) {
                      final item = controller.filteredApdReqSelectList[i];
                      return AppCard.listCard(
                        onTap: () async {
                          await controller.getApdPermintaanById(item?.id ?? '');
                          controller.apdReqNumberC.value.text =
                              item?.code ?? '';
                          controller.selectedApdReq.value = item;
                          Get.back();
                        },
                        padding: EdgeInsets.all(6),
                        color:
                            i % 2 == 0
                                ? AppColor.highlightLightest
                                : AppColor.neutralLightLightest,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleSubtitleSelect(
                              'Tanggal',
                              item?.docDate ?? '',
                              3,
                            ),
                            SizedBox(width: 12),
                            titleSubtitleSelect(
                              'Permintaan No',
                              item?.code ?? '',
                              3,
                            ),
                            SizedBox(width: 12),
                            titleSubtitleSelect(
                              'Keterangan',
                              item?.description ?? '',
                              4,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget selectOutcomeDialog() {
    return GetBuilder<ApdReturnCreateController>(
      builder: (controller) {
        final query = controller.searchExpenditureC.value.text.isNotEmpty;
        return SizedBox(
          width: Get.size.width * .8,
          height: Get.size.height * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField.loginTextField(
                controller: controller.searchExpenditureC.value,
                hintText: 'Search',
                suffixIconConstraints: BoxConstraints(
                  maxHeight: query ? 23 : 18,
                ),
                onChanged: (v) {
                  controller.update();
                },
                suffixIcon: InkWell(
                  onTap: query ? controller.clearSearchExpField : null,
                  child:
                      query
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(
                              Icons.close,
                              color: AppColor.neutralDarkLight,
                            ),
                          )
                          : Padding(
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
                  itemCount: controller.filteredExpSelectList.length,
                  itemBuilder: (c, i) {
                    final item = controller.filteredExpSelectList[i];
                    return AppCard.listCard(
                      onTap: () async {
                        controller.expNumberC.value.text = item?.code ?? '';
                        controller.vendorC.value.text = item?.vendorName ?? '';
                        controller.selectedExp.value = item;
                        Get.back();
                      },
                      padding: EdgeInsets.all(6),
                      color:
                          i % 2 == 0
                              ? AppColor.highlightLightest
                              : AppColor.neutralLightLightest,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleSubtitleSelect(
                            'Tanggal',
                            item?.docDate ?? '',
                            3,
                          ),
                          SizedBox(width: 12),
                          titleSubtitleSelect(
                            'Pengeluaran barang No',
                            item?.code ?? '',
                            3,
                          ),
                          SizedBox(width: 12),
                          titleSubtitleSelect(
                            'Vendor',
                            item?.vendorName ?? '',
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
                style: TextStyle(fontSize: 26, color: AppColor.highlightDark),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Transform.scale(
      scale: 0.5,
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  Widget _buildSaveDraftButton() {
    return Expanded(
      child: GetBuilder<ApdReturnCreateController>(
        builder: (controller) {
          final enable =
              controller.isValidated.value &&
              !controller.loadingSaveDraftApd.value &&
              !controller.loadingSendApd.value;
          final loading = controller.loadingSaveDraftApd.value;
          return AppButton.basicButton(
            enable: enable,
            loading: loading,
            onTap: () async {
              await controller.saveDraftApdReturn();
            },
            color: AppColor.warningDark,
            height: 55,
            radius: 12,
            padding: EdgeInsets.fromLTRB(16, loading ? 0 : 18, 16, 0),
            child: Text(
              'Simpan draft',
              textAlign: TextAlign.center,
              style: AppTextStyle.actionL.copyWith(
                color: AppColor.neutralLightLightest,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Expanded(
      child: GetBuilder<ApdReturnCreateController>(
        builder: (controller) {
          final enable = controller.isValidated.value;
          final enableOnTap =
              !controller.loadingSaveDraftApd.value &&
              !controller.loadingSendApd.value;
          final loading = controller.loadingSendApd.value;
          return AppButton.basicButton(
            enable: enable,
            loading: loading,
            onTap: () async {
              if (enableOnTap) {
                if (controller.isEditMode.value)
                  await controller.editSendApdReturn();
                else
                  await controller.sendApdReturn();
              }
            },
            color: AppColor.highlightDarkest,
            height: 55,
            radius: 12,
            padding: EdgeInsets.fromLTRB(16, loading ? 0 : 18, 16, 0),
            child: Text(
              'Ajukan',
              textAlign: TextAlign.center,
              style: AppTextStyle.actionL.copyWith(
                color: AppColor.neutralLightLightest,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() {
      final data = controller.viewData.value.data;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Row(
          children: [
            // if (data == null)
            _buildSaveDraftButton(),
            // if (data == null)
            SizedBox(width: 12),
            _buildSubmitButton(),
          ],
        ),
      );
    });
  }
}
