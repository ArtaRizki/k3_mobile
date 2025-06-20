class AppUrl {
  /// KEY
  ///
  /// This constant using for default base api url, map key and app name
  /// Please be carefully to change this keys because might affect with all entire project .
  ///
  static const String MAPS_KEY = "AIzaSyDDPvYz8jGLntwWp-Nii2F7bvGADm504Ts";
  // static const String DOMAIN = "10.0.2.2:8000";
  static const String DOMAIN = "mkp-k3l.erdata.id";
  static const String BASE_API_FULL = "https://${DOMAIN}/api";
  static const String BASE_API_FULL_IMAGE =
      "http://${DOMAIN}/GoogleCloudMobile/GetImage?file=";
  static const String APP_NAME = "MSafety";
}
