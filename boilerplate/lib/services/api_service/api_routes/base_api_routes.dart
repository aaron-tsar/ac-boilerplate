import 'package:dio/dio.dart';

abstract class APIRouteConfigurable<R1, R2, R3> {
  R3 apiType;
  bool authorize;
  String method, path;
  String? baseUrl;
  ResponseType responseType;

  APIRouteConfigurable(
      {required this.apiType,
      required this.authorize,
      required this.method,
      required this.path,
      this.baseUrl,
      required this.responseType});

  R1 getConfig(R2 baseOption);
}

