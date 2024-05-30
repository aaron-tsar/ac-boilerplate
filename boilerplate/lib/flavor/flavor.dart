import 'flavor_enum.dart';

class Flavor {

  Flavor._() {
    currentFlavor = FlavorEnum.values.firstWhere((element) => element.name == name);
  }

  late FlavorEnum currentFlavor;

  bool get isProd => currentFlavor == FlavorEnum.pro;

  String get name => const String.fromEnvironment("FLAVOR");
  String get displayName => const String.fromEnvironment("DISPLAY_NAME");
  String get baseUrl => const String.fromEnvironment("BASE_URL");
  String get googlePlaceKey => const String.fromEnvironment("GOOGLE_PLACE_KEY");
  String get bundleId => const String.fromEnvironment("BUNDLE_ID");
  String get iosAppId => const String.fromEnvironment("IOS_APP_ID");
  String get s3AssetUrl => const String.fromEnvironment("S3_URL");
  String get buildName => const String.fromEnvironment("FLUTTER_BUILD_NAME");
  String get googleClientId => const String.fromEnvironment("GG_CLIENT_ID");

  String get subEnv {
    switch(currentFlavor){
      case FlavorEnum.dev: return "D";
      case FlavorEnum.sta: return "S";
      case FlavorEnum.pro: return "";
    }
  }

  static final instance = Flavor._();
}

extension JoinAsset on String? {
  String? fullS3Path() => this != null ? "${Flavor.instance.s3AssetUrl}$this" : null;
}