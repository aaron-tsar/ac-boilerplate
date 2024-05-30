import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

import 'package_info_service.dart';

class RemoteConfigService {
  RemoteConfigService._() : _remoteConfig = FirebaseRemoteConfig.instance;

  static RemoteConfigService? _instance;
  factory RemoteConfigService() => _instance ??= RemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig;
  late final StreamSubscription<RemoteConfigUpdate> configChangedStream;

  String _getString(String key) => _remoteConfig.getString(key);
  bool _getBool(String key) => _remoteConfig.getBool(key);

  void _setListener() {
    configChangedStream = _remoteConfig.onConfigUpdated.listen((event) async {
      await _remoteConfig.activate();
      debugPrint('The config has been updated.');
    });
  }

  Future<void> _setDefaults() async => _remoteConfig.setDefaults(
    {
      RemoteConfigKeys.forceLogin: false,
      RemoteConfigKeys.appVersion: PackageInfoService.instance.version,
    },
  );

  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();

    if (updated) {
      debugPrint('The config has been updated.');
    } else {
      debugPrint('The config is not updated..');
    }
  }

  Future<void> initialize() async {
    await PackageInfoService.instance.initCompleter.future;
    _setListener();
    await _setDefaults();
    await fetchAndActivate();
  }

  bool get forceLogin => _getBool(RemoteConfigKeys.forceLogin);
  List<HelpCenterQuestion> get helpCenter {
    final value = _remoteConfig.getValue(RemoteConfigKeys.helpCenter);
    final decoded = value.asString().isNotEmpty ? jsonDecode(value.asString()) : null;
    if(decoded is Map && decoded["term"] is List && (decoded["term"] as List).isNotEmpty) {
      final list = <HelpCenterQuestion>[];
      decoded["term"].forEach((e) {
        final model = HelpCenterQuestion(
          q: e["Q"],
          a: e["A"],
        );
        list.add(model);
      });
      return list;
    }
    return [];
  }

  bool get maintenance => _getBool(RemoteConfigKeys.maintenance);
  String get appVersion => _getString(RemoteConfigKeys.appVersion);
  String get termCondition => _getString(RemoteConfigKeys.termCondition);

  Future<bool> mustUpdate() async {
    await PackageInfoService.instance.initCompleter.future;
    final localVer = PackageInfoService.instance.version;
    if(localVer != appVersion) {
      return true;
    }
    return false;
  }
}

class RemoteConfigKeys {
  static const String forceLogin = 'forceLogin';
  static const String appVersion = 'app_version';
  static const String termCondition = 'term_condition';
  static const String helpCenter = 'help_center';
  static const String maintenance = "maintenance";
}

class HelpCenterQuestion {
  final String q;
  final String a;

  HelpCenterQuestion({required this.q, required this.a});
}