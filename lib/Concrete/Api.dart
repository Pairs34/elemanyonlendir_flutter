// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/Models/LoginResponseModel.dart';
import 'package:elemanyonlendir/Models/TokenVerify.dart';
import 'package:http/http.dart' as http;

class ElemanyonlendirApi {
  String baseUri = "http://uygulama.xn--ilingirbul-n6a.com";

  Future<String> verify_token() async {
    print("Verify Token = ${Globals.token}");
    var response = await http.post(Uri.parse(baseUri + "/verifytoken"),
        body: jsonEncode({"token": Globals.token}),
        headers: {
          "Content-Type": "application/json",
          "apikey":
              "2f1d026c5ba58d64e67d81cb7bd581d2064d50b5131f172271761735ed850c74"
        });

    if (response.statusCode == 200) {
      print("Verify Token Result = " + response.body);
      return response.body;
    } else {
      return "";
    }
  }

  Future<LoginResponseModel> do_login({LoginRequest loginRequest}) async {
    var response = await http.post(Uri.parse(baseUri + "/start"),
        body: jsonEncode({
          "username": loginRequest.username,
          "password": loginRequest.password,
          "push_token": loginRequest.push_token
        }),
        headers: {
          "Content-Type": "application/json",
          "apikey":
              "2f1d026c5ba58d64e67d81cb7bd581d2064d50b5131f172271761735ed850c74"
        });

    if (response.statusCode == 200) {
      print("Login Result = " + response.body);
      Map responseDecoded = jsonDecode(response.body);
      return LoginResponseModel(
          token: responseDecoded["token"], url: responseDecoded["url"]);
    } else {
      return null;
    }
  }
}
