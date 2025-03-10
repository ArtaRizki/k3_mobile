import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/page/image_preview/model/address_model.dart';
import 'package:k3_mobile/component/utils.dart';

class ImagePreviewController extends GetxController {
  var loading = false.obs;
  Uri path = Uri();
  ImageProvider? img;
  var addressData = AddressModel().obs;
  var currentPosition = LatLng(0, 0).obs;

  // Adding the date and time variable
  String currentDateTime = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == null || (Get.arguments as String).isEmpty) {
      Get.back();
      return;
    }

    String argument = Get.arguments as String;
    if (isFilePath(argument)) {
      img = FileImage(File(argument));
    } else if (isUrl(argument)) {
      img = NetworkImage(argument);
    } else {
      Utils.showToast("Error: Invalid image path!");
      Get.back();
      return;
    }

    init();
  }

  void init() async {
    log("INIT");
    log("ARGUMENTS: ${Get.arguments}");
    loading.value = true;
    Utils.showLoading();

    path = Uri.parse(Get.arguments as String);
    await getLocation();

    // Store the current date and time
    currentDateTime = DateFormat('dd/MM/yyyy HH.mm')
        .format(DateTime.now()); // Or format it as needed

    if (!isFile() && !isUrl(path.toString())) {
      // Utils.showToast("Error: Image does not exist!");
      // Get.back();
      Utils.dismissLoading();
      loading.value = false;
      // return;
    }

    Utils.dismissLoading();
    loading.value = false;
  }

  bool isFilePath(String path) {
    return path.startsWith('file://') || File(path).existsSync();
  }

  bool isUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  bool isFile() {
    return path.isScheme('file');
  }

  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always) {
      await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    Position? pos;
    try {
      pos = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          forceLocationManager: true,
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 5),
        ),
      ).timeout(Duration(seconds: 30));
    } catch (e) {
      pos = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true);
    }

    if (pos != null) {
      currentPosition.value = LatLng(pos.latitude, pos.longitude);
      await getAddress(pos.latitude, pos.longitude);
    }
  }

  getAddress(double lat, double lon) async {
    var client = http.Client();
    try {
      String url =
          'https://nominatim.openstreetmap.org/reverse.php?lat=$lat&lon=$lon&zoom=17&format=jsonv2';
      if (kDebugMode) log("URL: $url");

      var response = await client.get(Uri.parse(url));
      addressData.value = AddressModel.fromJson(jsonDecode(response.body));
      if (kDebugMode) log("RESPONSE GET ADDRESS: ${response.body}");
    } finally {
      client.close();
    }
  }
}
