import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _flnp =
      FlutterLocalNotificationsPlugin();

  // Yeni kanal ID: Önceki kalıcı kanallarla çakışmayı ve sessiz kalmayı önlemek için
  static const String channelId = 'high_importance_with_sound';
  static const String channelName = 'High Importance With Sound';
  static const String channelDescription =
      'This channel is used for important notifications with sound.';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // iOS init
    const iosInit = DarwinInitializationSettings();

    // Android init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flnp.initialize(initSettings);

    // Android kanal oluşturma (ses açık)
    final androidPlugin = _flnp.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelId,
          channelName,
          description: channelDescription,
          importance: Importance.high,
          playSound: true,
          // Özel ses: android/app/src/main/res/raw/notification.(wav|mp3)
          sound: RawResourceAndroidNotificationSound('notification'),
        ),
      );
    }

    // Uygulama ön plandayken iOS bildirim sunumu
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _initialized = true;
  }

  Future<void> requestPermissionsIfNeeded() async {
    // Android 13+ tarafında izin runtime istenir
    final androidPlugin = _flnp.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    if (Platform.isIOS) {
      await _flnp
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showFirebaseMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    show(title: notification.title, body: notification.body);
  }

  void show({String? title, String? body}) {
    if (!_initialized) {
      if (kDebugMode) {
        debugPrint('NotificationService not initialized. Call init() first.');
      }
      return;
    }

    _flnp.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
          // icon: '@mipmap/ic_notification', // İsteğe bağlı özel bildirim ikonu
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          // Özel ses: ios/Runner içine notification.caf ekleyin ve target'a dahil edin
          sound: 'notification.caf',
        ),
      ),
    );
  }
}
