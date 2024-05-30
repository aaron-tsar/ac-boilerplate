import 'package:boilerplate/models/error_data.dart';
import 'package:dio/dio.dart';

import '../api_response/base_api_response.dart';
import '../decoder.dart';

typedef RootKeyExtractor = String Function(Map<String, dynamic>? data);

///R = Raw type you get from response ( Ex: Using DIO is Response object)
///E = Formatted response type ( Ex: Common data format you want to get is Map<String,dynamic>
abstract class BaseAPIResponseDataTransformer<R, E, D> {
  RootKeyExtractor rootKeyExtractor;
  List<int> succeedStatuses;

  E transform(R response, D? genericObject);

  bool isSucceed(R? response);

  bool isString(dynamic data) => data is String;

  BaseAPIResponseDataTransformer(this.rootKeyExtractor,
      {this.succeedStatuses = const [200, 201, 202, 203, 204, 304]});
}

class APIResponseDataTransformer<T> extends BaseAPIResponseDataTransformer<
    Response, BaseAPIResponseWrapper<Response, T>, T> {
  APIResponseDataTransformer({RootKeyExtractor? rootKeyExtractor})
      : super(rootKeyExtractor ?? (_) => "data");

  @override
  BaseAPIResponseWrapper<Response, T> transform(
      Response response, T? genericObject) {
    dynamic data = response.data;
    if (data is Map) {
      data = data[rootKeyExtractor(response.data)];
    }

    T? object;
    if (genericObject is Decoder) {
      if (data is Map<String, dynamic>) {
        object = genericObject.decode(data);
      }
    } else if (data is T?) {
      object = data;
    }

    if (!isSucceed(response)) {
      throw ErrorResponse<ErrorData>(
              decodedData: DefaultErrorData(),
              dataTransformer: APIErrorTransformer<ErrorData>(),
              response: response)
          .decode();
    }

    return APIResponse<T>(
        decodedData: object,
        dataTransformer: this,
        response: response,
        message: response.statusMessage,
    );
  }

  @override
  bool isSucceed(Response? response) {
    if (succeedStatuses.contains(response?.statusCode)) {
      return true;
    }
    return false;
  }
}

class RapidResponseDataTransformer<T> extends BaseAPIResponseDataTransformer<
    Response, BaseAPIResponseWrapper<Response, T>, T> {
  RapidResponseDataTransformer({RootKeyExtractor? rootKeyExtractor})
      : super(rootKeyExtractor ?? (_) => "data");

  @override
  BaseAPIResponseWrapper<Response, T> transform(
      Response response, T? genericObject) {
    dynamic data = response.data;

    T? object;
    if (genericObject is Decoder) {
      if (data is Map<String, dynamic>) {
        object = genericObject.decode(data);
      }
    } else if (data is T?) {
      object = data;
    }

    if (!isSucceed(response)) {
      throw ErrorResponse<ErrorData>(
          decodedData: DefaultErrorData(),
          dataTransformer: APIErrorTransformer<ErrorData>(),
          response: response)
          .decode();
    }

    return RapidResponse<T>(
      decodedData: object,
      dataTransformer: this,
      response: response,
      message: response.statusMessage,
    );
  }

  @override
  bool isSucceed(Response? response) {
    if(response?.data["ErrorCode"] != "Ok") return false;
    return true;
  }
}

class APIListResponseDataTransformer<T> extends BaseAPIResponseDataTransformer<
    Response, BaseAPIResponseWrapper<Response, T>, T> {
  APIListResponseDataTransformer({RootKeyExtractor? rootKeyExtractor})
      : super(rootKeyExtractor ?? (_) => "data");

  @override
  BaseAPIResponseWrapper<Response, T> transform(
      Response response, T? genericObject) {

    List<T> decodedList = [];
    int? total;
    final data = response.data;

    if (data is Map) {
      final rawList = data[rootKeyExtractor(response.data)];
      if (rawList is List) {
        if (genericObject is Decoder) {
          for (final e in rawList) {
            if (e is Map<String, dynamic>) {
              decodedList.add(genericObject.decode(e));
            }
          }
        } else {
          decodedList = rawList.cast<T>();
        }
      }
      if (data["pagination"] case {'total': int a}) {
        total = a;
      }
    }

    if (!isSucceed(response)) {
      throw ErrorResponse<ErrorData>(
              decodedData: DefaultErrorData(),
              dataTransformer: APIErrorTransformer<ErrorData>(),
              response: response)
          .decode();
    }
    return APIListResponse(
        decodedList: decodedList,
        decodedData: genericObject,
        dataTransformer: this,
        total: total,
        response: response);
  }

  @override
  bool isSucceed(Response? response) =>
      succeedStatuses.contains(response?.statusCode);
}

class APIErrorTransformer<T>
    extends BaseAPIResponseDataTransformer<Response, ErrorResponse<T>, T> {
  APIErrorTransformer({RootKeyExtractor? rootKeyExtractor})
      : super(rootKeyExtractor ?? (_) => "message");

  @override
  bool isSucceed(Response? response) => false;

  @override
  ErrorResponse<T> transform(Response response, T? genericObject) {
    final errorMap = response.data is Map
        ? response.data["error"]
        : null;
    try {
      return ErrorResponse<T>(
          response: response,
          decodedData: genericObject,
          dataTransformer: this,
          message: errorMap?["message"] ?? response.statusMessage,
          errorType: getErrorType(errorMap?["code"]));
    } catch (e) {
      return ErrorResponse<T>(
          response: response,
          decodedData: genericObject,
          dataTransformer: this,
          message: response.statusMessage,
          errorType: APIErrorType.unknown);
    }
  }

  APIErrorType getErrorType(String? error) {
    if (error == "error.unauthorized") {
      return APIErrorType.unauthorized;
    }
    if (error == "error.userNotFound") {
      return APIErrorType.userNotFound;
    }

    return APIErrorType.unknown;
  }
}

class NotWrapDataTransformer<T> extends BaseAPIResponseDataTransformer<Response,
    BaseAPIResponseWrapper<Response, T>, T> {
  NotWrapDataTransformer({RootKeyExtractor? rootKeyExtractor})
      : super(rootKeyExtractor ?? (_) => "");

  @override
  BaseAPIResponseWrapper<Response, T> transform(
      Response response, T? genericObject) {
    dynamic data = response.data;

    T? object;
    if (genericObject is Decoder) {
      if (data is Map<String, dynamic>) {
        object = genericObject.decode(data);
      }
    } else if (data is T?) {
      object = data;
    }

    if (!isSucceed(response)) {
      throw ErrorResponse<ErrorData>(
              decodedData: DefaultErrorData(),
              dataTransformer: APIErrorTransformer<ErrorData>(),
              response: response)
          .decode();
    }

    return APIResponse<T>(
        decodedData: object,
        dataTransformer: this,
        response: response,
        message: response.data?["message"] ?? response.statusMessage);
  }

  @override
  bool isSucceed(Response? response) {
    if (succeedStatuses.contains(response?.statusCode)) {
      return true;
    }
    return false;
  }
}
