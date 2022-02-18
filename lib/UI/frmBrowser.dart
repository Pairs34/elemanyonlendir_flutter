// ignore_for_file: must_be_immutable, non_constant_identifier_names, missing_return, unused_local_variable

import 'dart:io' show Platform;
import 'package:cilingirbul/Concrete/Api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'frmLogin.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title description
  importance: Importance.high,
);

class Browser extends StatelessWidget {
  final String uri;

  Browser({this.uri});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BrowserPage(
        url: uri,
      ),
    );
  }
}

class BrowserPage extends StatefulWidget {
  String url;

  BrowserPage({Key key, this.url}) : super(key: key);

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }

    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          .requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      var iOSInit = IOSInitializationSettings();
      var init = InitializationSettings(android: androidInit, iOS: iOSInit);
      print("Bildiri badisi = " + notification.body);
      flutterLocalNotificationsPlugin.initialize(init).then((done) => {
            flutterLocalNotificationsPlugin.show(
              0,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: 'launch_background',
                ),
                iOS: IOSNotificationDetails(),
              ),
            )
          });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      cilingirbulApi().verify_token().then((value) => {
            if (!value.contains("success")) {GotoLogin()}
          });
    }
  }

  Future<dynamic> GotoLogin() {
    ClearSavedToken();
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => new Login(),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#F75621"),
      child: SafeArea(
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          navigationDelegate: NavigatingDetect,
        ),
      ),
    );
  }

  NavigationDecision NavigatingDetect(NavigationRequest request) {
    print(request.url);
    if (request.url.contains("logout")) {
      GotoLogin();
    }

    return NavigationDecision.navigate;
  }

  void ClearSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
