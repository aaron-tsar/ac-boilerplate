import 'dart:io';

import 'package:boilerplate/services/bundle_load_service.dart';
import 'package:boilerplate/services/local_notification_service.dart';
import 'package:boilerplate/services/firebase_messaging_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:boilerplate/app.dart';
import 'package:boilerplate/services/remote_config_service.dart';
import 'package:boilerplate/flavor/flavor.dart';

void main() async {
  await initializeApp();
  runApp(const MyApp());
}

Future initializeApp() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['assets', 'fonts'], license);
  });

  await FirebaseMessagingService.instance.init();
  await LocalNotificationService.instance.init();
  BundleLoadService.instance.init();
  await RemoteConfigService().initialize();

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode && Flavor.instance.isProd);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(Platform.isAndroid
      ? SystemUiMode.immersiveSticky
      : SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
  ));
}
