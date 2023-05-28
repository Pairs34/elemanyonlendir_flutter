import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/UI/frmBrowser.dart';
import 'package:elemanyonlendir/UI/frmLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elemanyonlendir/Helpers/firebase_options.dart';
import 'Concrete/Api.dart';
import 'package:seq_logger/seq_logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  var notification = message.notification;
  var android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

createLogger() {
  Logger.root.level = Level.ALL;

  LogzIoApiAppender(
    apiToken: "wthEBCBLNTGWaWUYZWjxwnfiLCuwQXQA",
    url: "https://listener.logz.io:8071/",
    labels: {
      "version": "1.0.0", // dynamically later on
      "build": "2" // dynamically later on
    },
  )..attachToLogger(Logger.root);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  createLogger();

  final _logger = Logger('com.mysgrup.cleanermy');

  _logger.info("Start init");

  _logger.info("Firebase init");
  await Firebase.initializeApp(name: "CleanerMy",options: DefaultFirebaseOptions.currentPlatform);
  _logger.info("Firebase init end");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  _logger.info("Firebase token init");

  String? fcmToken = "";

  try{
    fcmToken = await FirebaseMessaging.instance.getToken();
  }catch(e, s){
    _logger.warning("Token alınırken hata oluştu", [
      e,s
    ]);
  }

  _logger.info("Firebase token end $fcmToken");

  print("FCM Token");
  print(fcmToken);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  Globals.token = prefs.getString("verify_token");
  if (Globals.token != null){
    ElemanyonlendirApi().verify_token().then((value) => {
          if (!value.contains("success"))
            {
              runApp(Login()),
            }
          else
            {
              runApp(Browser(
                uri: "https://app.cleanermy.com/app/token/${Globals.token}",
              )),
            }
        });
  } else {
    runApp(Login());
  }
}
