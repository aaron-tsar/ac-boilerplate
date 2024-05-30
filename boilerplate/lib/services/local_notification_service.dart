import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  //1. local notification Initialization for Android and IOS
  Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  //2. on select notification
  void selectNotification(NotificationResponse payload) async {
    final res = jsonDecode(payload.payload ?? "{}");
    if(res is Map<String, dynamic>) {
      // NotificationModel? appNotification = NotificationModel.fromJson(res);
      // appNotification.jsonData = res;
      //
      // FirebaseMessagingService.instance.onClickNotification(appNotification, openFromBanner: true);
    }
  }


  //3. show notification
  Future<void> showNotification(
      {String? title, String? body, String? payload}) async {
    var android = const AndroidNotificationDetails(
      '1',
      'APP',
      channelDescription: 'CHANNEL DESCRIPTION',
      priority: Priority.high,
      importance: Importance.max,
      icon: 'drawable/noti_icon',
    );

    var iOS = const DarwinNotificationDetails();
    var platform = NotificationDetails(iOS: iOS, android: android);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }
}
