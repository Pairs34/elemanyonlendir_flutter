// ignore_for_file: must_be_immutable, non_constant_identifier_names, missing_return, unused_local_variable

import 'package:cilingirbul/Helpers/Globals.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'frmLogin.dart';

class Register extends StatelessWidget {
  final String uri;

  Register({this.uri});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(
        url: uri,
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  String url;

  RegisterPage({Key key, this.url}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
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
    if (request.url.contains("dashboard")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => new Login(),
        ),
      );
    }

    return NavigationDecision.navigate;
  }
}
