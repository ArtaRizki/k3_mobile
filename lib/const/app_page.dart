import 'package:get/get.dart';
import 'package:k3_mobile/src/home/view/home_binding.dart';
import 'package:k3_mobile/src/home/view/home_view.dart';
import 'package:k3_mobile/src/login/binding/login_binding.dart';
import 'package:k3_mobile/src/login/view/login_view.dart';

part 'app_route.dart';

class AppPage {
  AppPage._();
  static const INITIAL = AppRoute.LOGIN;

  static final Routes = [
    GetPage(
      name: _Path.HOME,
      page: () => HomeView(title: 'a'),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Path.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
