import 'dart:io';

import 'package:boilerplate/commons/log/log.dart';
import 'package:boilerplate/flavor/flavor.dart';
import 'package:boilerplate/models/user.dart';
import 'package:boilerplate/services/package_info_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class FirebaseAnalyticsService {
  FirebaseAnalyticsService._() {
    _analytics = FirebaseAnalytics.instance;
    init();
  }

  static FirebaseAnalyticsService? _instance;
  factory FirebaseAnalyticsService() => _instance ??= FirebaseAnalyticsService._();

  late FirebaseAnalytics _analytics;

  Future init() async {
    await PackageInfoService.instance.initCompleter.future;

    await _analytics.setDefaultEventParameters({
      "version": PackageInfoService.instance.version,
      "platform": Platform.operatingSystem,
      "env": Flavor.instance.name,
    });
  }

  Future resetUserDetail({User? profile}) {
    return Future.wait([
      _analytics.setUserId(id: profile?.username?.toString()),
      _analytics.setUserProperty(
        name: 'username',
        value: profile?.username?.toString(),
      ),
    ]);
  }

  Future logEvent(String name, Map<String, dynamic> params) {
    DLog.info("Logging event $name to Analytics, params: ${params.toString()}");
    return _analytics.logEvent(
      name: name,
      parameters: <String, Object>{
        ...params.map((key, value) => MapEntry(key, value is num ? value : value.toString())),
      },
    );
  }
}

extension LogToFirebaseAnalyticsByFunc on Function {
  Function logFA(String event, {Map<String, dynamic>? params}) => () {
    this();
    FirebaseAnalyticsService().logEvent(event, params ?? {});
  };
}

extension LogToFirebaseAnalyticsByVoidFunc on GestureTapCallback {
  GestureTapCallback logFA(String event, {Map<String, dynamic>? params}) => () {
    this();
    FirebaseAnalyticsService().logEvent(event, params ?? {});
  };
}

extension LogToFirebaseAnalyticsByVoid on void {
  void logFA(String event, {Map<String, dynamic>? params}) => () {
    FirebaseAnalyticsService().logEvent(event, params ?? {});
    return this;
  };
}
