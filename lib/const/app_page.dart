import 'package:get/get.dart';
import 'package:k3_mobile/src/guide/binding/guide_binding.dart';
import 'package:k3_mobile/src/guide/view/guide_preview_view.dart';
import 'package:k3_mobile/src/guide/view/guide_view.dart';
import 'package:k3_mobile/src/home/binding/home_binding.dart';
import 'package:k3_mobile/src/home/view/home_view.dart';
import 'package:k3_mobile/src/inspection/inspection_project/binding/inspection_project_binding.dart';
import 'package:k3_mobile/src/inspection/inspection_project/view/inspection_project_view.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/binding/inspection_routine_binding.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/binding/inspection_routine_create_binding.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/view/inspection_routine_create_view.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/view/inspection_routine_view.dart';
import 'package:k3_mobile/src/main_home/binding/main_home_binding.dart';
import 'package:k3_mobile/src/main_home/view/main_home_view.dart';
import 'package:k3_mobile/src/login/binding/login_binding.dart';
import 'package:k3_mobile/src/login/view/login_view.dart';
import 'package:k3_mobile/src/notification/binding/notification_binding.dart';
import 'package:k3_mobile/src/notification/view/notification_view.dart';
import 'package:k3_mobile/src/profile/binding/profile_binding.dart';
import 'package:k3_mobile/src/profile/view/profile_view.dart';

part 'app_route.dart';

class AppPage {
  AppPage._();
  static const INITIAL = AppRoute.LOGIN;

  static final Routes = [
    GetPage(
      name: _Path.MAIN_HOME,
      page: () => MainHomeView(),
      binding: MainHomeBinding(),
    ),
    GetPage(
      name: _Path.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Path.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Path.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Path.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Path.GUIDE,
      page: () => GuideView(),
      binding: GuideBinding(),
    ),
    GetPage(
      name: _Path.GUIDE_PREVIEW,
      page: () => GuidePreviewView(),
      binding: GuideBinding(),
    ),
    GetPage(
      name: _Path.INSPECTION_ROUTINE,
      page: () => InspectionRoutineView(),
      binding: InspectionRoutineBinding(),
    ),
    GetPage(
      name: _Path.INSPECTION_ROUTINE_CREATE,
      page: () => InspectionRoutineCreateView(),
      binding: InspectionRoutineCreateBinding(),
    ),
    GetPage(
      name: _Path.INSPECTION_PROJECT,
      page: () => InspectionProjectView(),
      binding: InspectionProjectBinding(),
    ),
  ];
}
