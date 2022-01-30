import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/UI/frmBrowser.dart';
import 'package:elemanyonlendir/UI/frmLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Concrete/Api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCLL-ZWZ4maiDatWst7msWR4yxujfqqdhs',
    appId: '1:366720337902:android:461d20e63818b1507330ff',
    messagingSenderId: '366720337902',
    projectId: 'cilingirbul-99c89',
  ));

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
              runApp(Browser(
                uri:
                    "https://uygulama.çilingirbul.com/app/token/${Globals.token}",
              )),
            }
        });
  } else {
    runApp(Login());
  }
}
