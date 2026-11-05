import 'dart:developer';

import 'package:aqua_nexis/app/urls.dart';
import 'package:aqua_nexis/core/service/network_caller/network_caller.dart';
import 'package:aqua_nexis/core/storage/auth_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  final NetworkCaller _networkCaller = NetworkCaller(
    headers: () {
      final token = AuthStorage.userData?.token;

      return {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Token $token',
      };
    },
  );

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'aquanexis_alerts',
    'AquaNexis Alerts',
    description: 'Aquarium monitoring and abnormal behavior alerts',
    importance: Importance.high,
    playSound: true,
  );

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Initialize local notifications.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings: initializationSettings);

    // 2. Create Android notification channel.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 3. Request notification permission.
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('Notification permission: ${settings.authorizationStatus}');

    // 4. Get FCM token and register with Django.
    final token = await _messaging.getToken();

    if (token != null && token.isNotEmpty) {
      await _registerToken(token);
    } else {
      log('FCM token was not available.');
    }

    // 5. Listen for FCM token refresh.
    _messaging.onTokenRefresh.listen(
      (String token) async {
        log('FCM token refreshed.');

        await _registerToken(token);
      },
      onError: (error) {
        log('FCM token refresh error: $error');
      },
    );

    // 6. Handle foreground messages.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Foreground notification received.');

      log('Title: ${message.notification?.title}');
      log('Body: ${message.notification?.body}');
      log('Data: ${message.data}');

      await _showLocalNotification(message);
    });

    _isInitialized = true;
  }

  Future<void> _registerToken(String token) async {
    try {
      final response = await _networkCaller.postRequest(
        Urls.firebaseFCMregisterUrl,
        body: {'fcm_token': token, 'platform': 'android'},
      );

      if (response.isSuccess) {
        log('FCM token registered successfully.');
      } else {
        log(
          'FCM registration failed: '
          '${response.errorMessage ?? 'Unknown error'}',
        );
      }
    } catch (error) {
      log('FCM registration exception: $error');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final androidDetails = AndroidNotificationDetails(
      'aquanexis_alerts',
      'AquaNexis Alerts',
      channelDescription: 'Aquarium monitoring alerts',

      importance: Importance.max,
      priority: Priority.high,

      icon: '@mipmap/ic_launcher',

      color: const Color(0xFF087E8B),

      styleInformation: BigTextStyleInformation(
        message.notification?.body ?? '',
        contentTitle: message.notification?.title,
        summaryText: 'AquaNexis Aquarium Alert',
      ),

      category: AndroidNotificationCategory.status,
      visibility: NotificationVisibility.public,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'AquaNexis Alert',
      body: message.notification?.body ?? '',
      notificationDetails: notificationDetails,
      payload: message.data['type'],
    );
  }
}
