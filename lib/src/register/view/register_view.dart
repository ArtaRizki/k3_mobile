import 'package:flutter/material.dart';
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
import 'package:k3_mobile/src/register/controller/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppAppbar.basicAppbar(title: 'Registrasi'),
        body: SafeArea(
          child: Container(
            color: AppColor.neutralLightLightest,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  ..._buildFormFields(),
                  _buildSubmitButton(),
                  _buildAlreadyHaveAccount(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildFormFields() {
    return [
      _buildTextField(
        controller: controller.nidC.value,
        label: 'NID',
        keyboardType: TextInputType.number,
      ),
      _buildTextField(
        controller: controller.nameC.value,
        label: 'Nama',
        keyboardType: TextInputType.name,
      ),
      _buildTextField(
        controller: controller.occupationC.value,
        label: 'Jabatan',
        keyboardType: TextInputType.name,
      ),
      _buildAgencyField(),
      _buildTextField(
        controller: controller.emailC.value,
        label: 'Email',
        keyboardType: TextInputType.emailAddress,
      ),
      _buildPasswordField(
        controller: controller.passwordC.value,
        label: 'Kata sandi',
        isVisible: controller.passwordVisible.value,
        onToggle: () {
          controller.passwordVisible.value = !controller.passwordVisible.value;
        },
      ),
      _buildPasswordField(
        controller: controller.confirmationPasswordC.value,
        label: 'Konfirmasi Kata sandi',
        isVisible: controller.confirmationNewPassVisible.value,
        onToggle: () {
          controller.confirmationNewPassVisible.value =
              !controller.confirmationNewPassVisible.value;
        },
      ),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField.basicTextField(
        required: true,
        controller: controller,
        label: label,
        hintText: label,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: (_) {
          this.controller.validateForm();
          this.controller.update();
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField.basicTextField(
        controller: controller,
        label: label,
        hintText: label,
        isPassword: !isVisible,
        maxLines: 1,
        suffixIconConstraints: const BoxConstraints(maxHeight: 18),
        onChanged: (_) {
          this.controller.validateForm();
          this.controller.update();
        },
        suffixIcon: _buildPasswordToggleIcon(isVisible, onToggle),
      ),
    );
  }

  Widget _buildAgencyField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField.basicTextField(
        readOnly: true,
        required: true,
        controller: controller.agencyC.value,
        label: 'Instansi',
        hintText: 'Pilih',
        suffixIconConstraints: const BoxConstraints(maxHeight: 18),
        onTap: () async {
          controller.searchAgencyC.value.clear();
          AppDialog.showBasicDialog(
            title: 'Pilih Instansi',
            content: selectAgencyDialog(),
          );
        },
        onChanged: (v) {
          controller.validateForm();
          controller.update();
        },
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(
            Assets.iconsIcSearch,
            color: AppColor.neutralLightDarkest,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordToggleIcon(bool isVisible, VoidCallback onTap) {
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

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: AppButton.basicButton(
        enable: controller.isValidated.value,
        loading: controller.loading.value,
        onTap: controller.sendRegister,
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
          'Register',
          textAlign: TextAlign.center,
          style: AppTextStyle.actionL.copyWith(
            color: AppColor.neutralLightLightest,
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadyHaveAccount() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sudah punya akun? ',
            style: AppTextStyle.bodyS.copyWith(
              fontWeight: FontWeight.normal,
              color: AppColor.neutralDarkLight,
            ),
          ),
          InkWell(
            onTap: () => Get.offAllNamed(AppRoute.LOGIN),
            child: Text(
              'Masuk',
              style: AppTextStyle.bodyS.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColor.highlightDarkest,
              ),
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

  Widget selectAgencyDialog() {
    return GetBuilder<RegisterController>(
      builder: (controller) {
        final query = controller.searchAgencyC.value.text.isNotEmpty;
        return SizedBox(
          width: Get.size.width * .8,
          height: Get.size.height * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField.loginTextField(
                controller: controller.searchAgencyC.value,
                hintText: 'Cari Instansi',
                suffixIconConstraints: BoxConstraints(
                  maxHeight: query ? 23 : 18,
                ),
                onChanged: (v) {
                  controller.update();
                },
                suffixIcon: InkWell(
                  onTap: query ? controller.clearSearchAgencyField : null,
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
              if (controller.filteredAgencySelectList.isEmpty) ...[
                EmptyList.textEmptyList(
                  minHeight: Get.size.height * .25,
                  onRefresh: () async {
                    controller.update();
                  },
                ),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.filteredAgencySelectList.length,
                    itemBuilder: (c, i) {
                      final item = controller.filteredAgencySelectList[i];
                      return AppCard.listCard(
                        onTap: () async {
                          controller.agencyC.value.text = item?.name ?? '';
                          controller.selectedAgency.value = item;
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
                            titleSubtitleSelect('Nama', item?.name ?? '', 3),
                            SizedBox(width: 12),
                            titleSubtitleSelect('Code', item?.code ?? '', 3),
                            SizedBox(width: 12),
                            titleSubtitleSelect(
                              'Alamat',
                              item?.address ?? '',
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
}
