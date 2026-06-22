import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/api_client.dart';
import '../core/secure_storage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // handle background messages here if needed
  debugPrint('Background message received: ${message.messageId}');
}

class PushService {
  static final _messaging = FirebaseMessaging.instance;
  static final _storage = SecureStorage();
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Android channel for foreground notifications
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    // Initialize local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInit = DarwinInitializationSettings();
    final initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    await _localNotifications.initialize(settings: initSettings);

    // Create Android notification channel
    try {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);
    } catch (e) {
      debugPrint('Failed creating notification channel: $e');
    }

    // background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // request permission on iOS
    if (Platform.isIOS) {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    }

    // get the token and register it with backend
    final token = await _messaging.getToken();
    if (token != null) {
      debugPrint('FCM token: $token');
      try {
        final access = await _storage.readAccessToken();
        if (access != null) {
          // attach token header temporarily
          await dio.post('/notifications/register',
              data: {'token': token, 'platform': Platform.operatingSystem},
              options: Options(headers: {'Authorization': 'Bearer $access'}));
        } else {
          // attempt unauthenticated register (if backend allows)
          await dio.post('/notifications/register',
              data: {'token': token, 'platform': Platform.operatingSystem});
        }
      } catch (err) {
        debugPrint('Failed to register device token: $err');
      }
    }

    // foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          'Foreground message: ${message.notification?.title} - ${message.notification?.body}');
      // Show a local notification for foreground messages
      try {
        final title = message.notification?.title ?? '';
        final body = message.notification?.body ?? '';
        _showLocalNotification(title: title, body: body, data: message.data);
      } catch (e) {
        debugPrint('Error showing local notification: $e');
      }
    });
  }

  static Future<void> _showLocalNotification(
      {required String title,
      required String body,
      Map<String, dynamic>? data}) async {
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    final iosDetails = DarwinNotificationDetails();
    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      id: title.hashCode ^ body.hashCode,
      title: title,
      body: body,
      notificationDetails: details,
      payload: data != null && data.isNotEmpty ? data.toString() : null,
    );
  }
}
