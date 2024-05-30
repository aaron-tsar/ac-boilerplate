import 'dart:async';
import 'dart:convert';
import 'package:boilerplate/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boilerplate/services/api_service/interceptors/auth_interceptor.dart';

class AppSecureStorage {
  static const repos = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  static const String loggedInProfile = "logged_in_profile";
  static const String appAccessToken = "app_access_token";
  static const String requestLocalAuth = "req_local_auth";
  static const String firstInstall = "first_install";

  static Future<void> saveProfile(User profile) {
    final value = json.encode(profile.toJson());
    return repos.write(key: loggedInProfile, value: value);
  }

  static Future<User?> getStoredProfile() async {
    final res = await repos.read(key: loggedInProfile);

    if (res == null) return Future.value(null);

    final map = json.decode(res);
    return User.fromJson(map);
  }

  static Future<void> saveAuthToken(AuthToken authToken) {
    final value = json.encode(authToken.toJson());
    return repos.write(key: appAccessToken, value: value);
  }

  static Future<AuthToken?> getStoredAuthToken() async {
    final res = await repos.read(key: appAccessToken);

    if (res == null) return Future.value(null);

    final map = json.decode(res);
    return AuthToken.fromJson(map);
  }

  static Future<void> saveReqAuth(bool accepted) {
    return accepted
        ? repos.write(key: requestLocalAuth, value: "true")
        : repos.delete(key: requestLocalAuth);
  }

  static Future<bool> getReqAuth() async {
    final res = await repos.read(key: requestLocalAuth);

    if (res == "true") return true;

    return false;
  }

  static Future<void> onLogOutClear() {
    return Future.wait([
      repos.delete(key: appAccessToken),
      repos.delete(key: loggedInProfile),
      repos.delete(key: requestLocalAuth),
    ]);
  }
}

class AppSharedPreferences {
  late SharedPreferences prefs;
  Completer<bool> initComplete = Completer();
  static const String firstInstall = "first_install";
  static const String cart = "cart";
  static const String savedStore = "savedStore";

  static AppSharedPreferences? _instance;

  factory AppSharedPreferences() =>
      _instance ??= AppSharedPreferences._();

  AppSharedPreferences._() {
    initial();
  }

  void initial() async {
    prefs = await SharedPreferences.getInstance();
    initComplete.complete(true);
  }

  Future<bool> save1stInstall() async {
    await initComplete.future;
    return prefs.setBool(firstInstall, true);
  }

  Future<bool> get1stInstall() async {
    await initComplete.future;
    return prefs.getBool(firstInstall) == null;
  }

  Future<void> onLogOutClear() async {
    return;
  }
}
