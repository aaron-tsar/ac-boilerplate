import 'package:boilerplate/flavor/flavor.dart';
import 'package:dio/dio.dart';

import '../api_response/base_api_response.dart';
import '../api_routes/base_api_routes.dart';
import '../decoder.dart';
import '../interceptors/auth_interceptor.dart';
typedef APIProgressCallback = void Function(double value);

abstract class BaseAPIClient {
  late BaseOptions options;
  late Dio instance;

  Future<T> request<T>(
      {required APIRouteConfigurable route,
      required GenericObject<T> create,
      Map<String, dynamic>? params,
      String? extraPath,
      FormData? formData,
      Map<String, dynamic>? header,
      dynamic body});

  void initInterceptors({List<InterceptorsWrapper>? interceptors});

  T? getInterceptor<T extends Interceptor>() {
    final interceptors = instance.interceptors;
    final T? interceptor =
        interceptors.whereType<T>().toList().firstOrNull;
    return interceptor;
  }
}

class APIClient extends BaseAPIClient {
  APIClient() {
    options = BaseOptions(
      validateStatus: (status) => true,
      baseUrl: Flavor.instance.baseUrl,
      headers: {"Content-Type": "application/json", "Accept": "*/*"},
      responseType: ResponseType.json,
    );
    instance = Dio(options);
  }

  @override
  Future<T> request<T>(
      {required route,
      required GenericObject<T> create,
      Map<String, dynamic>? params,
      String? extraPath,
      FormData? formData,
      Map<String, dynamic>? header,
        APIProgressCallback? onSendProgress,

        dynamic body}) async {

    final RequestOptions? requestOptions = route.getConfig(options);
    if (requestOptions != null) {
      if (onSendProgress != null) {
        double sumProgressValue = 0;
        void calculateProgress(count, total) {
          sumProgressValue += (count / total);
          onSendProgress((sumProgressValue / 2).clamp(0, 1));
        }

        requestOptions.onReceiveProgress = calculateProgress;
        requestOptions.onSendProgress = calculateProgress;
      }
      if (params != null) {
        requestOptions.queryParameters = params;
      }
      if (extraPath != null) requestOptions.path += extraPath;
      if (header != null) requestOptions.headers.addAll(header);
      if (body != null) {
        requestOptions.data = body;
      }
      if (formData != null) {
        if (requestOptions.data != null) {
          formData.fields.add(requestOptions.data);
        }
        requestOptions.data = formData;
      }

      try {
        Response response = await instance.fetch(requestOptions);

        T apiWrapper = create(response);

        ///using Wrapper
        if (apiWrapper is BaseAPIResponseWrapper) {
          apiWrapper = apiWrapper.decode() as T;

          if (apiWrapper is ErrorResponse) {
            throw apiWrapper;
          }
          return apiWrapper;
        }

        ///If you want to use another object type such as primitive type
        ///, but you need to ensure that the response type matches your expected type
        if (response.data is T) {
          return response.data;
        } else {
          throw ErrorResponse.defaultError(
              statusMessage:
                  "Can not match the $T type with ${response.data.runtimeType}");
        }
      } on DioException catch (e) {
        throw ErrorResponse(response: e.response);
      } on ErrorResponse catch (e) {
        if(e.isAuthError) {
          throw DioException(requestOptions: requestOptions, error: e);
        }
        rethrow;
      } catch (e) {
        throw ErrorResponse.defaultError(statusMessage: e.toString());
      }
    } else {
      throw ErrorResponse.defaultError(
          statusMessage: "Missing request options");
    }
  }

  @override
  void initInterceptors({List<Interceptor>? interceptors}) {
    instance.interceptors.clear();
    instance.interceptors.addAll(interceptors ?? []);
  }

  void updateAccessToken(AuthToken? authToken) {
    final authInterceptor = getInterceptor<AuthInterceptor>();
    if (authInterceptor is AuthInterceptor) {
      authInterceptor.token = authToken;
    }
  }
}
