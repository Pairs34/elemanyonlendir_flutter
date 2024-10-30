class LoginResponseModel {
  final String token;
  final String url;

  // Constructor with required fields
  LoginResponseModel({
    required this.token,
    required this.url,
  });

  // JSON to model conversion
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      url: json['url'] as String,
    );
  }

  // Model to JSON conversion
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'url': url,
    };
  }
}
