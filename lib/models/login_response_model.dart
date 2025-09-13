class LoginResponseModel {
  final String token;
  final String url;

  LoginResponseModel({
    required this.token,
    required this.url,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'url': url,
    };
  }
}
