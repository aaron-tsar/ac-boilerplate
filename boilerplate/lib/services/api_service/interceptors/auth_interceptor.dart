import 'dart:io';
import 'package:boilerplate/services/api_service/api_response/base_api_response.dart';
import 'package:boilerplate/services/flutter_secure.dart';
import 'package:dio/dio.dart';

import '../api_clients/api_client.dart';
import '../api_routes/api_routes.dart';
import '../decoder.dart';

class AuthToken extends Decoder<AuthToken> {
  String? accessToken;

  AuthToken({
    this.accessToken,
  });

  @override
  AuthToken decode(Map<String, dynamic> json) {
    return AuthToken.fromJson(json);
  }

  AuthToken.fromJson(Map<String, dynamic> json) {
    accessToken = json["accessToken"];
  }

  Map<String, dynamic> toJson(){
    return {
      "accessToken": accessToken,
    };
  }
}

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final BaseAPIClient client;
  final Function? onUnAuthenticated;
  AuthToken? token;

  AuthInterceptor(this.client, {this.onUnAuthenticated, this.token});

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authorize = options.extra[APIRoute.authorizeKey] ?? false;
    if (!authorize) {
      return super.onRequest(options, handler);
    } else {
      if (token?.accessToken != null) {
        options.headers.addAll(
          {
            HttpHeaders.authorizationHeader: "Bearer ${token?.accessToken}",
          },
        );
      }
      return super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if(response.data case {"data": {"accessToken": final newToken}}) {
      token = AuthToken(accessToken: newToken);
      AppSecureStorage.saveAuthToken(token!);
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {

    if(err.error is ErrorResponse && (err.error as ErrorResponse).isAuthError){
      onUnAuthenticated?.call();
    }

    super.onError(err, handler);
  }
}
