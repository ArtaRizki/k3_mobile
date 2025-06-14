// import 'package:string_validator/string_validator.dart';z

class AppUrl {
  /// KEY
  ///
  /// This constant using for default base api url, map key and app name
  /// Please be carefully to change this keys because might affect with all entire project .
  ///
  static const String MAPS_KEY = "AIzaSyDDPvYz8jGLntwWp-Nii2F7bvGADm504Ts";
  static const String DOMAIN = "10.0.2.2:8000";
  static const String DOMAIN2 = "10.0.2.2:8000";
  // static const String DOMAIN = "mkp-k3l.erdata.id";
  // static const String DOMAIN2 = "mkp-k3l.erdata.id";
  static const String BASE_API_FULL = "http://${DOMAIN}/api";
  static const String BASE_API_FULL_IMAGE =
      "http://${DOMAIN}/GoogleCloudMobile/GetImage?file=";
  static const String APP_NAME = "K3 Mobile";

  //date format
  // final DateFormat xDateFormat1 = DateFormat('yyyy-MM-dd');
  // final DateFormat xDateTimeFormat1 = DateFormat('d MMM yyyy, HH:mm');
  // final DateFormat xDateTimeFormat2 = DateFormat('E, d MMM yyyy');

  //image
  static const String dummyImage1 =
      'https://images.hindustantimes.com/rf/image_size_630x354/HT/p2/2020/11/14/Pictures/_ded48fd4-25fd-11eb-8924-93a7f7a2e27c.jpg';
  static const String dummyImage2 =
      'https://cdn-asset.jawapos.com/wp-content/uploads/2021/11/anak-main-560x390.jpg';
  static const String dummyImage3 =
      'https://res.cloudinary.com/ruparupa-com/image/upload/w_360,h_360,f_auto,q_auto/f_auto,q_auto:eco/v1589259712/Products/10408757_1.jpg';
  static const String dummyImage4 =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6pBqLk0DIVFM0CbRI3nD6vz1Y4vwqaakhyq_VXCHXz-aGRPSI-blnsGytOjjSsJloLxU&usqp=CAU';
  static const String dummyImage5 =
      'https://www.unicef.org/indonesia/sites/unicef.org.indonesia/files/styles/two_column/public/IDN-Children-UN0296085.JPG';
  // static const String dummyImage6 = '';
  static const String dummyImage6 =
      'https://www.news-medical.net/image.axd?picture=2016%2F3%2FChildren_playing_sunset_-_Zurijeta_8c5bdac77e44431bb1bfec67b9c87208-620x480.jpg';

  static const String loremIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc eu cursus ex. Sed vel pulvinar leo, porttitor viverra nulla. Donec vel quam lacinia, gravida mauris vel, sodales velit. ';

  static const String sampleYoutube =
      'https://www.youtube.com/watch?v=1MudGuYglG0&ab_channel=PutraAdin';
  static const String sampleYoutubeId = '1MudGuYglG0';

  static const String photoProfile1 =
      "https://ragasport.com/ragasport/media/avatars/blank.png";
  // "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?k=20&m=1223671392&s=612x612&w=0&h=lGpj2vWAI3WUT1JeJWm1PRoHT3V15_1pdcTn2szdwQ0=";

  static const String userGuideUrl = "user-guide-mobile";
  static const String syaratKetentuanUrl = "webview?slug=syarat-dan-ketentuan";
  static const String kebijakanPrivasiUrl = "webview?slug=kebijakan-privasi";
  static const String faqUrl = "webview?slug=faq";
  static const String kontakUrl = "webview?slug=kontak";
}
