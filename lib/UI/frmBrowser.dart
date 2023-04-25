import 'dart:io' show Platform;
import 'package:elemanyonlendir/Concrete/Api.dart';
import 'package:elemanyonlendir/UI/frmLogin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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
      var iOSInit = DarwinInitializationSettings();
      var init = InitializationSettings(android: androidInit, iOS: iOSInit);
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
                iOS: DarwinNotificationDetails(),
              ),
            )
          });
    });

    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.contains('logout')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => new Login(),
            ),
          );

          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    )
    )..loadRequest(Uri.parse(widget.url));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ElemanyonlendirApi().verify_token().then((value) => {
            if (!value.contains("success"))
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => new Login(),
                  ),
                )
              }
          });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#fb2252"),
      child: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
