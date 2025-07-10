import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/page/image_preview/model/address_model.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:location/location.dart' as loc;

class ImagePreviewController extends GetxController {
  loc.Location location = loc.Location();
  var loading = false.obs;
  Uri path = Uri();
  ImageProvider? img;
  
  // Add these variables to handle different image types
  var isMemoryImage = false.obs;
  Uint8List? imageBytes;
  
  var addressData = AddressModel().obs;
  var currentPosition = (null as LatLng?).obs;

  // Adding the date and time variable
  var currentDateTime = (null as String?).obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == null || (Get.arguments[2] as String).isEmpty) {
      Get.back();
      return;
    }

    String argument = Get.arguments[2] as String;
    
    // Check for base64 image first
    if (isBase64Image(argument)) {
      try {
        String cleanBase64 = argument.contains(',') 
            ? argument.split(',').last 
            : argument;
        imageBytes = base64Decode(cleanBase64);
        img = MemoryImage(imageBytes!);
        isMemoryImage.value = true;
      } catch (e) {
        Utils.showToast("Error: Invalid base64 image!");
        Get.back();
        return;
      }
    } else if (isFilePath(argument)) {
      img = FileImage(File(argument));
      isMemoryImage.value = false;
    } else if (isUrl(argument)) {
      img = NetworkImage(argument);
      isMemoryImage.value = false;
    } else {
      Utils.showToast("Error: Invalid image path!");
      Get.back();
      return;
    }

    init();
  }

  void init() async {
    log("INIT");
    log("ARGUMENTS 0: ${Get.arguments[0]}");
    log("ARGUMENTS 1: ${Get.arguments[2]}");
    loading.value = true;
    Utils.showLoading();
    if (Get.arguments[0] != null) {
      final latLng = (Get.arguments[0] as String).split(',');
      final lat = double.tryParse(latLng[1]) ?? 0;
      final lng = double.tryParse(latLng[0]) ?? 0;
      currentPosition.value = LatLng(lat, lng);
      await getAddress(lat, lng);
    }
    path = Uri.parse(Get.arguments[1] as String);
    // await getLocation();

    // Store the current date and time
    if (Get.arguments[1] != null) {
      final datee = DateFormat('dd/MM/yyyy HM:mm').parse(Get.arguments[1]);
      currentDateTime.value = DateFormat(
        'dd/MM/yyyy HH.mm',
      ).format(datee); // Or format it as needed
    }

    // Skip file/URL validation for memory images
    if (!isMemoryImage.value && !isFile() && !isUrl(path.toString())) {
      // Utils.showToast("Error: Image does not exist!");
      // Get.back();
      Utils.dismissLoading();
      loading.value = false;
      // return;
    }

    Utils.dismissLoading();
    loading.value = false;
  }

  // Add method to check if string is base64 image
  bool isBase64Image(String str) {
    if (str.isEmpty) return false;
    
    // Check for data URL format
    if (str.startsWith('data:image/')) {
      return true;
    }
    
    // Check if it's a valid base64 string
    try {
      // Remove any whitespace
      String cleanStr = str.replaceAll(RegExp(r'\s+'), '');
      
      // Check if it's a valid base64 string
      if (cleanStr.length % 4 != 0) return false;
      
      // Try to decode
      base64Decode(cleanStr);
      
      // Additional check: base64 images are usually quite long
      return cleanStr.length > 100;
    } catch (e) {
      return false;
    }
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

  // Add method to get the appropriate widget for display
  Widget getImageWidget({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (isMemoryImage.value && imageBytes != null) {
      return Image.memory(
        imageBytes!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    } else if (img != null) {
      return Image(
        image: img!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }
  }

  /// Shows GPS enable dialog to user
  Future<void> _showGpsDialog() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Enable GPS'),
        content: const Text('Please enable GPS to use this feature.'),
        actions: [
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings();
              Get.back();
            },
            child: const Text('Settings'),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  /// Gets current location with proper permission handling
  Future<void> getLocation() async {
    try {
      // Check and request location service
      final serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        await _showGpsDialog();
        return;
      }

      // Handle location permissions
      await _handleLocationPermissions();

      // Get current position
      final position = await _getCurrentPosition();

      if (position != null) {
        currentPosition.value = LatLng(position.latitude, position.longitude);
        await getAddress(position.latitude, position.longitude);
      }
    } catch (e) {
      // Handle errors appropriately
      debugPrint('Error getting location: $e');
      rethrow;
    }
  }

  /// Handles location permission requests and checks
  Future<void> _handleLocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  /// Gets current position with fallback to last known position
  Future<Position?> _getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          forceLocationManager: true,
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 5),
        ),
      ).timeout(const Duration(seconds: 30));
    } catch (e) {
      debugPrint('Failed to get current position, trying last known: $e');
      return await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true,
      );
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