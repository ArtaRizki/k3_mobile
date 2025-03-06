import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/splash/controller/splash_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: SizedBox(),
              // child: Image.asset(Assets.imagesImgLogoSigap),
            )
          ],
        ),
      ),
    );
  }
}
