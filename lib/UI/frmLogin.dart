import 'package:elemanyonlendir/Concrete/Api.dart';
import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/Models/TokenVerify.dart';
import 'package:elemanyonlendir/UI/frmBrowser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hexcolor/hexcolor.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#fb2252"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset("assets/images/login_page.png"),
            ),
            _buildTextField(
              controller: usernameController,
              label: "Telefon Numaranız",
              hintText: '05xxxxxxxxx',
            ),
            _buildTextField(
              controller: passController,
              label: "Parola",
              hintText: 'Parola giriniz',
              obscureText: true,
            ),
            _buildButtons(context),
          ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          labelText: label,
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(
              color: Colors.black, decorationStyle: TextDecorationStyle.wavy),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        _buildButton(
          text: "GİRİŞ",
          onPressed: () async {
            if (usernameController.text.isNotEmpty &&
                passController.text.isNotEmpty) {
              await login2web(context);
            } else {
              showAlertDialog(context);
            }
          },
        ),
        _buildButton(
          text: "Kayıt Ol",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BrowserPage(
                url: "https://benimtemizlikcim.com/temizlikci-kayit",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }

  Future<void> login2web(BuildContext context) async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM Token = $token");

    try {
      final loginResult = await ElemanyonlendirApi().doLogin(
        loginRequest: LoginRequest(
          username: usernameController.text,
          password: passController.text,
          pushToken: token ?? '',
        ),
      );

      // Token'ı güvenli saklama alanına kaydedin
      await Globals.instance.setToken(loginResult.token);

      // Kullanıcı tarayıcıya yönlendiriliyor
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
        title: Text("Hata"),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Tamam"),
          ),
        ],
      ),
    );
  }
}
