import 'dart:convert';

import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/Models/LoginResponseModel.dart';
import 'package:elemanyonlendir/Models/TokenVerify.dart';
import 'package:http/http.dart' as http;

class ElemanyonlendirApi {
  String base_uri = "https://elemanyonlendirapp.top";

  Future<String> verify_token() async {
    print("Verify Token = ${Globals.token}");
    var response = await http.post(Uri.parse(base_uri + "/verifytoken"),
        body: jsonEncode({"token": Globals.token}),
        headers: {
          "Content-Type": "application/json",
          "apikey":
              "2f1d026c5ba58d64e67d81cb7bd581d2064d50b5131f172271761735ed850c74"
        });

    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future<LoginResponseModel> do_login({LoginRequest loginRequest}) async {
    var response = await http.post(Uri.parse(base_uri + "/start"),
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
      Map responseDecoded = jsonDecode(response.body);
      return LoginResponseModel(
          token: responseDecoded["token"], url: responseDecoded["url"]);
    }
  }
}
