import 'package:dio/dio.dart';

import '../transformer/base_data_transformer.dart';

abstract class BaseAPIResponseWrapper<R, E> {
  R? originalResponse;
  E? decodedData;
  String? message;
  BaseAPIResponseDataTransformer dataTransformer;

  BaseAPIResponseWrapper(
      {this.decodedData,
      this.originalResponse,
      this.message,
      required this.dataTransformer});

  BaseAPIResponseWrapper<R, E> decode();
}

enum APIErrorType {
  unauthorized,
  workingSessionExisted,
  unknown,
  userNotFound,
}

class APIResponse<T> extends BaseAPIResponseWrapper<Response, T> {
  APIResponse({
    required Response? response,
    super.decodedData,
    super.message,
    BaseAPIResponseDataTransformer? dataTransformer,
    int? status,
  }) : super(
            originalResponse: response,
            dataTransformer:
                dataTransformer ?? APIResponseDataTransformer<T>());

  @override
  APIResponse<T> decode() =>
      dataTransformer.transform(originalResponse, decodedData);
}

class RapidResponse<T> extends BaseAPIResponseWrapper<Response, T> {
  RapidResponse({
    required Response? response,
    super.decodedData,
    super.message,
    BaseAPIResponseDataTransformer? dataTransformer,
    int? status,
  }) : super(
      originalResponse: response,
      dataTransformer:
      dataTransformer ?? RapidResponseDataTransformer<T>());

  @override
  RapidResponse<T> decode() =>
      dataTransformer.transform(originalResponse, decodedData);
}

class APIListResponse<T> extends BaseAPIResponseWrapper<Response, T> {
  final List<T> decodedList;
  final int? total;

  APIListResponse({
    required Response? response,
    this.decodedList = const [],
    this.total,
    super.decodedData,
    BaseAPIResponseDataTransformer? dataTransformer,
  }) : super(
            originalResponse: response,
            dataTransformer: dataTransformer ??
                APIListResponseDataTransformer<T>());

  @override
  APIListResponse<T> decode() =>
      dataTransformer.transform(originalResponse, decodedData);
}

class ErrorResponse<T> extends BaseAPIResponseWrapper<Response, T> {
  APIErrorType errorType;

  ErrorResponse({
    this.errorType = APIErrorType.unknown,
    Response? response,
    super.decodedData,
    BaseAPIResponseDataTransformer? dataTransformer,
    super.message,
  }) : super(
      originalResponse: response,
      dataTransformer:
      dataTransformer ?? APIErrorTransformer<T>());

  ErrorResponse.defaultError({
    String? statusMessage,
    APIErrorType errorType = APIErrorType.unknown,
  }) : this(errorType: errorType, message: statusMessage);

  @override
  ErrorResponse<T> decode() =>
      dataTransformer.transform(originalResponse, decodedData);

  bool get isAuthError => errorType == APIErrorType.unauthorized;

  @override
  String toString() {
    // TODO: implement toString
    return message ?? super.toString();
  }
}
