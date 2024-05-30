import 'dart:convert';
import 'package:boilerplate/commons/log/log.dart';
import 'package:dio/dio.dart';

class PrintInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DLog.error('(ERROR) URL: ${err.requestOptions.uri}\nData: ${err.response?.data}\nStatus code: ${err.response?.statusCode}',
        err.error, err.stackTrace);
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();
    final curl = options.toCurlCmd();

    DLog.info(
      '(REQUEST) URL: ${options.uri}\n$method\nData: ${options.data}\nQuery: ${options.queryParameters}\nHeader: ${options.headers}\nCurl: $curl',
    );

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DLog.info(
      '(RESPONSE) URL: ${response.requestOptions.uri}\nData: ${response.data}\nStatus code: ${response.statusCode}',
    );
    return super.onResponse(response, handler);
  }
}

extension Curl on RequestOptions {
  String toCurlCmd() {
    String cmd = "curl";
    String header = headers
        .map((key, value) {
      if (key == "content-type" &&
          value.toString().contains("multipart/form-data")) {
        value = "multipart/form-data;";
      }
      return MapEntry(key, "-H '$key: $value'");
    })
        .values
        .join(" ");
    String url = "$baseUrl$path";
    if (queryParameters.isNotEmpty) {
      String query = queryParameters
          .map((key, value) {
        return MapEntry(key, "$key=$value");
      })
          .values
          .join("&");

      url += (url.contains("?")) ? query : "?$query";
    }
    if (method == "GET") {
      cmd += " $header '$url'";
    } else {
      Map<String, dynamic> files = {};
      String postData = "-d ''";
      if (data != null) {
        if (data is FormData) {
          FormData fdata = data as FormData;
          for (var element in fdata.files) {
            MultipartFile file = element.value;
            files[element.key] = "@${file.filename}";
          }
          for (var element in fdata.fields) {
            files[element.key] = element.value;
          }
          if (files.isNotEmpty) {
            postData = files
                .map((key, value) => MapEntry(key, "-F '$key=$value'"))
                .values
                .join(" ");
          }
        } else if (data is Map<String, dynamic>) {
          files.addAll(data);

          if (files.isNotEmpty) {
            postData = "-d '${json.encode(files).toString()}'";
          }
        }
      }

      String method = this.method.toString();
      cmd += " -X $method $postData $header '$url'";
    }

    return cmd;
  }
}
