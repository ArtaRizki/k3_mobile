import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_snackbar.dart';

class OtpController extends GetxController {
  var req = HttpRequestClient();
  var counter = 0.obs;
  var emailC = TextEditingController().obs;
  final otpDigits = List.generate(6, (_) => ''.obs);
  var isEmailInputed = false.obs;
  var loading = false.obs;
  var isValidated = false.obs;
  
  // Timer countdown variables
  var remainingTime = 0.obs; // dalam detik
  var isOtpExpired = false.obs;
  Timer? _timer;
  
  // Konstanta untuk durasi OTP (10 menit = 600 detik)
  static const int otpDurationInSeconds = 600;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startOtpTimer() {
    remainingTime.value = otpDurationInSeconds;
    isOtpExpired.value = false;
    
    _timer?.cancel(); // Cancel existing timer if any
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        isOtpExpired.value = true;
        timer.cancel();
        _onOtpExpired();
      }
    });
  }

  void _onOtpExpired() {
    Get.snackbar(
      "OTP Expired", 
      "Kode OTP telah kedaluwarsa. Silakan kirim ulang kode OTP.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void stopOtpTimer() {
    _timer?.cancel();
    remainingTime.value = 0;
  }

  String getFormattedTime() {
    int minutes = remainingTime.value ~/ 60;
    int seconds = remainingTime.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void onOtpChanged(String value, int index, BuildContext context) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
    otpDigits[index].value = value;
  }

  Future<void> verifyOtp() async {
    final otp = otpDigits.map((e) => e.value).join();
    if (otp.length < 6) {
      Get.snackbar("Error", "Kode OTP belum lengkap");
      return;
    }

    if (isOtpExpired.value) {
      Get.snackbar("Error", "Kode OTP telah kedaluwarsa. Silakan kirim ulang kode OTP.");
      return;
    }

    log("Verifikasi OTP: $otp");

    loading(true);
    final response = await req.post('/verify-otp', body: {'otp': otp});

    if (response.statusCode == 201 || response.statusCode == 200) {
      stopOtpTimer(); // Stop timer when OTP is successfully verified
      update();
      loading(false);
      Get.back();
      final map = jsonDecode(response.body);
      await Utils.showSuccess(msg: map["message"]);
      Get.offAllNamed(AppRoute.CHANGE_PASSWORD, arguments: 'forgot');
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      AppSnackbar.showSnackBar(Get.context!, message, true);
      loading(false);
      throw Exception(message);
    }
  }

  bool validate() {
    if (emailC.value.text.isEmpty) return false;
    return true;
  }

  validateForm() {
    isValidated.value = validate();
    log("IS VALIDATED : ${isValidated.value}");
    update();
  }

  Future<void> sendOtpToEmail({bool isResend = false}) async {
    if (isResend) counter.value = counter.value++;
    loading(true);
    final response = await req.post(
      '/send-otp-email',
      body: {'email': emailC.value.text},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      isEmailInputed.value = true;
      startOtpTimer(); // Start timer when OTP is sent
      update();
      loading(false);
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      AppSnackbar.showSnackBar(Get.context!, message, true);
      loading(false);
      throw Exception(message);
    }
  }
}