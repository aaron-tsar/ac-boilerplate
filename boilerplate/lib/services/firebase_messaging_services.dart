import 'dart:async';
import 'dart:convert';

import 'package:boilerplate/commons/cubits/app_cubit/app_cubit.dart';
import 'package:boilerplate/commons/cubits/auth_cubit/auth_cubit.dart';
import 'package:boilerplate/commons/log/log.dart';
import 'package:boilerplate/models/notification_model.dart';
import 'package:boilerplate/routers/routers.dart';
import 'package:boilerplate/services/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();

  static FirebaseMessagingService instance =
      FirebaseMessagingService._();

  late final FirebaseMessaging _messaging;

  Completer fmsCompleter = Completer();

  BuildContext get routeContext => Routes.instance.context;

  AppCubit get appCubit => routeContext.read<AppCubit>();

  AuthCubit get authCubit => routeContext.read<AuthCubit>();

  BehaviorSubject<NotificationModel?> comingNotificationListener = BehaviorSubject.seeded(null);

  Future<void> init() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // 4. on Message Listen
    if (settings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        DLog.info('**onMessage** Called ${message.data}');
        if (message.notification?.title != null) {
          LocalNotificationService.instance.showNotification(
            title: message.notification?.title,
            body: message.notification?.body,
            payload: jsonEncode(message.data),
          );
        }
        final model = NotificationModel.fromJson(message.data)
          ..jsonData = message.data
          ..onListen();

        comingNotificationListener.value = model;
      });

      //5. background message using backgroundHandler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      //6. On message open app
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        DLog.info(
            '**onMessageOpenedApp** Called ${message.data.runtimeType}');

        //7. pass data into model
        NotificationModel? appNotification =
            NotificationModel.fromJson(message.data);
        appNotification.jsonData = message.data;

        onClickNotification(appNotification, openFromBanner: true);
        //8. Route handle
      });
    } else {
      DLog.info(
        'Messaging Permission -> User declined or has not accepted permission',
      );
    }
  }

  //9. get FCM Token
  Future<String?> getToken() async {
    final fcmToken = await _messaging.getToken();
    return fcmToken;
  }

  Future<void> onClickNotification(
      NotificationModel notificationModel,
      {bool openFromBanner = false}) async {
    await fmsCompleter.future;
    return Routes.instance.showLoadingDepend(notificationModel.onOpen());
  }

  Future<void> onAppStartedWithNotification() async {
    final initFromFB = await _messaging.getInitialMessage();
    if (initFromFB != null) {
      final initMessage = NotificationModel.fromJson(initFromFB.data);
      initMessage.jsonData = initFromFB.data;
      await onClickNotification(initMessage);
    }
  }
}

//10. backgroundHandle
Future _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();

  DLog.info(
      'MessageID Handling a background message: ${message.messageId}');
}

extension NotificationHandle on NotificationModel {
  BuildContext get routeContext => Routes.instance.context;

  AppCubit get appCubit => routeContext.read<AppCubit>();

  AuthCubit get authCubit => routeContext.read<AuthCubit>();

  Future<void> onOpen() async {
    // NotificationModel? detail = await read();

    // authCubit.notificationController.getStatistic(projectId);

    switch (type) {
      case 1:
        return;
      case 2:
        return;
      case 3:
        return;
      case 5:
      case 6:
      case 7:
        return;
      case 4:
      case 8:
        return;
    }
    // _goToNotificationDetailScreen(detail);
    return;
  }

  // void _goToNotificationDetailScreen(NotificationModel? detail) {
    // routeContext.push(NotificationDetailScreen.path, extra: detail);
  // }

  Future<NotificationModel> read() async {
    try {
      // final res = await appCubit.appReposProvider.notiRepos
      //     .getDetailNotification(
      //         projectID: projectId.toString(),
      //         notiItemId: notiItemId!);
      return this;
    } catch (_) {}
    return this;
  }

  Future<void> onListen() async {
    switch (type) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        return;
      case 7:
        return;
      case 8:
        return;
    }
  }
}

extension CompleteAfter<T> on Completer<T> {
  void completeAfter(T value) {
    if (isCompleted) return;
    complete(value);
  }
}
