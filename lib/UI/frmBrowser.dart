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
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

class Browser extends StatelessWidget {
  final String uri;

  Browser({this.uri});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BrowserPage(url: uri,),
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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      var androidInit = AndroidInitializationSettings('app_icon');
      var iOSInit = IOSInitializationSettings();
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
                  channel.description,
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
      ElemanyonlendirApi().verify_token().then((value) => {
          if(!value.contains("success"))
          {
            Navigator.pushReplacement(context,
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
      color: HexColor("#F75621"),
      child: SafeArea(
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }
}
