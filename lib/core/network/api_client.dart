import 'dart:convert';

import 'package:elemanyonlendir/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'apikey': AppConfig.apiKey,
      };

  Uri _uri(String path) => Uri.parse('${AppConfig.baseUrl}$path');

  Future<http.Response> postJson(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    return res;
  }
}
