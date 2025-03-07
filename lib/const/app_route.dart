part of 'app_page.dart';

abstract class AppRoute {
  AppRoute._();
  static const MAIN_HOME = _Path.MAIN_HOME;
  static const HOME = _Path.HOME;
  static const LOGIN = _Path.LOGIN;
  static const NOTIFICATION = _Path.NOTIFICATION;
  static const PROFILE = _Path.PROFILE;
  static const GUIDE = _Path.GUIDE;
  static const GUIDE_PREVIEW = _Path.GUIDE_PREVIEW;
}

abstract class _Path {
  _Path._();
  static const MAIN_HOME = '/mainHome';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const NOTIFICATION = '/notification';
  static const PROFILE = '/profile';
  static const GUIDE = '/guide';
  static const GUIDE_PREVIEW = '/guidePreview';
}
