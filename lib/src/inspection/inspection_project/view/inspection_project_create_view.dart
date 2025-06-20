import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_dropdown.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/inspection/inspection_project/controller/inspection_project_create_controller.dart';

class InspectionProjectCreateView
    extends GetView<InspectionProjectCreateController> {
  InspectionProjectCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppAppbar.basicAppbar(
          title:
              controller.isViewMode.value
                  ? controller.inspectionViewModelData.value.data?.code ?? ''
                  : 'Buat Inspeksi Proyek',
        ),
        body: SafeArea(
          child: Container(
            color: AppColor.neutralLightLightest,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ..._buildFormFields(),
                  ..._buildImageSection(),
                  ..._buildFollowUpSection(),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      _textField(controller.projectNameC.value, 'Nama Proyek'),
      _dateTimeFields(),
      _categoryDropdown(),
      _textField(controller.riskC.value, 'Resiko'),
      _textField(
        controller.eventLocationC.value,
        'Lokasi kejadian',
        maxLines: 4,
      ),
      _textField(
        controller.eventChronologyC.value,
        'Kronologi kejadian',
        maxLines: 4,
      ),
      _actionTakenCheckbox(),
      _textField(controller.reasonC.value, 'Alasan', maxLines: 4),
      _textField(
        controller.actionDetailC.value,
        'Rincian tindakan',
        maxLines: 4,
      ),
      _textField(
        controller.givenRecommendationC.value,
        'Saran diberikan',
        maxLines: 4,
      ),
    ];
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField.basicTextField(
        readOnly: this.controller.isViewMode.value,
        controller: controller,
        label: label,
        hintText: label,
        maxLines: maxLines,
        onChanged: (v) {
          this.controller.validateForm();
          this.controller.update();
        },
      ),
    );
  }

  Widget _dateField() {
    return AppTextField.basicTextField(
      readOnly: true,
      controller: controller.dateC.value,
      label: 'Tanggal',
      hintText: 'dd-mm-yyyy',
      onTap: () async {
        await controller.pickDate();
        FocusManager.instance.primaryFocus?.unfocus();
        controller.validateForm();
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

  Widget _timeField() {
    return AppTextField.basicTextField(
      readOnly: true,
      controller: controller.timeC.value,
      label: 'Jam',
      hintText: 'hh:mm',
      onTap: () async {
        await controller.pickTime();
        FocusManager.instance.primaryFocus?.unfocus();
        controller.validateForm();
      },
      prefixIconConstraints: BoxConstraints(maxHeight: 18),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Image.asset(
          Assets.iconsIcTime,
          color: AppColor.neutralLightDarkest,
        ),
      ),
    );
  }

  Widget _dateTimeFields() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(flex: 6, child: _dateField()),
          const SizedBox(width: 12),
          Expanded(flex: 4, child: _timeField()),
        ],
      ),
    );
  }

  Widget _categoryDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppDropdown.normalDropdown(
          label: 'Kategori',
          readOnly: controller.isViewMode.value,
          hintText: 'Pilih Kategori',
          selectedItem: controller.selectedCategory.value,
          onChanged: (v) {
            controller.selectedCategory.value = v;
            controller.validateForm();
            controller.update();
          },
          list:
              controller.categoryList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e?.id ?? '',
                      child: Text(
                        e?.name ?? '',
                        style: AppTextStyle.bodyM.copyWith(
                          color: AppColor.neutralDarkMedium,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _actionTakenCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dilakukan tindakan?',
            style: AppTextStyle.actionL.copyWith(
              color: AppColor.neutralDarkDarkest,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _checkboxOption(
                'Ya',
                controller.actionTakenYes,
                controller.actionTakenNo,
              ),
              _checkboxOption(
                'Tidak',
                controller.actionTakenNo,
                controller.actionTakenYes,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _checkboxOption(String label, RxBool value, RxBool otherValue) {
    return Expanded(
      flex: 5,
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value.value,
              onChanged: (val) {
                value.value = val ?? false;
                otherValue.value = !(val ?? false);
              },
              activeColor: AppColor.highlightDarkest,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.bodyM.copyWith(
                color: AppColor.neutralDarkDarkest,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildImageSection() {
    final isView = controller.isViewMode.value;
    final imageData =
        controller.inspectionViewModelData.value.data?.buktiFoto ?? [];

    return [
      const SizedBox(height: 12),
      Text(
        'Gambar',
        style: AppTextStyle.actionL.copyWith(
          color: AppColor.neutralDarkDarkest,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child:
            isView
                ? _buildImagePreviewList(imageData)
                : _buildImageUploadList(),
      ),
    ];
  }

  Widget _buildImagePreviewList(List imageData) {
    if (imageData.isEmpty) return const Center(child: Text('Tidak ada gambar'));

    return Wrap(
      spacing: 10,
      children:
          imageData.map((item) {
            return InkWell(
              onTap:
                  () async => await Get.toNamed(
                    AppRoute.IMAGE_PREVIEW,
                    arguments: item,
                  ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item?.file ?? '',
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildImageUploadList() {
    return Wrap(
      spacing: 10,
      children: List.generate(controller.pictureList.length + 1, (i) {
        if (i == controller.pictureList.length) return _addImageBtn();
        final item = controller.pictureList[i];

        return InkWell(
          onTap:
              () async => await Get.toNamed(
                AppRoute.IMAGE_PREVIEW,
                arguments: item.path,
              ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                  onTap: () => controller.removePicture(i),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(Assets.iconsIcRemoveImage),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _addImageBtn() {
    return GestureDetector(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        await controller.addPicture();
        controller.validateForm();
      },
      child: DottedBorder(
        dashPattern: const [6, 3],
        color: AppColor.highlightDark,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Text(
            '+',
            style: TextStyle(fontSize: 26, color: AppColor.highlightDark),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFollowUpSection() {
    final data = controller.inspectionViewModelData.value.data;
    if (data?.docStatus != '1') return [const SizedBox()];

    return [
      const SizedBox(height: 48),
      Center(
        child: Text(
          'TINDAK LANJUT',
          style: AppTextStyle.actionL.copyWith(color: const Color(0xff1F2024)),
        ),
      ),
      const SizedBox(height: 24),
      Text(
        'Dilakukan tindak lanjut?',
        style: AppTextStyle.actionL.copyWith(
          color: AppColor.neutralDarkDarkest,
        ),
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          _checkboxOption(
            'Ya',
            RxBool(data?.tindakLanjut == 1),
            RxBool(data?.tindakLanjut != 1),
          ),
          _checkboxOption(
            'Tidak',
            RxBool(data?.tindakLanjut == 0),
            RxBool(data?.tindakLanjut != 0),
          ),
        ],
      ),
      const SizedBox(height: 30),
      _textField(
        TextEditingController(text: data?.tindakanTindakLanjut ?? ''),
        'Rincian tindak lanjut',
        maxLines: 4,
      ),
    ];
  }

  Widget _buildSubmitButton() {
    if (controller.isViewMode.value) return const SizedBox(height: 24);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: AppButton.basicButton(
        enable: controller.isValidated.value,
        loading: controller.loading.value,
        onTap:
            controller.loading.value ? null : controller.sendInspectionProject,
        width: double.infinity,
        color: AppColor.highlightDarkest,
        height: 55,
        radius: 12,
        padding: EdgeInsets.fromLTRB(
          16,
          controller.loading.value ? 0 : 16,
          16,
          0,
        ),
        child: Text(
          'Kirim',
          textAlign: TextAlign.center,
          style: AppTextStyle.actionL.copyWith(
            color: AppColor.neutralLightLightest,
          ),
        ),
      ),
    );
  }
}
