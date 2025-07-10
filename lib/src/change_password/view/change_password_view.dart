// Refactored version of ChangePasswordView
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/change_password/controller/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppAppbar.basicAppbar(
          title:
              controller.forgotMode.value
                  ? 'Kata Sandi Baru'
                  : 'Ubah Kata Sandi',
        ),
        body: SafeArea(
          child: Container(
            color: AppColor.neutralLightLightest,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [..._buildFormFields(), _buildSubmitButton()],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildFormFields() {
    return [
      SizedBox(height: 40),
      if (!controller.forgotMode.value)
        _textField(
          controller.currentPassC.value,
          'Kata sandi saat ini',
          isVisible: controller.currentPassVisible.value,
          onTap: () async {
            controller.currentPassVisible.value =
                !controller.currentPassVisible.value;
          },
        ),
      _textField(
        controller.newPassC.value,
        'Kata sandi baru',
        isVisible: controller.newPassVisible.value,
        onTap: () async {
          controller.newPassVisible.value = !controller.newPassVisible.value;
        },
      ),
      _textField(
        controller.confirmNewPassC.value,
        'Konfirmasi Kata sandi baru',
        isVisible: controller.confirmNewPassVisible.value,
        onTap: () async {
          controller.confirmNewPassVisible.value =
              !controller.confirmNewPassVisible.value;
        },
      ),
    ];
  }

  Widget _buildPasswordToggleIcon(bool isVisible, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Image.asset(
          isVisible ? Assets.iconsIcPassVisible : Assets.iconsIcPassNonVisible,
          color:
              isVisible
                  ? AppColor.highlightDarkest
                  : AppColor.neutralDarkLightest,
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController textC,
    String label, {
    bool isVisible = false,
    int maxLines = 1,
    void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField.basicTextField(
        controller: textC,
        label: label,
        hintText: label,
        isPassword: !isVisible,
        suffixIconConstraints: const BoxConstraints(maxHeight: 18),
        onChanged: (_) {
          this.controller.validateForm();
          this.controller.update();
        },
        suffixIcon: _buildPasswordToggleIcon(isVisible, onTap),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 36),
      child: AppButton.basicButton(
        enable: controller.isValidated.value,
        loading: controller.loading.value,
        onTap: controller.loading.value ? null : controller.sendChangePassword,
        width: double.infinity,
        color: AppColor.highlightDarkest,
        height: 55,
        radius: 30,
        padding: EdgeInsets.fromLTRB(
          16,
          controller.loading.value ? 0 : 16,
          16,
          0,
        ),
        child: Text(
          'Simpan',
          textAlign: TextAlign.center,
          style: AppTextStyle.actionL.copyWith(
            color: AppColor.neutralLightLightest,
          ),
        ),
      ),
    );
  }
}
