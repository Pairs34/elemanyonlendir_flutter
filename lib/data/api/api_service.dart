import 'dart:convert';
import 'package:elemanyonlendir/core/storage/auth_storage.dart';
import 'package:elemanyonlendir/models/login_response_model.dart';
import 'package:elemanyonlendir/models/login_request.dart';
import 'package:elemanyonlendir/core/network/api_client.dart';

class ApiService {
  Future<String> verifyToken() async {
    final token = await AuthStorage.instance.getToken();
    if (token == null || token.isEmpty) {
      return "no_token";
    }

    final response = await ApiClient.instance.postJson(
      "/verifytoken",
      {"token": token},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "no_token";
    }
  }

  Future<LoginResponseModel> doLogin(
      {required LoginRequest loginRequest}) async {
    final response = await ApiClient.instance.postJson(
      "/start",
      {
        "username": loginRequest.username,
        "password": loginRequest.password,
        "push_token": loginRequest.pushToken,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseDecoded = jsonDecode(response.body);
      return LoginResponseModel.fromJson(responseDecoded);
    } else {
      throw Exception("Failed to login: ${response.statusCode}");
    }
  }
}
