import 'package:dio/dio.dart';

import '../api_clients/api_client.dart';

typedef CallbackFromInterceptorError = Function(
    DioException error, ErrorInterceptorHandler handler);

class ErrorInterceptor extends InterceptorsWrapper {
  BaseAPIClient apiClient;
  CallbackFromInterceptorError? onErrorCallback;

  ErrorInterceptor(this.apiClient, {this.onErrorCallback});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (onErrorCallback != null) {
      onErrorCallback!(err, handler);
    } else {
      super.onError(err, handler);
    }
  }
}
