import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';

import '../constants/endpoints.dart';
import 'api_service.dart';

class NotificationService {
  static late FirebaseMessaging _firebaseMessaging;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future<void> init() async {
    _firebaseMessaging = FirebaseMessaging.instance;

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          // onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await initializeToken();
    }
    _setupForegroundNotificationListener();

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   await _initializeToken();
    //   _setupForegroundNotificationListener();
    // }
  }

  static Future<void> initializeToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken != null) {
            // Then get FCM token
            String? fcmToken = await _firebaseMessaging.getToken();
            print("FCM Token: $fcmToken");
          } else {
            print("APNs token not available yet.");
          }
      }
      final token = await _firebaseMessaging.getToken();
      print('FCM token: $token');
      await Api().post(Endpoints.fcmToken, data: {'token': token});
    } catch (e) {
      print('Error initializing FCM token: $e');
    }
  }

  static Future<void> _setupForegroundNotificationListener() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null &&
          message.notification?.android != null) {
        _showLocalNotification(
          message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body',
        );
      }
      messageHandlerWhenForeground(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      messageHandlerWhenBackground(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        messageHandlerWhenBackground(message);
      }
    });
  }

  static Future<void> messageHandlerWhenBackground(
    RemoteMessage message,
  ) async {
    // if (authManager.authenticationToken == null) {
    //   return;
    // }

    if (message.data['goto'] != null) {
      final String? route = message.data['goto'] as String?;
      if (route != null && AppRoutes.getPages().any((p) => p.name == route)) {
        Get.toNamed(route);
      } else {
        // Unknown route; ignore or log
        print('Unknown goto route from notification: $route');
      }
    }
  }

  static Future<void> messageHandlerWhenForeground(
    RemoteMessage message,
  ) async {
    // if (authManager.authenticationToken == null) {
    //   return;
    // }

    // if (message.data['action'] == 'update_wallet') {
    //   loadWalletData();
    // }
  }

  static Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'important_channel', // Replace with your own channel id
          'Important Notification', // Replace with your own channel name
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID, can be any integer
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
