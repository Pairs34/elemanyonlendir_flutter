import 'dart:io' show Platform;
import 'package:elemanyonlendir/Concrete/Api.dart';
import 'package:elemanyonlendir/UI/frmLogin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

class Browser extends StatelessWidget {
  final String uri;

  const Browser({Key? key, required this.uri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BrowserPage(url: uri),
    );
  }
}

class BrowserPage extends StatefulWidget {
  final String url;

  const BrowserPage({Key? key, required this.url}) : super(key: key);

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> with WidgetsBindingObserver {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initializeWebViewController();
    _requestPermissionsForIOS();
    _initializeFirebaseMessaging();
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) => debugPrint("Page loaded: $url"),
          onWebResourceError: (error) =>
              debugPrint("Error loading page: ${error.description}"),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _requestPermissionsForIOS() {
    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification != null) {
        _showNotification(notification);
      }
    });
  }

  void _showNotification(RemoteNotification notification) {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();
    final initSettings =
        InitializationSettings(android: androidInit, iOS: iOSInit);

    flutterLocalNotificationsPlugin.initialize(initSettings).then((_) {
      flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _verifyToken();
    }
  }

  Future<void> _verifyToken() async {
    try {
      final result = await ElemanyonlendirApi().verifyToken();
      if (!result.contains("success")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } catch (e) {
      debugPrint("Token verification failed: $e");
      // İsteğe bağlı: Hata durumunda kullanıcıya bildirimde bulunabilirsiniz.
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
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
