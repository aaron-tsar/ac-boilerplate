import 'package:boilerplate/commons/utils/app_image.dart';

enum AppAsset {
  avatar("avatar.png"),
  logo("logo.png"),
  addToCart("add_to_cart.png"),
  consignment("consignment.png"),
  taobao("taobao.png"),
  p1688("1688.png"),
  tmall("tmall.png"),
  pinduoduo("pinduoduo.png"),

  ;

  const AppAsset(this.source);

  final String source;

  AppImage get image => AppImage(fullPath);
  static const String assetImagesPath = "assets/images";

  String get fullPath => "$assetImagesPath/$source";
}
