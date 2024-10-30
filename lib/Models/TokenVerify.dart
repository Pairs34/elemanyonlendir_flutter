class LoginRequest {
  final String username;
  final String password;
  final String pushToken;

  LoginRequest({
    required this.username,
    required this.password,
    required this.pushToken,
  });
}
