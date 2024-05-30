import 'dart:io';
import 'package:boilerplate/commons/extensions/string.dart';
import 'package:boilerplate/models/user.dart';
import 'package:boilerplate/services/date_services.dart';
import 'package:boilerplate/services/firebase_messaging_services.dart';
import 'package:boilerplate/services/package_info_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../services/api_service/api_clients/api_client.dart';
import '../services/api_service/api_response/base_api_response.dart';
import '../services/api_service/api_routes/api_routes.dart';

abstract class AuthRepos {
  Future<User?> login(String username, String password);
  Future<User?> signUp(String username, String email, String password, String fullName, DateTime? dob, String phone);

  Future<User?> updateProfile(String? fullName, DateTime? dob, String? phone, String? email);
  Future<User?> getProfile();
  Future<bool?> logout();

  Future changePassword(String password, String newPassword);
  Future<bool?> forgotPassword(String email, String username);
}

class AuthReposImpl extends AuthRepos {
  final BaseAPIClient apiClient;

  AuthReposImpl(this.apiClient);

  Future<Map<String, dynamic>> getDeviceInfoBody() async {


    await PackageInfoService.instance.initCompleter.future;
    final packageInfoService = PackageInfoService.instance;

    final deviceInfoPlugin = DeviceInfoPlugin();
    final token = await FirebaseMessagingService.instance.getToken();

    final body = <String, dynamic> {};

    if(Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      body.addAll({
        "deviceCode": deviceInfo.id,
        "deviceName": deviceInfo.device,
        "tokenFirebase": token,
        "devicePlatform": "android",
        "deviceVersion": deviceInfo.version.release,
        "appVersion": packageInfoService.version,
      });
    }

    if(Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      body.addAll({
        "deviceCode": deviceInfo.identifierForVendor,
        "deviceName": deviceInfo.name,
        "tokenFirebase": token,
        "devicePlatform": "ios",
        "deviceVersion": deviceInfo.systemVersion,
        "appVersion": packageInfoService.version,
      });
    }
    return body;
  }

  @override
  Future<User?> login(String username, String password) async {
    final body = <String, dynamic> {
      "username": username,
      "password": password,
    };

    body.addAll(await getDeviceInfoBody());

    final response = await apiClient.request<APIResponse<User>>(
      body: body,
      route: APIRoute(apiType: APIType.login),
      create: (res) => APIResponse<User>(
        response: res,
        decodedData: User(),
      ),
    );
    return response.decodedData;
  }

  @override
  Future<User?> getProfile() async {
    final response = await apiClient.request<APIResponse<User>>(
      route: APIRoute(apiType: APIType.getProfile),
      create: (res) => APIResponse<User>(
        response: res,
        decodedData: User(),
      ),
    );
    return response.decodedData;
  }

  @override
  Future<User?> signUp(String username, String email, String password, String fullName, DateTime? dob, String phone) async {
    final response = await apiClient.request<APIResponse<User>>(
      body: <String, dynamic> {
        "username": username,
        "email": email,
        "password": password,
        "fullName": fullName,
        if(phone.isNotEmpty) "phoneNumber": phone,
        if(dob != null) "dob": DateFormatConstants.yyyyMMdd.dateFormat(dateTime: dob),
      }..addAll(await getDeviceInfoBody()),
      route: APIRoute(apiType: APIType.signUp),
      create: (res) => APIResponse<User>(
        response: res,
        decodedData: User(),
      ),
    );
    return response.decodedData;
  }

  @override
  Future<User?> updateProfile(String? fullName, DateTime? dob, String? phone, String? email) async {
    final body = {
      "phoneNumber": phone,
      "email": email,
      "fullName": fullName,
      "dob": dob != null ? DateFormatConstants.yyyyMMdd.dateFormat(dateTime: dob) : null,
    }..removeWhere((key, value) => value == null);
    final response = await apiClient.request<APIResponse<User>>(
      body: body,
      route: APIRoute(apiType: APIType.updateProfile),
      create: (res) => APIResponse<User>(
        response: res,
        decodedData: User(),
      ),
    );
    return response.decodedData;
  }

  @override
  Future<bool?> logout() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final body = <String, dynamic> {};

    if(Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      body.addAll({
        "deviceCode": deviceInfo.id,
      });
    }

    if(Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      body.addAll({
        "deviceCode": deviceInfo.identifierForVendor,
      });
    }
    final response = await apiClient.request<APIResponse<bool>>(
      body: body,
      route: APIRoute(apiType: APIType.logout),
      create: (res) => APIResponse<bool>(
        response: res,
      ),
    );
    return response.decodedData;
  }

  @override
  Future changePassword(String password, String newPassword) async {
    final body = {
      "currentPassword": password,
      "password": newPassword,
    };
    final response = await apiClient.request<APIResponse>(
      body: body,
      route: APIRoute(apiType: APIType.changePassword),
      create: (res) => APIResponse(
        response: res,
      ),
    );
    return response.decodedData;
  }

  @override
  Future<bool?> forgotPassword(String email, String username) async {
    final response = await apiClient.request<APIResponse<bool>>(
      body: {
        "email": email,
        "userName": username,
      },
      route: APIRoute(apiType: APIType.forgotPassword),
      create: (res) => APIResponse<bool>(
        response: res,
      ),
    );
    return response.decodedData;
  }
}
