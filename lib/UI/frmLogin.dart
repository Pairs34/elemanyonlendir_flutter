import 'package:elemanyonlendir/Concrete/Api.dart';
import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/Models/TokenVerify.dart';
import 'package:elemanyonlendir/UI/frmBrowser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  var usernameController =
      MaskedTextController(mask: "00000000000", text: "05xxxxxxxxx");
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F75621"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset("assets/images/login_logo.png"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: "Telefon Numaranız",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        decorationStyle: TextDecorationStyle.wavy),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: '05xxxxxxxxx'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TextField(
                obscureText: true,
                obscuringCharacter: "*",
                controller: passController,
                decoration: InputDecoration(
                    labelText: "Parola",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        decorationStyle: TextDecorationStyle.wavy),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Parola giriniz'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      onPressed: () => {
                        if (usernameController.text.isNotEmpty &
                            passController.text.isNotEmpty)
                          {login2web()}
                      },
                      child: Text("GİRİŞ"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Map<dynamic, dynamic>> login2web() async {
    String token = await FirebaseMessaging.instance.getToken();
    print("Token from firebase = $token");
    ElemanyonlendirApi()
        .do_login(
          loginRequest: LoginRequest(
              username: usernameController.text,
              password: passController.text,
              push_token: token),
        )
        .then((value) => {
              if (value != null)
                {
                  Globals.token = value.token,
                  saveTokenToSharedPreference(value.token),
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => new BrowserPage(
                        url: value.url,
                      ),
                    ),
                  )
                }
              else
                {showAlertDialog(context)}
            });
  }

  saveTokenToSharedPreference(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("verify_token", token);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Tamam"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hata"),
      content: Text("Giriş bilgileri hatalı"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
