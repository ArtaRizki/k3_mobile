import 'package:get/get.dart';
import 'package:k3_mobile/component/page/image_preview/binding/image_preview_binding.dart';
import 'package:k3_mobile/component/page/image_preview/view/image_preview_view.dart';
import 'package:k3_mobile/src/apd/apd_reception/binding/apd_reception_binding.dart';
import 'package:k3_mobile/src/apd/apd_reception/binding/apd_reception_create_binding.dart';
import 'package:k3_mobile/src/apd/apd_reception/binding/apd_reception_view_binding.dart';
import 'package:k3_mobile/src/apd/apd_reception/view/apd_reception_view_view.dart';
import 'package:k3_mobile/src/apd/apd_reception/view/apd_reception_create_view.dart';
import 'package:k3_mobile/src/apd/apd_reception/view/apd_reception_view.dart';
import 'package:k3_mobile/src/apd/apd_request/binding/apd_request_binding.dart';
import 'package:k3_mobile/src/apd/apd_request/binding/apd_request_create_binding.dart';
import 'package:k3_mobile/src/apd/apd_request/binding/apd_request_view_binding.dart';
import 'package:k3_mobile/src/apd/apd_request/view/apd_request_create_view.dart';
import 'package:k3_mobile/src/apd/apd_request/view/apd_request_view.dart';
import 'package:k3_mobile/src/apd/apd_request/view/apd_request_view_view.dart';
import 'package:k3_mobile/src/apd/apd_return/binding/apd_return_binding.dart';
import 'package:k3_mobile/src/apd/apd_return/binding/apd_return_create_binding.dart';
import 'package:k3_mobile/src/apd/apd_return/binding/apd_return_view_binding.dart';
import 'package:k3_mobile/src/apd/apd_return/view/apd_return_create_view.dart';
import 'package:k3_mobile/src/apd/apd_return/view/apd_return_view.dart';
import 'package:k3_mobile/src/apd/apd_return/view/apd_return_view_view.dart';
import 'package:k3_mobile/src/guide/binding/guide_binding.dart';
import 'package:k3_mobile/src/guide/view/guide_preview_view.dart';
import 'package:k3_mobile/src/guide/view/guide_view.dart';
import 'package:k3_mobile/src/home/binding/home_binding.dart';
import 'package:k3_mobile/src/home/view/home_view.dart';
import 'package:k3_mobile/src/inspection/inspection_project/binding/inspection_project_binding.dart';
import 'package:k3_mobile/src/inspection/inspection_project/binding/inspection_project_create_binding.dart';
import 'package:k3_mobile/src/inspection/inspection_project/view/inspection_project_create_view.dart';
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
    GetPage(
      name: _Path.INSPECTION_PROJECT_CREATE,
      page: () => InspectionProjectCreateView(),
      binding: InspectionProjectCreateBinding(),
    ),
    GetPage(
      name: _Path.APD_REQUEST,
      page: () => ApdRequestView(),
      binding: ApdRequestBinding(),
    ),
    GetPage(
      name: _Path.APD_REQUEST_CREATE,
      page: () => ApdRequestCreateView(),
      binding: ApdRequestCreateBinding(),
    ),
    GetPage(
      name: _Path.APD_REQUEST_VIEW,
      page: () => ApdRequestViewView(),
      binding: ApdRequestViewBinding(),
    ),
    GetPage(
      name: _Path.APD_RECEPTION,
      page: () => ApdReceptionView(),
      binding: ApdReceptionBinding(),
    ),
    GetPage(
      name: _Path.APD_RECEPTION_CREATE,
      page: () => ApdReceptionCreateView(),
      binding: ApdReceptionCreateBinding(),
    ),
    GetPage(
      name: _Path.APD_RECEPTION_VIEW,
      page: () => ApdReceptionViewView(),
      binding: ApdReceptionViewBinding(),
    ),
    GetPage(
      name: _Path.APD_RETURN,
      page: () => ApdReturnView(),
      binding: ApdReturnBinding(),
    ),
    GetPage(
      name: _Path.APD_RETURN_CREATE,
      page: () => ApdReturnCreateView(),
      binding: ApdReturnCreateBinding(),
    ),
    GetPage(
      name: _Path.APD_RETURN_VIEW,
      page: () => ApdReturnViewView(),
      binding: ApdReturnViewBinding(),
    ),
    GetPage(
      name: _Path.IMAGE_PREVIEW,
      page: () => ImagePreviewView(),
      binding: ImagePreviewBinding(),
    ),
  ];
}
