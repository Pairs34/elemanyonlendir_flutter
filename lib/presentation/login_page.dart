import 'dart:io' show Platform;
import 'package:elemanyonlendir/core/config/app_config.dart';
import 'package:elemanyonlendir/core/notifications/notification_service.dart';
import 'package:elemanyonlendir/core/storage/auth_storage.dart';
import 'package:elemanyonlendir/data/api/api_service.dart';
import 'package:elemanyonlendir/models/login_request.dart';
import 'package:elemanyonlendir/presentation/browser_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final usernameController =
      MaskedTextController(mask: "00000000000", text: "05xxxxxxxxx");
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HexColor("#FF6B3D"),
              HexColor("#FF5722"),
              HexColor("#E64A19"),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  // Logo
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/login_page.png",
                      height: 120,
                    ),
                  ),
                  SizedBox(height: 50),
                  // Login Card
                  Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hoş Geldiniz',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: HexColor("#FF5722"),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Devam etmek için giriş yapın',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildTextField(
                          controller: usernameController,
                          label: "Telefon",
                          hintText: '05xxxxxxxxx',
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: passController,
                          label: "Şifre",
                          hintText: '••••••••',
                          obscureText: true,
                        ),
                        SizedBox(height: 12),
                        _buildForgotPasswordLink(context),
                        SizedBox(height: 24),
                        _buildButtons(context),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool obscureText = false,
  }) {
    final isPhone = label.contains('Telefon');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            obscuringCharacter: "•",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              letterSpacing: obscureText ? 2 : 0.3,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  isPhone ? Icons.smartphone_rounded : Icons.lock_rounded,
                  color: HexColor("#FF5722"),
                  size: 20,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 44,
                minHeight: 24,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BrowserPage(
                url: "https://elemanyonlendirapp.top/app/forgot_password",
                showBackButton: true,
              ),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          minimumSize: Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Şifremi Unuttum',
          style: TextStyle(
            color: HexColor("#FF5722"),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Giriş Butonu
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () async {
              if (usernameController.text.isNotEmpty &&
                  passController.text.isNotEmpty) {
                await login2web(context);
              } else {
                showAlertDialog(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HexColor("#FF5722"),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Giriş Yap',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        // Kayıt Ol Butonu
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrowserPage(
                  url: AppConfig.registrationUrl,
                  showBackButton: true,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: HexColor("#FF5722"),
              side: BorderSide(
                color: HexColor("#FF5722"),
                width: 1.5,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Kayıt Ol',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> login2web(BuildContext context) async {
    String? token;

    try {
      // iOS için APNS token'ı almaya çalış - birkaç deneme yap
      if (Platform.isIOS) {
        for (int i = 0; i < 3; i++) {
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null) {
            debugPrint("✅ APNS Token alındı (deneme ${i + 1})");
            break;
          }
          debugPrint("⏳ APNS Token bekleniyor (deneme ${i + 1})...");
          await Future.delayed(Duration(milliseconds: 800));
        }
      }

      // FCM token alma - birkaç deneme yap
      for (int i = 0; i < 3; i++) {
        token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) {
          debugPrint("✅ FCM Token alındı: $token");
          break;
        }
        debugPrint("⏳ FCM Token bekleniyor (deneme ${i + 1})...");
        await Future.delayed(Duration(milliseconds: 800));
      }

      // Token alınamadıysa hata göster
      if (token == null || token.isEmpty) {
        showAlertDialog(context,
            message:
                "Bildirim token'ı alınamadı. Lütfen uygulama ayarlarından bildirimlere izin verdiğinizden emin olun ve tekrar deneyin.");
        return;
      }
    } catch (e) {
      debugPrint("❌ FCM Token error: $e");
      showAlertDialog(context,
          message:
              "Bildirim servisi başlatılamadı. Lütfen uygulama ayarlarından bildirimlere izin verin ve tekrar deneyin.");
      return;
    }

    try {
      final loginResult = await ApiService().doLogin(
        loginRequest: LoginRequest(
          username: usernameController.text,
          password: passController.text,
          pushToken: token,
        ),
      );

      await AuthStorage.instance.setToken(loginResult.token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BrowserPage(url: loginResult.url),
        ),
      );
    } catch (e) {
      debugPrint("Login failed: $e");
      showAlertDialog(context,
          message: "Giriş başarısız. Lütfen tekrar deneyin.");
    }
  }

  void showAlertDialog(BuildContext context,
      {String message = "Giriş bilgileri hatalı"}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HexColor("#FF5722").withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: HexColor("#FF5722"),
                size: 32,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Hata',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("#FF5722"),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Tamam',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
