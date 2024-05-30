import 'dart:async';

import 'package:boilerplate/commons/log/log.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class FlutterLocalAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  static FlutterLocalAuth instance = FlutterLocalAuth();
  Completer<bool> initCheckCompleter = Completer();
  bool get initDone => initCheckCompleter.isCompleted;

  final List<BiometricType> _availableBiometrics = [];
  bool get faceIdAvailable => _availableBiometrics.contains(BiometricType.face);

  Future<void> init() async {
    if(!initDone) return;
    await getAvailableBio();
    initCheckCompleter.complete(true);
  }

  Future<void> getAvailableBio() async {
    try {
      DLog.info("LOADING BIOMETRICS");
      _availableBiometrics.addAll(await _auth.getAvailableBiometrics());
      DLog.info("LOADED BIOMETRICS");
    } on PlatformException catch (e) {
      DLog.error(e.toString());
    }
  }

  Future<bool> authenticate() async {
    await init();
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(useErrorDialogs: false, biometricOnly: true),
      );
    } on PlatformException catch (_) {

    }
    return false;
  }
}
