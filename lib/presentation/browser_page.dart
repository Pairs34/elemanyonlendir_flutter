import 'package:elemanyonlendir/core/notifications/notification_service.dart';
import 'package:elemanyonlendir/core/storage/auth_storage.dart';
import 'package:elemanyonlendir/data/api/api_service.dart';
import 'package:elemanyonlendir/presentation/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatefulWidget {
  final String url;
  final bool showBackButton;

  const BrowserPage({
    Key? key,
    required this.url,
    this.showBackButton = false,
  }) : super(key: key);

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
      ..addJavaScriptChannel(
        'FlutterApp',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint("📱 JavaScript mesajı alındı: ${message.message}");
          if (message.message == 'logout') {
            _handleLogout();
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            debugPrint("Page loaded: $url");
            // Logout event listener'ı ekle
            _injectLogoutListener();
            // "Parolamı Unuttum" sayfasında toolbar'ı gizle
            if (url.contains('/app/forgot_password')) {
              _hideToolbar();
            }
          },
          onWebResourceError: (error) =>
              debugPrint("Error loading page: ${error.description}"),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _hideToolbar() {
    _controller.runJavaScript('''
      (function() {
        // toolbar-bottom-md class'ına sahip toolbar'ı gizle
        var toolbars = document.querySelectorAll('.toolbar-bottom-md');
        toolbars.forEach(function(toolbar) {
          toolbar.style.display = 'none';
        });
        
        // Alternatif olarak tüm toolbar elementlerini gizle
        var allToolbars = document.querySelectorAll('.toolbar');
        allToolbars.forEach(function(toolbar) {
          toolbar.style.display = 'none';
        });
        
        // Navbar'ı da gizle
        var navbars = document.querySelectorAll('.navbar');
        navbars.forEach(function(navbar) {
          navbar.style.display = 'none';
        });
      })();
    ''');
  }

  void _injectLogoutListener() {
    _controller.runJavaScript('''
      (function() {
        // Logout API çağrısını intercept et
        var originalFetch = window.fetch;
        window.fetch = function() {
          var args = arguments;
          var url = args[0];
          
          // Logout API çağrısını yakala
          if (url && url.toString().includes('/api/logout/')) {
            console.log('🚪 Logout API çağrısı yakalandı');
            // Flutter'a logout mesajı gönder
            if (window.FlutterApp) {
              window.FlutterApp.postMessage('logout');
            }
          }
          
          return originalFetch.apply(this, args);
        };
        
        // XMLHttpRequest için de dinle
        var originalOpen = XMLHttpRequest.prototype.open;
        XMLHttpRequest.prototype.open = function(method, url) {
          if (url && url.toString().includes('/api/logout/')) {
            console.log('🚪 Logout XHR çağrısı yakalandı');
            if (window.FlutterApp) {
              window.FlutterApp.postMessage('logout');
            }
          }
          return originalOpen.apply(this, arguments);
        };
        
        console.log('✅ Logout listener eklendi');
      })();
    ''');
  }

  Future<void> _handleLogout() async {
    debugPrint("🚪 Logout işlemi başlatılıyor...");

    // Token'ı temizle
    await AuthStorage.instance.clearToken();
    debugPrint("✅ Token temizlendi");

    // Login sayfasına yönlendir
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false, // Tüm önceki sayfaları temizle
      );
    }
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

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isForgotPasswordPage = widget.url.contains('/app/forgot_password');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: HexColor("#F75621"),
        appBar: (widget.showBackButton || isForgotPasswordPage)
            ? AppBar(
                backgroundColor: HexColor("#F75621"),
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Geri',
                ),
                title: isForgotPasswordPage
                    ? Text(
                        'Parolamı Unuttum',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    : null,
              )
            : null,
        body: SafeArea(
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
