import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/empty_list.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_dialog.dart';
import 'package:k3_mobile/const/app_dropdown.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_create_controller.dart';

class ApdRequestCreateView extends GetView<ApdRequestCreateController> {
  ApdRequestCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutralLightLightest,
      appBar: AppAppbar.basicAppbar(title: 'Buat Permintaan APD'),
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
                      controller: controller.noteC.value,
                      label: 'Keterangan',
                      hintText: 'Keterangan',
                      maxLines: 4,
                      onChanged: (v) {
                        controller.validateForm();
                        controller.update();
                      },
                    ),
                    SizedBox(height: 12),
                    AppDropdown.normalDropdown(
                      label: 'Status',
                      // readOnly: controller.isEditMode.value,
                      hintText: 'Pilih Kategori',
                      selectedItem: controller.selectedStatus.value,
                      onChanged: (v) {
                        controller.selectedStatus.value = v;
                        controller.validateForm();
                        FocusManager.instance.primaryFocus?.unfocus();
                        controller.update();
                      },
                      list: List.generate(
                        controller.statusList.length,
                        (i) {
                          final item = controller.statusList[i];
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: AppTextStyle.bodyM.copyWith(
                                color: AppColor.neutralDarkMedium,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Daftar permintaan',
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.actionL.copyWith(
                                    color: AppColor.neutralDarkLight,
                                  ),
                                ),
                                Spacer(),
                                AppCard.basicCard(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    controller.searchC.value.clear();
                                    controller.apdNameC.value.clear();
                                    controller.amountC.value.clear();
                                    controller.searchApdC.value.clear();
                                    AppDialog.showBasicDialog(
                                      title: 'Tambah APD',
                                      content: changeApdDialog(),
                                      btn: changeApdBtn(),
                                    );
                                  },
                                  color: AppColor.highlightDarkest,
                                  radius: 20,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '+ Tambah',
                                    style: AppTextStyle.actionL.copyWith(
                                      color: AppColor.neutralLightLightest,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            if (controller.apdReqList.isEmpty) ...[
                              EmptyList.textEmptyListNoScroll(
                                minHeight: Get.size.height * .15,
                                topPadding: 50,
                                onRefresh: () async {
                                  controller.update();
                                },
                              ),
                            ] else ...[
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.apdReqList.length,
                                itemBuilder: (c, i) {
                                  final item = controller.apdReqList[i];
                                  return AppCard.listCard(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 6),
                                    color: i % 2 == 0 && i != 0
                                        ? AppColor.neutralLightLightest
                                        : AppColor.highlightLightest,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        titleSubtitle(
                                          'Kode',
                                          item.code,
                                          2,
                                        ),
                                        SizedBox(width: 12),
                                        titleSubtitle(
                                          'Nama',
                                          item.name,
                                          3,
                                        ),
                                        SizedBox(width: 12),
                                        titleSubtitle(
                                          'Jumlah',
                                          item.qty,
                                          1,
                                        ),
                                        SizedBox(width: 12),
                                        editDelete(
                                          () {
                                            controller.searchC.value.text =
                                                item.name;
                                            controller.apdNameC.value.text =
                                                item.name;
                                            controller.amountC.value.text =
                                                item.qty;
                                            AppDialog.showBasicDialog(
                                              title: 'Edit APD',
                                              content:
                                                  changeApdDialog(isEdit: true),
                                              btn: changeApdBtn(
                                                  isEdit: true, index: i),
                                            );
                                          },
                                          () {
                                            controller.deleteApdRequest(i);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
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
      bottomNavigationBar: Obx(
        () {
          return Padding(
            padding: EdgeInsets.only(top: 12, bottom: 24, left: 24, right: 24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: AppButton.basicButton(
                    enable: controller.isValidated.value &&
                        !controller.loadingSendApd.value,
                    onTap: () async {
                      if (!controller.loadingSaveDraftApd.value &&
                          !controller.loadingSendApd.value)
                        await controller.saveDraftApdRequest();
                    },
                    width: double.infinity,
                    color: AppColor.warningDark,
                    height: 55,
                    radius: 12,
                    padding: EdgeInsets.fromLTRB(16,
                        controller.loadingSaveDraftApd.value ? 0 : 18, 16, 0),
                    child: controller.loadingSaveDraftApd.value
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
                            'Simpan draft',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.actionL.copyWith(
                              color: AppColor.neutralLightLightest,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppButton.basicButton(
                    enable: controller.isValidated.value &&
                        !controller.loadingSaveDraftApd.value,
                    onTap: () async {
                      if (!controller.loadingSendApd.value &&
                          !controller.loadingSaveDraftApd.value) {
                        if (controller.isEditMode.value)
                          await controller
                              .editSendApdRequest(controller.indexData.value);
                        else
                          await controller.sendApdRequest();
                      }
                    },
                    width: double.infinity,
                    color: AppColor.highlightDarkest,
                    height: 55,
                    radius: 12,
                    padding: EdgeInsets.fromLTRB(
                        16, controller.loadingSendApd.value ? 0 : 18, 16, 0),
                    child: controller.loadingSendApd.value
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
                            'Ajukan',
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

  Widget editDelete(GestureTapCallback onEdit, GestureTapCallback onDelete) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onEdit,
          child: Image.asset(
            Assets.iconsIcEdit,
            width: 24,
            height: 24,
          ),
        ),
        SizedBox(width: 6),
        InkWell(
          onTap: onDelete,
          child: Image.asset(
            Assets.iconsIcDelete,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget changeApdDialog({bool isEdit = false}) {
    return Obx(
      () {
        return SizedBox(
          width: Get.size.width * .8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField.basicTextField(
                  readOnly: true,
                  label: 'Nama APD',
                  controller: controller.searchC.value,
                  hintText: 'Search',
                  suffixIconConstraints: BoxConstraints(maxHeight: 18),
                  onTap: () async {
                    AppDialog.showBasicDialog(
                      title: 'Pilih APD',
                      content: selectApdDialog(),
                    );
                  },
                  onChanged: (v) {
                    controller.update();
                    controller.validateAddApdForm();
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
                SizedBox(height: 12),
                AppTextField.basicTextField(
                  controller: controller.amountC.value,
                  label: 'Jumlah',
                  hintText: 'Jumlah',
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    controller.validateAddApdForm();
                    controller.update();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget changeApdBtn({bool isEdit = false, int? index}) {
    return GetBuilder<ApdRequestCreateController>(
      builder: (controller) {
        return AppButton.basicButton(
          enable: controller.isValidatedAddApd.value &&
              !controller.loadingAddApd.value,
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (!controller.loadingAddApd.value &&
                controller.isValidatedAddApd.value) {
              if (isEdit)
                await controller.editApdRequest(index!);
              else
                await controller.addApdRequest();
            }
          },
          width: double.infinity,
          color: AppColor.highlightDarkest,
          height: 50,
          radius: 12,
          padding: EdgeInsets.fromLTRB(
            16,
            controller.loading.value ? 0 : 14,
            16,
            0,
          ),
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
                  isEdit ? 'Edit' : 'Tambah',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.actionL.copyWith(
                    color: AppColor.neutralLightLightest,
                  ),
                ),
        );
      },
    );
  }

  Widget selectApdDialog() {
    return GetBuilder<ApdRequestCreateController>(
      builder: (controller) {
        final query = controller.searchApdC.value.text.isNotEmpty;
        return SizedBox(
          width: Get.size.width * .8,
          height: Get.size.height * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField.loginTextField(
                controller: controller.searchApdC.value,
                hintText: 'Cari',
                suffixIconConstraints:
                    BoxConstraints(maxHeight: query ? 23 : 18),
                onTap: () async {},
                onChanged: (v) {
                  controller.update();
                },
                suffixIcon: InkWell(
                  onTap: query ? controller.clearSearchApdField : null,
                  child: query
                      ? Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(
                              Icons.close,
                              color: AppColor.neutralDarkLight,
                            ),
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
                  itemCount: controller.filteredApdSelectList.length,
                  itemBuilder: (c, i) {
                    final item = controller.filteredApdSelectList[i];
                    return AppCard.listCard(
                      onTap: () async {
                        controller.apdNameC.value.text = item.name;
                        controller.searchC.value.text = item.code;
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
                            item.code,
                            3,
                          ),
                          SizedBox(width: 12),
                          titleSubtitle(
                            'Kategori',
                            item.category,
                            3,
                          ),
                          SizedBox(width: 12),
                          titleSubtitle(
                            'Nama',
                            item.name,
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
}
