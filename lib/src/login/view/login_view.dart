import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/login/controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutralLightLightest,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                Assets.imagesImgLogin,
                width: double.infinity,
                height: Get.size.height * 0.4,
                fit: BoxFit.cover,
              ),
              _buildLoginCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 24),
          _buildTitle(),
          const SizedBox(height: 24),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(Assets.imagesImgMkp2, width: 125, height: 56);
  }

  Widget _buildTitle() {
    return Text(
      'Silahkan Masuk',
      style: AppTextStyle.h2.copyWith(color: AppColor.neutralDarkLight),
    );
  }

  Widget _buildLoginForm() {
    return Obx(() {
      final pwVisible = controller.passwordVisible.value;
      final isLoading = controller.loading.value;

      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            AppTextField.loginTextField(
              controller: controller.nidC,
              hintText: 'NID',
              onChanged: (_) {
                controller.checkLoginBtnStatus();
              },
            ),
            const SizedBox(height: 16),
            AppTextField.loginTextField(
              controller: controller.passwordC,
              hintText: 'Kata sandi',
              isPassword: !pwVisible,
              suffixIconConstraints: const BoxConstraints(maxHeight: 18),
              onChanged: (_) {
                controller.checkLoginBtnStatus();
              },
              suffixIcon: _buildPasswordToggleIcon(pwVisible),
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: () async {
                Get.toNamed(AppRoute.OTP);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Lupa kata sandi',
                  textAlign: TextAlign.right,
                  style: AppTextStyle.bodyS.copyWith(
                    fontWeight: FontWeight.normal,
                    color: AppColor.highlightDarkest,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildLoginButton(isLoading),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum terdaftar? ',
                  style: AppTextStyle.bodyS.copyWith(
                    fontWeight: FontWeight.normal,
                    color: AppColor.neutralDarkLight,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.toNamed(AppRoute.REGISTER);
                  },
                  child: Text(
                    'Registrasi',
                    style: AppTextStyle.bodyS.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColor.highlightDarkest,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildCopyright(),
          ],
        ),
      );
    });
  }

  Widget _buildPasswordToggleIcon(bool isVisible) {
    return GestureDetector(
      onTap: () {
        controller.passwordVisible.value = !isVisible;
      },
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

  Widget _buildLoginButton(bool isLoading) {
    return AppButton.basicButton(
      width: double.infinity,
      enable: controller.enableLoginBtn.value,
      loading: isLoading,
      onTap: () async {
        if (!isLoading) {
          FocusManager.instance.primaryFocus?.unfocus();
          await controller.login();
        }
      },
      color: AppColor.highlightDarkest,
      height: 48,
      radius: 30,
      padding: EdgeInsets.fromLTRB(16, isLoading ? 0 : 14, 16, 0),
      child: Text(
        'Masuk',
        textAlign: TextAlign.center,
        style: AppTextStyle.actionL.copyWith(
          color: AppColor.neutralLightLightest,
        ),
      ),
    );
  }

  Widget _buildCopyright() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          const Divider(thickness: 0.5, color: AppColor.neutralLightDark),
          const SizedBox(height: 15),
          Text(
            'PT Mitra Karya Prima',
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkLight,
            ),
          ),
        ],
      ),
    );
  }
}
