import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/UI/frmBrowser.dart';
import 'package:elemanyonlendir/UI/frmLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Concrete/Api.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'AIzaSyBb4oB4rWP6vqqYv_Ims8c0vLbePDWe--4',
    appId: '1:542509130475:ios:2e36e31a49b0e4bd5914ae',
    messagingSenderId: '542509130475',
    projectId: 'elemanyonlendir-6c6b7',
  ));
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'AIzaSyBb4oB4rWP6vqqYv_Ims8c0vLbePDWe--4',
    appId: '1:542509130475:ios:2e36e31a49b0e4bd5914ae',
    messagingSenderId: '542509130475',
    projectId: 'elemanyonlendir-6c6b7',
  ));
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Globals.token = prefs.getString("verify_token");
  if (Globals.token != null) {
    ElemanyonlendirApi().verify_token().then((value) => {
          if (!value.contains("success"))
            {
              runApp(Login()),
            }
          else
            {
              runApp(Browser(uri: "https://elemanyonlendirapp.top/app/token/${Globals.token}",)),
            }
        });
  } else {
    runApp(Login());
  }
}
