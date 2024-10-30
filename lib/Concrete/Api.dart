import 'dart:convert';
import 'package:elemanyonlendir/Helpers/Globals.dart';
import 'package:elemanyonlendir/Models/LoginResponseModel.dart';
import 'package:elemanyonlendir/Models/TokenVerify.dart';
import 'package:http/http.dart' as http;

class ElemanyonlendirApi {
  final String _baseUri = "https://elemanyonlendirapp.top";
  final String _apiKey = "2f1d026c5ba58d64e67d81cb7bd581d2064d50b5131f172271761735ed850c74";

  // Common headers for all requests
  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "apikey": _apiKey,
      };

  Future<String> verifyToken() async {
    final token = await Globals.instance.token;
    if (token == null || token.isEmpty) {
      throw Exception("Token is not available");
    }

    final response = await http.post(
      Uri.parse("$_baseUri/verifytoken"),
      body: jsonEncode({"token": token}),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to verify token: ${response.statusCode}");
    }
  }

  Future<LoginResponseModel> doLogin({required LoginRequest loginRequest}) async {
    final response = await http.post(
      Uri.parse("$_baseUri/start"),
      body: jsonEncode({
        "username": loginRequest.username,
        "password": loginRequest.password,
        "push_token": loginRequest.pushToken,
      }),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseDecoded = jsonDecode(response.body);
      return LoginResponseModel.fromJson(responseDecoded);
    } else {
      throw Exception("Failed to login: ${response.statusCode}");
    }
  }
}
