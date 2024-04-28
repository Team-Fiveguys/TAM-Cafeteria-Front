import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 알림 채널을 초기화합니다.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  // Android용 알림 설정
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS용 알림 설정
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );

  // 초기화 설정
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      if (details.payload != null) {
        print(details.payload);
      }
    },
  );
  NotificationAppLaunchDetails? details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (details != null) {
    if (details.notificationResponse != null) {
      if (details.notificationResponse!.payload != null) {
        //
      }
    }
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    if (message != null) {
      print('main : message : ${message.data}');
      if (message.notification != null) {
        showNotification(message);
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data["click_action"]);
      }
    }
  });
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
  //   if (message != null) {
  //     if (message.notification != null) {
  //       showNotification(message);
  //       print(message.notification!.title);
  //       print(message.notification!.body);
  //       print(message.data["click_action"]);
  //     }
  //   }
  // });
  // FirebaseMessaging.instance
  //     .getInitialMessage()
  //     .then((RemoteMessage? message) async {
  //   if (message != null) {
  //     if (message.notification != null) {
  //       await showNotification(message);
  //       print(message.notification!.title);
  //       print(message.notification!.body);
  //       print(message.data["click_action"]);
  //     }
  //   }
  // });
}

Future<void> showNotification(RemoteMessage message) async {
  // 알림 내용 설정
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'high_importance_notification',
    importance: Importance.max,
    priority: Priority.high,
    color: Color(0xFFFFFFFF),
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // 알림 표시
  await flutterLocalNotificationsPlugin.show(
    0, // 알림 ID
    message.notification?.title, // 제목
    message.notification?.body, // 본문
    platformChannelSpecifics,
    payload: 'item x',
  );
}
