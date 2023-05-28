class LoginRequest {
  String username;
  String password;
  String push_token;

  LoginRequest({required this.username,required this.push_token,required this.password});
}