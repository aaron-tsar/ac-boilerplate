import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:boilerplate/flavor/flavor.dart';

class PackageInfoService {
  PackageInfoService._() {
    init();
  }

  PackageInfo? packageInfo;
  Completer<bool> initCompleter = Completer();

  static PackageInfoService instance = PackageInfoService._();

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    packageInfo = await PackageInfo.fromPlatform();
    initCompleter.complete(true);
  }

  String get appName => packageInfo?.appName ?? "-";
  String get packageName => packageInfo?.packageName ?? "-";
  String get version => "${packageInfo?.version}($buildNumber)${Flavor.instance.subEnv}";
  String get buildNumber => packageInfo?.buildNumber ?? "-";

}
