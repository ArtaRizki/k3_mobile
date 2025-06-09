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
import 'package:k3_mobile/src/inspection/inspection_routine/controller/inspection_routine_create_controller.dart';

class InspectionRoutineCreateView
    extends GetView<InspectionRoutineCreateController> {
  InspectionRoutineCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(title: 'Buat Inspeksi Rutin'),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[...form(), ...imageList(), sendBtn()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> form() {
    return [
      AppTextField.basicTextField(
        controller: controller.unitC.value,
        label: 'Unit',
        readOnly: true,
        hintText: 'Unit',
        onChanged: (v) {
          controller.validateForm();
          controller.update();
        },
      ),
      SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            flex: 6,
            child: AppTextField.basicTextField(
              readOnly: controller.isViewMode.value,
              // required: true,
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
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: AppTextField.basicTextField(
              readOnly: controller.isViewMode.value,
              controller: controller.timeC.value,
              label: 'Jam',
              hintText: 'hh:mm',
              onTap: () async {
                await controller.pickTime();
                FocusManager.instance.primaryFocus?.unfocus();
                controller.validateForm();
              },
              onChanged: (v) {
                controller.validateForm();
                controller.update();
              },
              prefixIconConstraints: BoxConstraints(maxHeight: 18),
              prefixIcon: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Image.asset(
                    Assets.iconsIcTime,
                    color: AppColor.neutralLightDarkest,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 12),
      AppDropdown.normalDropdown(
        label: 'Kategori',
        readOnly: controller.isViewMode.value,
        hintText: 'Pilih Kategori',
        selectedItem: controller.selectedCategory.value,
        onChanged: (v) {
          controller.selectedCategory.value = v;
          controller.validateForm();
          FocusManager.instance.primaryFocus?.unfocus();
          controller.update();
        },
        list: List.generate(controller.categoryList.length, (i) {
          final item = controller.categoryList[i];
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: AppTextStyle.bodyM.copyWith(
                color: AppColor.neutralDarkMedium,
              ),
            ),
          );
        }),
      ),
      SizedBox(height: 12),
      AppTextField.basicTextField(
        readOnly: controller.isViewMode.value,
        controller: controller.riskC.value,
        label: 'Resiko',
        hintText: 'Resiko',
        onChanged: (v) {
          controller.validateForm();
          controller.update();
        },
      ),
      SizedBox(height: 12),
      AppTextField.basicTextField(
        readOnly: controller.isViewMode.value,
        controller: controller.eventLocationC.value,
        label: 'Lokasi kejadian',
        hintText: 'Lokasi kejadian',
        onChanged: (v) {
          controller.validateForm();
          controller.update();
        },
        maxLines: 4,
      ),
      SizedBox(height: 12),
      AppTextField.basicTextField(
        readOnly: controller.isViewMode.value,
        controller: controller.eventChronologyC.value,
        label: 'Kronologi kejadian',
        hintText: 'Kronologi kejadian',
        onChanged: (v) {
          controller.validateForm();
          controller.update();
        },
        maxLines: 4,
      ),
      SizedBox(height: 12),
      Text(
        'Dilakukan tindakan?',
        style: AppTextStyle.actionL.copyWith(
          color: AppColor.neutralDarkDarkest,
        ),
      ),
      SizedBox(height: 6),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 15),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: controller.actionTakenYes.value,
                      onChanged: (value) {
                        controller.actionTakenYes.value = value ?? false;
                        controller.actionTakenNo.value = !(value ?? false);
                      },
                      activeColor: AppColor.highlightDarkest,
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Ya',
                      style: AppTextStyle.bodyM.copyWith(
                        color: AppColor.neutralDarkDarkest,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: controller.actionTakenNo.value,
                      onChanged: (value) {
                        controller.actionTakenNo.value = value ?? false;
                        controller.actionTakenYes.value = !(value ?? false);
                      },
                      activeColor: AppColor.highlightDarkest,
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Tidak',
                      style: AppTextStyle.bodyM.copyWith(
                        color: AppColor.neutralDarkDarkest,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 12),
      AppTextField.basicTextField(
        readOnly: controller.isViewMode.value,
        controller: controller.reasonC.value,
        label: 'Alasan',
        hintText: 'Alasan',
        onChanged: (v) {
          controller.validateForm();
          controller.update();
        },
        maxLines: 4,
      ),
      SizedBox(height: 12),
      AppTextField.basicTextField(
        readOnly: controller.isViewMode.value,
        controller: controller.actionDetailC.value,
        label: 'Rincian tindakan',
        hintText: 'Rincian tindakan',
        onChanged: (v) {
          controller.validateForm();
          controller.update();
        },
        maxLines: 4,
      ),
      SizedBox(height: 12),
      AppTextField.basicTextField(
        readOnly: controller.isViewMode.value,
        controller: controller.givenRecommendationC.value,
        label: 'Saran diberikan',
        hintText: 'Saran diberikan',
        onChanged: (v) {
          controller.validateForm();
          controller.update();
        },
        maxLines: 4,
      ),
    ];
  }

  Widget addImageBtn() {
    if (controller.isViewMode.value) return SizedBox();
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

  List<Widget> imageList() {
    if (controller.isViewMode.value) return [SizedBox()];
    return [
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
            controller.pictureList.isEmpty
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
                      return InkWell(
                        onTap: () async {
                          await Get.toNamed(
                            AppRoute.IMAGE_PREVIEW,
                            arguments: item.path,
                          );
                        },
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(color: Colors.white),
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
    ];
  }

  Widget sendBtn() {
    if (controller.isViewMode.value) return SizedBox(height: 24);
    return Padding(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      child: AppButton.basicButton(
        // enable: controller.isValidated.value,
        enable: true,
        onTap: () async {
          if (!controller.loading.value)
            await controller.sendInspectionRoutine();
        },
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
        child:
            controller.loading.value
                ? Transform.scale(
                  scale: 0.5,
                  child: SizedBox(
                    width: 16,
                    height: 6,
                    child: FittedBox(
                      child: CircularProgressIndicator(color: Colors.white),
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
    );
  }
}
