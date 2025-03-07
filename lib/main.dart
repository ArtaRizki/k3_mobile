import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/src/home/view/home_view.dart';
import 'package:k3_mobile/src/main_home/view/main_home_view.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: AppColor.highlightDarkest,
    // statusBarColor: AppColor.highlightDarkest,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  await WidgetsFlutterBinding.ensureInitialized();

  await requestPermission(Permission.storage);
  await requestPermission(Permission.accessMediaLocation);
  await requestPermission(Permission.manageExternalStorage);
  await requestPermission(Permission.photos);
  runApp(const MyApp());
}

Future<bool> requestPermission(Permission permission) async {
  PermissionStatus status = await permission.request();
  return [PermissionStatus.granted, PermissionStatus.limited].contains(status);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'K3 Mobile',
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
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
        );
      },
    );
  }
}
