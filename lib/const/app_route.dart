part of 'app_page.dart';

abstract class AppRoute {
  AppRoute._();
  static const HOME = _Path.HOME;
}

abstract class _Path {
  _Path._();
  static const HOME = '/home';
}
