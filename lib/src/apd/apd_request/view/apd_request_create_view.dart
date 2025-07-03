
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_param.dart';

class ApdRequestCreateView extends GetView<ApdRequestCreateController> {
  ApdRequestCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutralLightLightest,
      appBar: AppAppbar.basicAppbar(title: 'Buat Permintaan APD'),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Obx(() {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildDateField(),
                  SizedBox(height: 12),
                  _buildNoteField(),
                  // SizedBox(height: 12),
                  // _buildStatusDropdown(),
                  SizedBox(height: 12),
                  _buildRequestListSection(),
                ],
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDateField() {
    return AppTextField.basicTextField(
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
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Image.asset(
          Assets.iconsIcDate,
          color: AppColor.neutralLightDarkest,
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return AppTextField.basicTextField(
      controller: controller.noteC.value,
      label: 'Keterangan',
      hintText: 'Keterangan',
      maxLines: 4,
      onChanged: (v) {
        controller.validateForm();
        controller.update();
      },
    );
  }

  Widget _buildStatusDropdown() {
    return AppDropdown.normalDropdown(
      label: 'Status',
      hintText: 'Pilih Kategori',
      selectedItem: controller.selectedStatus.value,
      onChanged: (v) {
        controller.selectedStatus.value = v;
        controller.validateForm();
        FocusManager.instance.primaryFocus?.unfocus();
        controller.update();
      },
      list:
          controller.statusList.map((item) {
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
    );
  }

  Widget _buildRequestListSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        children: [
          _buildRequestListHeader(),
          SizedBox(height: 12),
          _buildRequestList(),
        ],
      ),
    );
  }

  Widget _buildRequestListHeader() {
    return Row(
      children: [
        Text(
          'Daftar permintaan',
          style: AppTextStyle.actionL.copyWith(
            color: AppColor.neutralDarkLight,
          ),
        ),
        Spacer(),
        AppCard.basicCard(
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            _showAddApdDialog();
          },
          color: AppColor.highlightDarkest,
          radius: 20,
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Text(
            '+ Tambah',
            style: AppTextStyle.actionL.copyWith(
              color: AppColor.neutralLightLightest,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddApdDialog() {
    controller.searchC.value.clear();
    controller.apdNameC.value.clear();
    controller.amountC.value.clear();
    controller.searchApdC.value.clear();
    AppDialog.showBasicDialog(
      title: 'Tambah APD',
      content: _changeApdDialog(),
      btn: _changeApdBtn(),
    );
  }

  Widget _buildRequestList() {
    if (controller.apdReqList.isEmpty) {
      return EmptyList.textEmptyListNoScroll(
        minHeight: Get.size.height * .15,
        topPadding: 50,
        onRefresh: () async {
          controller.update();
        },
      );
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.apdReqList.length,
      itemBuilder: (c, i) {
        final item = controller.apdReqList[i];
        return _buildRequestCard(item, i);
      },
    );
  }

  Widget _buildRequestCard(ApdRequestParamDataApd item, int i) {
    return AppCard.listCard(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      color:
          i % 2 == 0
              ? AppColor.highlightLightest
              : AppColor.neutralLightLightest,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleSubtitle('Kode', item.code ?? '', 3),
                    SizedBox(width: 12),
                    _titleSubtitle('Nama', item.apdName ?? '', 6),
                    SizedBox(width: 12),
                    _titleSubtitle('Kategori', 'Dummy', 3),
                    SizedBox(width: 12),
                    _titleSubtitle('Jumlah', '${item.qty ?? 0}', 3),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleSubtitle('Warna', item.warna ?? '-', 5),
                    SizedBox(width: 12),
                    _titleSubtitle('Baju', item.ukuranBaju ?? '-', 4),
                    SizedBox(width: 12),
                    _titleSubtitle('Celana', item.ukuranCelana ?? '-', 5),
                    SizedBox(width: 12),
                    _titleSubtitle('Jenis', '${item.jenisSepatu ?? '-'}', 5),
                    SizedBox(width: 12),
                    _titleSubtitle('Ukuran', '${item.ukuranSepatu ?? '-'}', 5),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          _editDeleteIcons(
            () {
              _showEditApdDialog(item, i);
            },
            () {
              controller.deleteApdRequest(i);
            },
          ),
        ],
      ),
    );
  }

  void _showEditApdDialog(ApdRequestParamDataApd item, int index) {
    controller.searchC.value.text = item.code ?? '';
    controller.apdNameC.value.text = item.apdName ?? '';
    controller.amountC.value.text = '${item.qty ?? 0}';

    AppDialog.showBasicDialog(
      title: 'Edit APD',
      content: _changeApdDialog(isEdit: true),
      btn: _changeApdBtn(isEdit: true, index: index),
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

  Widget _buildSaveDraftButton() {
    return Expanded(
      child: GetBuilder<ApdRequestCreateController>(
        builder: (controller) {
          final enable =
              controller.validate() &&
              !controller.loadingSaveDraftApd.value &&
              !controller.loadingSendApd.value;
          final loading = controller.loadingSaveDraftApd.value;
          return AppButton.basicButton(
            enable: enable,
            loading: loading,
            onTap: () async {
              await controller.saveDraftApdRequest();
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
      child: GetBuilder<ApdRequestCreateController>(
        builder: (controller) {
          final enable = controller.validate();
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
                  await controller.editSendApdRequest();
                else
                  await controller.sendApdRequest();
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

  Widget _titleSubtitle(String title, String subtitle, int flex) {
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

  Widget _editDeleteIcons(
    GestureTapCallback onEdit,
    GestureTapCallback onDelete,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: onEdit,
          child: Image.asset(Assets.iconsIcEdit, width: 24, height: 24),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: onDelete,
          child: Image.asset(Assets.iconsIcDelete, width: 24, height: 24),
        ),
      ],
    );
  }

  Widget _changeApdDialog({bool isEdit = false}) {
    return Obx(() {
      return SizedBox(
        width: Get.size.width * .8,
        child: SingleChildScrollView(
          child: Column(
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
                    content: _selectApdDialog(),
                  );
                },
                onChanged: (v) {
                  controller.update();
                  controller.validateAddApdForm();
                },
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Image.asset(
                    Assets.iconsIcSearch,
                    color: AppColor.neutralLightDarkest,
                  ),
                ),
              ),
              SizedBox(height: 12),
              AppTextField.basicTextField(
                controller: controller.amountC.value,
                label: 'Jumlah',
                hintText: 'Jumlah',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                ],
                onChanged: (v) {
                  controller.validateAddApdForm();
                  controller.update();
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _changeApdBtn({bool isEdit = false, int? index}) {
    return GetBuilder<ApdRequestCreateController>(
      builder: (controller) {
        final enable =
            controller.validateAddApd() && !controller.loadingAddApd.value;
        final loading = controller.loadingAddApd.value;
        return AppButton.basicButton(
          enable: enable,
          loading: loading,
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (enable) {
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
          padding: EdgeInsets.fromLTRB(16, loading ? 0 : 14, 16, 0),
          child: Text(
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

  Widget _selectApdDialog() {
    return GetBuilder<ApdRequestCreateController>(
      builder: (controller) {
        final query = controller.searchApdC.value.text.isNotEmpty;
        return SizedBox(
          width: Get.size.width * .8,
          height: Get.size.height * .8,
          child: Column(
            children: [
              AppTextField.loginTextField(
                controller: controller.searchApdC.value,
                hintText: 'Cari',
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
              if (controller.filteredApdSelectList.isEmpty) ...[
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
                    itemCount: controller.filteredApdSelectList.length,
                    itemBuilder: (c, i) {
                      final item = controller.filteredApdSelectList[i];
                      return AppCard.listCard(
                        onTap: () async {
                          controller.apdNameC.value.text = item?.name ?? '';
                          controller.searchC.value.text = item?.code ?? '';
                          controller.apdSelectList.add(item);
                          controller.update();

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
                                _titleSubtitle('Kode', item?.code ?? '', 3),
                                SizedBox(width: 12),
                                _titleSubtitle('Nama', item?.name ?? '', 6),
                                SizedBox(width: 12),
                                _titleSubtitle('', '', 3),
                                SizedBox(width: 12),
                                _titleSubtitle(
                                  'Kategori',
                                  item?.kategoriName ?? '',
                                  3,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _titleSubtitle('Warna', item?.warna ?? '-', 5),
                                SizedBox(width: 12),
                                _titleSubtitle(
                                  'Baju',
                                  item?.ukuranBaju ?? '-',
                                  4,
                                ),
                                SizedBox(width: 12),
                                _titleSubtitle(
                                  'Celana',
                                  item?.ukuranCelana ?? '-',
                                  5,
                                ),
                                SizedBox(width: 12),
                                _titleSubtitle(
                                  'Jenis',
                                  '${item?.jenisSepatu ?? '-'}',
                                  5,
                                ),
                                SizedBox(width: 12),
                                _titleSubtitle(
                                  'Ukuran',
                                  '${item?.ukuranSepatu ?? '-'}',
                                  5,
                                ),
                              ],
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
}
