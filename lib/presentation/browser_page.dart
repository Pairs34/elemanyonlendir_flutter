import 'package:elemanyonlendir/core/notifications/notification_service.dart';
import 'package:elemanyonlendir/data/api/api_service.dart';
import 'package:elemanyonlendir/presentation/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    NotificationService.instance.requestPermissionsIfNeeded();
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((message) {
      NotificationService.instance.showFirebaseMessage(message);
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
      final result = await ApiService().verifyToken();
      if (!result.contains("success")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      debugPrint("Token verification failed: $e");
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
