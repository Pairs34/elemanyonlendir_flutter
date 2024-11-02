import 'package:elemanyonlendir/Concrete/Api.dart';
import 'package:elemanyonlendir/Concrete/firebase_service.dart';
import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/UI/frmBrowser.dart';
import 'package:elemanyonlendir/UI/frmLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:elemanyonlendir/Helpers/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late final AndroidNotificationChannel notificationChannel;
bool isFlutterLocalNotificationsInitialized = false;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initializeFirebase();
  await setupFlutterNotifications();
  showNotification(message);
  debugPrint('Background message received: ${message.messageId}');
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint('Authorization status: ${settings.authorizationStatus}');
}

void setupForegroundMessageListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Foreground mesajı alındı: ${message.messageId}');
    showNotification(message);
  });
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) return;

  notificationChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

void showNotification(RemoteMessage message) {
  final notification = message.notification;
  final androidNotification = message.notification?.android;

  if (notification != null && androidNotification != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannel.id,
          notificationChannel.name,
          channelDescription: notificationChannel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

Future<void> initializeAppSettings() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await requestNotificationPermission();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  setupForegroundMessageListener();

  if (!kIsWeb) await setupFlutterNotifications();

  // FCM Token'i al
  final firebaseService = FirebaseNotificationService();
  final fcmToken = await FirebaseMessaging.instance.getToken(
    vapidKey: await firebaseService.token,
  );
  debugPrint("FCM Token: $fcmToken");
}

Future<void> runAppropriateScreen() async {
  FlutterNativeSplash.remove();
  final token = Globals.instance.token;

  final isTokenValid = await ElemanyonlendirApi().verifyToken();
  final screen = isTokenValid.contains("success")
      ? Browser(uri: "https://elemanyonlendirapp.top/app/token/$token")
      : Login();
  runApp(screen);
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeAppSettings();
  await runAppropriateScreen();
}
