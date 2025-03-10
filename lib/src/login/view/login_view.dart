import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/login/controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                Assets.imagesImgLogin,
                width: double.infinity,
                height: Get.size.height * .4,
                fit: BoxFit.cover,
              ),
              body(),
            ],
          ),
        ),
      ),
    );
  }

  body() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset(
              Assets.imagesImgMkp,
              width: 78,
              height: 32,
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'K3L Corporate',
              style: AppTextStyle.h1.copyWith(
                color: AppColor.neutralDarkLight,
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: formAndButton(),
          ),
        ],
      ),
    );
  }

  formAndButton() {
    return Obx(
      () {
        bool pwVisible = controller.passwordVisible.value;
        bool isLoading = controller.loading.value;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              AppTextField.loginTextField(
                controller: controller.nameC,
                hintText: 'Nama pengguna',
                onChanged: (v) {
                  controller.checkLoginBtnStatus();
                  controller.update();
                },
              ),
              SizedBox(height: 16),
              AppTextField.loginTextField(
                controller: controller.passwordC,
                hintText: 'Kata sandi',
                isPassword: !pwVisible,
                suffixIconConstraints: BoxConstraints(maxHeight: 18),
                onChanged: (v) {
                  controller.checkLoginBtnStatus();
                  controller.update();
                },
                suffixIcon: GestureDetector(
                  onTap: () async {
                    controller.passwordVisible.value = !pwVisible;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Image.asset(
                      pwVisible
                          ? Assets.iconsIcPassVisible
                          : Assets.iconsIcPassNonVisible,
                      color: pwVisible
                          ? AppColor.highlightDarkest
                          : AppColor.neutralDarkLightest,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              AppButton.basicButton(
                width: double.infinity,
                enable: controller.enableLoginBtn.value,
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
                child: isLoading
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
                        'Masuk',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.actionL.copyWith(
                          color: AppColor.neutralLightLightest,
                        ),
                      ),
              ),
              SizedBox(height: 30),
              copyright(),
            ],
          ),
        );
      },
    );
  }

  copyright() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Divider(
            thickness: 0.5,
            color: AppColor.neutralLightDark,
          ),
          SizedBox(height: 15),
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
