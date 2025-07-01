import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // systemNavigationBarColor: AppColor.highlightDarkest,
      // statusBarColor: AppColor.highlightDarkest,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await WidgetsFlutterBinding.ensureInitialized();

  // Request permissions based on Android version
  await requestPermissionsBasedOnAndroidVersion();
  
  runApp(const MyApp());
}

Future<void> requestPermissionsBasedOnAndroidVersion() async {
  if (!Platform.isAndroid) return;

  try {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13+ (API 33+)
      await _requestAndroid13Permissions();
    } else if (sdkInt >= 30) {
      // Android 11-12 (API 30-32)
      await _requestAndroid11Permissions();
    } else {
      // Android 10 and below (API 29 and below)
      await _requestLegacyPermissions();
    }
  } catch (e) {
    // Fallback to basic permissions if device info fails
    await requestPermission(Permission.storage);
  }
}

Future<void> _requestAndroid13Permissions() async {
  // For Android 13+, request granular media permissions
  final permissions = [
    Permission.photos,           // For images
    Permission.videos,          // For videos  
    Permission.audio,           // For audio files
    Permission.notification,    // For notifications
  ];
  
  for (final permission in permissions) {
    await requestPermission(permission);
  }
  
  // Only request MANAGE_EXTERNAL_STORAGE if absolutely necessary for your app
  // Most apps should avoid this permission on Android 13+
  // await requestPermission(Permission.manageExternalStorage);
}

Future<void> _requestAndroid11Permissions() async {
  // For Android 11-12
  final permissions = [
    Permission.storage,
    Permission.manageExternalStorage, // Needed for broad file access
    Permission.photos,
    Permission.notification,
  ];
  
  for (final permission in permissions) {
    await requestPermission(permission);
  }
}

Future<void> _requestLegacyPermissions() async {
  // For Android 10 and below
  final permissions = [
    Permission.storage,
    Permission.photos,
    Permission.notification,
  ];
  
  for (final permission in permissions) {
    await requestPermission(permission);
  }
}

Future<bool> requestPermission(Permission permission) async {
  try {
    PermissionStatus status = await permission.request();
    
    // Log permission status for debugging
    print('Permission ${permission.toString()}: ${status.toString()}');
    
    return [
      PermissionStatus.granted, 
      PermissionStatus.limited,
      PermissionStatus.provisional
    ].contains(status);
  } catch (e) {
    print('Error requesting permission ${permission.toString()}: $e');
    return false;
  }
}

// Optional: Check if specific permission is granted
Future<bool> isPermissionGranted(Permission permission) async {
  final status = await permission.status;
  return [
    PermissionStatus.granted,
    PermissionStatus.limited,
    PermissionStatus.provisional
  ].contains(status);
}

// Optional: Open app settings if permission is permanently denied
Future<void> openAppSettings() async {
  await openAppSettings();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MSafety',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Inter',
        dividerTheme: DividerThemeData(thickness: 1),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPage.INITIAL,
      getPages: AppPage.Routes,
      // home: MainHomeView(),
      builder: (context, child) {
        child = EasyLoading.init()(context, child);
        // log(MediaQuery.of(context).size.toString());
        return MediaQuery(
          child: child,
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
        );
      },
    );
  }
}