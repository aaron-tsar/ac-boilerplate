import 'package:boilerplate/commons/styles/themes/default_theme.dart';
import 'package:boilerplate/repos/notification_repos.dart';
import 'package:boilerplate/services/api_service/interceptors/firestore_cache_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate/commons/cubits/auth_cubit/auth_cubit.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/localizations/app_localization.dart';
import 'package:boilerplate/repos/auth_repos.dart';
import 'package:boilerplate/routers/routers.dart';
import 'package:boilerplate/services/api_service/interceptors/hive_cache_interceptor.dart';

import '../../../services/api_service/api_clients/api_client.dart';
import '../../../services/api_service/interceptors/auth_interceptor.dart';
import '../../../services/api_service/interceptors/error_interceptor.dart';
import '../../../services/api_service/interceptors/log_interceptor.dart';
import 'app_state.dart';

class AppReposProvider {
  final BaseAPIClient apiClient;
  final BaseAPIClient cacheApiClient;
  final BaseAPIClient fireStoreCacheAPIClient;

  AppReposProvider(this.apiClient, this.cacheApiClient, this.fireStoreCacheAPIClient);

  AuthRepos get authRepos => AuthReposImpl(apiClient);
  NotificationRepos get notiRepos => NotificationReposImpl(apiClient);
}

class AppCubit extends Cubit<AppState> {
  APIClient apiClient = APIClient();
  APIClient refreshTokenAPIClient = APIClient();
  APIClient cacheAPIClient = APIClient();
  APIClient fireStoreCacheAPIClient = APIClient();

  late AppReposProvider appReposProvider;

  AppCubit() : super(AppState(type: AppStateType.initial, appStyle: DefaultTheme(), supportedLocale: SupportedLocale.vi)) {
    appReposProvider = AppReposProvider(apiClient, cacheAPIClient, fireStoreCacheAPIClient);
  }

  BuildContext get appContext => Routes.instance.context;

  void initInterceptor(AuthToken? authToken, AuthCubit authCubit) async {
    apiClient.initInterceptors(interceptors: [
      AuthInterceptor(refreshTokenAPIClient, onUnAuthenticated: () {
        authCubit.onLogout(requestLogout: true);
      }, token: authToken),
      PrintInterceptor(),
      ErrorInterceptor(apiClient, onErrorCallback: _onErrorCallback),
    ]);
    cacheAPIClient.initInterceptors(
      interceptors: [
        await HiveCacheInterceptor.init(),
        PrintInterceptor(),
        ErrorInterceptor(cacheAPIClient, onErrorCallback: _onErrorCallback),
      ],
    );

    fireStoreCacheAPIClient.initInterceptors(
      interceptors: [
        FireStoreCacheInterceptor(),
        PrintInterceptor(),
        ErrorInterceptor(cacheAPIClient, onErrorCallback: _onErrorCallback),
      ],
    );

  }

  void _onErrorCallback(DioException error, ErrorInterceptorHandler handler) {}

  void initMetaData() async {
    // final locale = find(appContext.locale);
    final locale = state.supportedLocale.locale;
    await appContext.setLocale(locale);

    emit(state.copyWith(
      supportedLocale: SupportedLocale.vi,
      type: AppStateType.loaded,
    ));
    await Routes.instance.showMaintenanceAppDialog();
    Routes.instance.showUpdateAppDialog();
  }

  void changeLocale(SupportedLocale supportedLocale) async {
    await appContext.setLocale(supportedLocale.locale);
    emit(state.copyWith(supportedLocale: supportedLocale));
    WidgetsFlutterBinding.ensureInitialized().performReassemble();
  }

  void changeStyle(AppStyle appStyle) {
    emit(state.copyWith(appStyle: appStyle));
    WidgetsFlutterBinding.ensureInitialized().performReassemble();
  }
}
