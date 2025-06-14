part of 'app_page.dart';

abstract class AppRoute {
  AppRoute._();
  static const SPLASH = _Path.SPLASH;
  static const MAIN_HOME = _Path.MAIN_HOME;
  static const HOME = _Path.HOME;
  static const LOGIN = _Path.LOGIN;
  static const NOTIFICATION = _Path.NOTIFICATION;
  static const PROFILE = _Path.PROFILE;
  static const GUIDE = _Path.GUIDE;
  static const GUIDE_PREVIEW = _Path.GUIDE_PREVIEW;
  static const INSPECTION_ROUTINE = _Path.INSPECTION_ROUTINE;
  static const INSPECTION_ROUTINE_CREATE = _Path.INSPECTION_ROUTINE_CREATE;
  static const INSPECTION_PROJECT = _Path.INSPECTION_PROJECT;
  static const INSPECTION_PROJECT_CREATE = _Path.INSPECTION_PROJECT_CREATE;
  static const APD_REQUEST = _Path.APD_REQUEST;
  static const APD_REQUEST_CREATE = _Path.APD_REQUEST_CREATE;
  static const APD_REQUEST_VIEW = _Path.APD_REQUEST_VIEW;
  static const APD_RECEPTION = _Path.APD_RECEPTION;
  static const APD_RECEPTION_CREATE = _Path.APD_RECEPTION_CREATE;
  static const APD_RECEPTION_VIEW = _Path.APD_RECEPTION_VIEW;
  static const APD_RETURN = _Path.APD_RETURN;
  static const APD_RETURN_CREATE = _Path.APD_RETURN_CREATE;
  static const APD_RETURN_VIEW = _Path.APD_RETURN_VIEW;
  static const IMAGE_PREVIEW = _Path.IMAGE_PREVIEW;
}

abstract class _Path {
  _Path._();
  static const SPLASH = '/';
  static const MAIN_HOME = '/mainHome';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const NOTIFICATION = '/notification';
  static const PROFILE = '/profile';
  static const GUIDE = '/guide';
  static const GUIDE_PREVIEW = '/guidePreview';
  static const INSPECTION_ROUTINE = '/inspectionRoutine';
  static const INSPECTION_ROUTINE_CREATE = '/inspectionRoutineCreate';
  static const INSPECTION_PROJECT = '/inspectionProject';
  static const INSPECTION_PROJECT_CREATE = '/inspectionProjectCreate';
  static const APD_REQUEST = '/apdRequest';
  static const APD_REQUEST_CREATE = '/apdRequestCreate';
  static const APD_REQUEST_VIEW = '/apdRequestView';
  static const APD_RECEPTION = '/apdReception';
  static const APD_RECEPTION_CREATE = '/apdReceptionCreate';
  static const APD_RECEPTION_VIEW = '/apdReceptionView';
  static const APD_RETURN = '/apdReturn';
  static const APD_RETURN_CREATE = '/apdReturnCreate';
  static const APD_RETURN_VIEW = '/apdReturnView';
  static const IMAGE_PREVIEW = '/imagePreview';
}
