import 'package:boilerplate/commons/cubits/app_cubit/app_cubit.dart';
import 'package:boilerplate/commons/cubits/auth_cubit/auth_cubit.dart';
import 'package:boilerplate/commons/cubits/auth_cubit/notification_controller.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/utils/app_utils.dart';
import 'package:boilerplate/commons/utils/popup_utils.dart';
import 'package:boilerplate/commons/validators/validator.dart';
import 'package:boilerplate/generated/locale_keys.g.dart';
import 'package:boilerplate/models/user.dart';
import 'package:boilerplate/routers/routers.dart';
import 'package:boilerplate/services/firebase_analytics_service.dart';
import 'package:boilerplate/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin AppMixin {
  AppUtils get appUtils => AppUtils.instance;

  BuildContext get appContext => Routes.instance.context;

  AppCubit get appCubit => appUtils.getCubit<AppCubit>(appContext);

  AuthCubit get authCubit => appUtils.getCubit<AuthCubit>(appContext);

  AppStyle get styles => appCubit.state.appStyle;

  Validator get validatorUtils => Validator.instance;

  AppReposProvider get appRepos => appCubit.appReposProvider;
  NotificationController get notiController => authCubit.notificationController;

  void unFocus() =>
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

  LocaleKeys get locale => LocaleKeys();

  Future showSuccess(String? text) {
    if (text != null) {
      return PopupUtils(appContext).showFlushBar(
          message: text, flushBarStatusType: FlushBarStatusType.succeed);
    }
    return Future.value(false);
  }

  void showValidateMessage(String? text) {
    if (text != null) {
      // return PopupUtils(appContext).showSnackBar(message: text);
    }
  }

  Future showError(String? text) {
    if (text != null) {
      return PopupUtils(appContext).showFlushBar(
          message: text, flushBarStatusType: FlushBarStatusType.error);
    }
    return Future.value(false);
  }

  Future showInfo(String? text) {
    if (text != null) {
      return PopupUtils(appContext).showFlushBar(
          message: text, flushBarStatusType: FlushBarStatusType.info);
    }
    return Future.value(false);
  }

  Future showWarning(String? text) {
    if (text != null) {
      return PopupUtils(appContext).showFlushBar(
          message: text, flushBarStatusType: FlushBarStatusType.warning);
    }
    return Future.value(false);
  }

  Routes get route => Routes.instance;

  double get marginBottomDefault => bottomNavigationBarHeight;

  double get bottomNavigationBarHeight => 110;


  Future showCopied(String copiedContent, {BuildContext? buildContext}) {
    return Clipboard.setData(ClipboardData(text: copiedContent)).then((_) {
      ScaffoldMessenger.of(buildContext ?? appContext).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 300),
        content: Text(
          "Đã sao chép vào khay nhớ tạm",
        ),
      ));
    });
  }

  Future logFA(String name, {Map<String, dynamic>? params}) => FirebaseAnalyticsService().logEvent(name, params ?? {});

  bool get isAuthenticated => authCubit.state.isAuthenticated;
  FireStoreService get fireStoreService => FireStoreService();
}


extension PlaySoundFunction on Function {
  void onPlay() {
    SystemSound.play(SystemSoundType.click);
    this.call();
  }
}

extension PlaySoundFuture<T> on Future<T> {
  Future<T> onPlay() {
    SystemSound.play(SystemSoundType.click);
    return this;
  }
}

extension AuthExtension on AuthCubit {
  User get currentProfile => profileController.current;
}

mixin SizeMixin {
  bool get tablet {
    var shortestSide = MediaQuery.of(Routes.instance.context).size.shortestSide;
    return shortestSide >= 550;
  }
}