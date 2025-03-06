part of 'app_page.dart';

abstract class AppRoute {
  AppRoute._();
  static const MAIN_HOME = _Path.MAIN_HOME;
  static const HOME = _Path.HOME;
  static const LOGIN = _Path.LOGIN;
}

abstract class _Path {
  _Path._();
  static const MAIN_HOME = '/mainHome';
  static const HOME = '/home';
  static const LOGIN = '/login';
}
