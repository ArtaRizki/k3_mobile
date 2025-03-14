import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/empty_list.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_dialog.dart';
import 'package:k3_mobile/const/app_dropdown.dart';
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
      appBar: AppAppbar.basicAppbar(title: 'Buat Penerimaan APD'),
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
                      controller: controller.apdReqNumberC.value,
                      label: 'Permintaan APD No',
                      hintText: 'Pilih',
                      onTap: () async {
                        controller.searchApdRequestC.value.clear();
                        AppDialog.showBasicDialog(
                          title: 'Pilih Permintaan APD',
                          content: selectApdReturnDialog(),
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
                        controller.searchExpenditureC.value.clear();
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
                    AppDropdown.normalDropdown(
                      label: 'Status',
                      hintText: 'Pilih Kategori',
                      selectedItem: controller.selectedStatus.value,
                      onChanged: (v) {
                        controller.selectedStatus.value = v;
                        controller.validateForm();
                        FocusManager.instance.primaryFocus?.unfocus();
                        controller.update();
                      },
                      list: controller.statusList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: AppTextStyle.bodyM.copyWith(
                              color: AppColor.neutralDarkMedium,
                            ),
                          ),
                        );
                      }).toList(),
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
                      child: controller.images.isEmpty
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
                                        arguments: item,
                                      );
                                    },
                                    child: Container(
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget list() {
    if (controller.apdRecList.isEmpty) {
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
      itemCount: controller.apdRecList.length,
      itemBuilder: (c, i) {
        final item = controller.apdRecList[i];
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
              titleSubtitle('Nama', item.name, 3),
              SizedBox(width: 6),
              titleSubtitle('Jumlah', item.qty, 2),
              SizedBox(width: 6),
              titleSubtitle('Sisa', item.remainingQty, 1),
              SizedBox(width: 6),
              returnApd(() {}, i),
            ],
          ),
        );
      },
    );
  }

  Widget returnApd(GestureTapCallback onTap, i) {
    return Expanded(
      flex: 3,
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
            controller: controller.apdRecListC[i],
            hintText: 'input',
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            onTap: () async {},
            onChanged: (v) {
              controller.apdRecList[i].returnQty = v;
              controller.update();
            },
          ),
        ],
      ),
    );
  }

  Widget selectApdReturnDialog() {
    return GetBuilder<ApdReturnCreateController>(builder: (controller) {
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
              suffixIconConstraints: BoxConstraints(maxHeight: query ? 23 : 18),
              onChanged: (v) {
                controller.update();
              },
              suffixIcon: InkWell(
                onTap: query ? controller.clearSearchApdField : null,
                child: query
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            Icon(Icons.close, color: AppColor.neutralDarkLight),
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
                itemCount: controller.filteredApdReqSelectList.length,
                itemBuilder: (c, i) {
                  final item = controller.filteredApdReqSelectList[i];
                  return AppCard.listCard(
                    onTap: () async {
                      controller.apdReqNumberC.value.text = item.reqNumber;
                      Get.back();
                    },
                    padding: EdgeInsets.all(6),
                    color: i % 2 == 0
                        ? AppColor.highlightLightest
                        : AppColor.neutralLightLightest,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleSubtitleSelect('Tanggal', item.date, 3),
                        SizedBox(width: 12),
                        titleSubtitleSelect('Permintaan No', item.reqNumber, 3),
                        SizedBox(width: 12),
                        titleSubtitleSelect('Keterangan', item.note, 4),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget selectOutcomeDialog() {
    return GetBuilder<ApdReturnCreateController>(builder: (controller) {
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
              suffixIconConstraints: BoxConstraints(maxHeight: query ? 23 : 18),
              onChanged: (v) {
                controller.update();
              },
              suffixIcon: InkWell(
                onTap: query ? controller.clearSearchExpField : null,
                child: query
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            Icon(Icons.close, color: AppColor.neutralDarkLight),
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
                itemCount: controller.filteredApdExpSelectList.length,
                itemBuilder: (c, i) {
                  final item = controller.filteredApdExpSelectList[i];
                  return AppCard.listCard(
                    onTap: () async {
                      controller.expNumberC.value.text = item.expNumber;
                      controller.vendorC.value.text = item.vendor;
                      Get.back();
                    },
                    padding: EdgeInsets.all(6),
                    color: i % 2 == 0
                        ? AppColor.highlightLightest
                        : AppColor.neutralLightLightest,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleSubtitleSelect('Tanggal', item.date, 3),
                        SizedBox(width: 12),
                        titleSubtitleSelect(
                            'Pengeluaran barang No', item.expNumber, 3),
                        SizedBox(width: 12),
                        titleSubtitleSelect('Vendor', item.vendor, 4),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
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

  Widget _buildLoadingIndicator() {
    return Transform.scale(
      scale: 0.5,
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  Widget _buildSaveDraftButton() {
    return Expanded(
      child: AppButton.basicButton(
        enable: true,
        // enable:
        //     controller.isValidated.value && !controller.loadingSendApd.value,
        onTap: () async {
          if (!controller.loadingSaveDraftApd.value &&
              !controller.loadingSendApd.value) {
            await controller.saveDraftApdReturn();
          }
        },
        color: AppColor.warningDark,
        height: 55,
        radius: 12,
        padding: EdgeInsets.fromLTRB(
            16, controller.loadingSaveDraftApd.value ? 0 : 18, 16, 0),
        child: controller.loadingSaveDraftApd.value
            ? _buildLoadingIndicator()
            : Text(
                'Simpan draft',
                textAlign: TextAlign.center,
                style: AppTextStyle.actionL.copyWith(
                  color: AppColor.neutralLightLightest,
                ),
              ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Expanded(
      child: AppButton.basicButton(
        enable: true,
        // enable: controller.isValidated.value &&
        //     !controller.loadingSaveDraftApd.value,
        onTap: () async {
          if (!controller.loadingSendApd.value &&
              !controller.loadingSaveDraftApd.value) {
            if (controller.isEditMode.value) {
              await controller.editSendApdReturn(controller.indexData.value);
            } else {
              await controller.sendApdReturn();
            }
          }
        },
        color: AppColor.highlightDarkest,
        height: 55,
        radius: 12,
        padding: EdgeInsets.fromLTRB(
            16, controller.loadingSendApd.value ? 0 : 18, 16, 0),
        child: controller.loadingSendApd.value
            ? _buildLoadingIndicator()
            : Text(
                'Ajukan',
                textAlign: TextAlign.center,
                style: AppTextStyle.actionL.copyWith(
                  color: AppColor.neutralLightLightest,
                ),
              ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Row(
            children: [
              _buildSaveDraftButton(),
              SizedBox(width: 12),
              _buildSubmitButton(),
            ],
          ),
        );
      },
    );
  }
}
