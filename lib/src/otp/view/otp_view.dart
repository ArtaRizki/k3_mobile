import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/src/otp/controller/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  OtpView({Key? key}) : super(key: key);

  Widget _buildEmailField() {
    return AppTextField.basicTextField(
      controller: controller.emailC.value,
      label: '',
      hintText: 'Masukkan email Anda',
      onChanged: (_) {
        this.controller.validateForm();
        this.controller.update();
      },
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: AppTextStyle.bodyM.copyWith(color: AppColor.highlightDarkest),
        onChanged: (val) => controller.onOtpChanged(val, index, Get.context!),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              controller.isOtpExpired.value
                  ? AppColor.neutralLightLight
                  : AppColor.highlightLightest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                controller.isOtpExpired.value
                    ? Colors.red.shade300
                    : AppColor.highlightDarkest,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.isOtpExpired.value ? Icons.error : Icons.timer,
              size: 16,
              color:
                  controller.isOtpExpired.value
                      ? Colors.red
                      : AppColor.highlightDarkest,
            ),
            SizedBox(width: 8),
            Text(
              controller.isOtpExpired.value
                  ? "Kode OTP telah kedaluwarsa"
                  : "Kode berlaku selama: ${controller.getFormattedTime()}",
              style: AppTextStyle.bodyS.copyWith(
                color:
                    controller.isOtpExpired.value
                        ? Colors.red
                        : AppColor.highlightDarkest,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Obx(
      () => AppButton.basicButton(
        width: double.infinity,
        enable:
            controller.otpDigits.every(
              (e) => e.trim() != '' && e.trim() != '-',
            ) &&
            !controller.isOtpExpired.value,
        loading: controller.loading.value,
        onTap: () async {
          if (!controller.loading.value && !controller.isOtpExpired.value) {
            FocusManager.instance.primaryFocus?.unfocus();
            await controller.verifyOtp();
          }
        },
        color:
            controller.isOtpExpired.value
                ? AppColor.neutralDarkLight
                : AppColor.highlightDarkest,
        height: 48,
        radius: 30,
        padding: EdgeInsets.fromLTRB(
          16,
          controller.loading.value ? 0 : 14,
          16,
          0,
        ),
        child: Text(
          controller.isOtpExpired.value ? 'Kirim Ulang OTP' : 'Verifikasi',
          textAlign: TextAlign.center,
          style: AppTextStyle.actionL.copyWith(
            color: AppColor.neutralLightLightest,
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Obx(
      () => AppButton.basicButton(
        width: double.infinity,
        enable: controller.isValidated.value,
        // loading: controller.loading.value,
        onTap: () async {
          // if (!controller.loading.value) {
          FocusManager.instance.primaryFocus?.unfocus();
          await controller.sendOtpToEmail();
          // }
        },
        color: AppColor.highlightDarkest,
        height: 48,
        radius: 30,
        padding: EdgeInsets.fromLTRB(
          16,
          controller.loading.value ? 0 : 14,
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

  Widget _buildResendSection() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Belum menerima email ? ',
            style: AppTextStyle.bodyS.copyWith(
              fontWeight: FontWeight.normal,
              color: AppColor.neutralDarkLight,
            ),
          ),
          InkWell(
            onTap:
                controller.isOtpExpired.value ||
                        controller.remainingTime.value <= 0
                    ? () async {
                      if (!controller.loading.value) {
                        await controller.sendOtpToEmail(isResend: true);
                      }
                    }
                    : null,
            child: Text(
              'Kirim ulang',
              style: AppTextStyle.bodyS.copyWith(
                fontWeight: FontWeight.w800,
                color:
                    controller.isOtpExpired.value ||
                            controller.remainingTime.value <= 0
                        ? AppColor.highlightDarkest
                        : AppColor.neutralDarkLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppAppbar.basicAppbar(title: 'Lupa Kata Sandi'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                Text(
                  controller.isEmailInputed.value
                      ? "Masukkan kode OTP"
                      : "Masukkan email",
                  style: AppTextStyle.actionL.copyWith(
                    color: AppColor.neutralDarkDarkest,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  controller.isEmailInputed.value
                      ? "Kode telah dikirim ke alamat email berikut\n${controller.emailC.value.text}"
                      : "Masukkan email Anda agar mendapatkan OTP untuk merubah password",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyS.copyWith(
                    color: AppColor.neutralDarkLight,
                  ),
                ),
                SizedBox(height: 20),
                if (controller.isEmailInputed.value) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) => _buildOtpBox(index)),
                  ),
                  // Timer display
                  _buildTimerDisplay(),
                ] else ...[
                  _buildEmailField(),
                ],
                SizedBox(height: 16),
                if (controller.isEmailInputed.value) _buildResendSection(),
                SizedBox(height: 36),
                if (controller.isEmailInputed.value) ...[
                  AppButton.basicButton(
                    width: double.infinity,
                    enable:
                        controller.otpDigits.every(
                          (e) => e.trim() != '' && e.trim() != '-',
                        ) &&
                        !controller.isOtpExpired.value,
                    loading: controller.loading.value,
                    onTap: () async {
                      if (!controller.loading.value &&
                          !controller.isOtpExpired.value) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await controller.verifyOtp();
                      }
                    },
                    color:
                        controller.isOtpExpired.value
                            ? AppColor.neutralDarkLight
                            : AppColor.highlightDarkest,
                    height: 48,
                    radius: 30,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      controller.loading.value ? 0 : 14,
                      16,
                      0,
                    ),
                    child: Text(
                      controller.isOtpExpired.value
                          ? 'Kirim Ulang OTP'
                          : 'Verifikasi',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.actionL.copyWith(
                        color: AppColor.neutralLightLightest,
                      ),
                    ),
                  ),
                ] else ...[
                  _buildSendButton(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
