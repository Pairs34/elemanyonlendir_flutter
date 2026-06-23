import 'dart:io';

import 'package:elemanyonlendir/core/notifications/notification_service.dart';
import 'package:elemanyonlendir/core/storage/auth_storage.dart';
import 'package:elemanyonlendir/data/api/api_service.dart';
import 'package:elemanyonlendir/core/config/app_config.dart';
import 'package:elemanyonlendir/firebase_options.dart';
import 'package:elemanyonlendir/presentation/browser_page.dart';
import 'package:elemanyonlendir/presentation/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initializeFirebase();
  await NotificationService.instance.init();
  await NotificationService.instance.showFirebaseMessage(message);
  debugPrint('Background message received: ${message.messageId}');
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<Widget> _determineStartPage() async {
  final token = await AuthStorage.instance.getToken();
  debugPrint('main: found token=${token != null}');
  if (token == null) return LoginPage();

  try {
    final verify = await ApiService().verifyToken().timeout(
          const Duration(seconds: 10),
          onTimeout: () => 'no_token',
        );
    debugPrint('main: verifyToken result=$verify');
    if (verify.contains('success')) {
      return BrowserPage(
        url: "${AppConfig.baseUrl}/app/token/$token",
        verifyTokenOnResume: true,
      );
    }
  } catch (e, st) {
    debugPrint('main: verifyToken failed: $e\n$st');
  }

  return LoginPage();
}

class MyApp extends StatelessWidget {
  final Widget home;
  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeFirebase();
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissionsIfNeeded();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((message) {
    debugPrint('🔥 Foreground mesajı alındı: ${message.messageId}');
    debugPrint(
        '📬 Notification: ${message.notification?.title} - ${message.notification?.body}');
    debugPrint('📦 Data: ${message.data}');
    NotificationService.instance.showFirebaseMessage(message);
  });

  final fcmToken = Platform.isIOS
      ? await FirebaseMessaging.instance.getAPNSToken()
      : await FirebaseMessaging.instance.getToken();
  debugPrint('FCM Token: $fcmToken');

  final startPage = await _determineStartPage();
  debugPrint('main: startPage=${startPage.runtimeType}');
  runApp(MyApp(home: startPage));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
    debugPrint('main: splash removed after first frame');
  });
  debugPrint('main: runApp completed');
}
