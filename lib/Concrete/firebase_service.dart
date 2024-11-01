import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class FirebaseNotificationService {
  // Singleton için tek örnek
  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();

  // Private Constructor
  FirebaseNotificationService._internal();

  // Singleton instance alma
  factory FirebaseNotificationService() {
    return _instance;
  }

  // Servis hesabı JSON dosyası
  final Map<String, dynamic> serviceAccountJson = {
    "type": "service_account",
    "project_id": "elemanyonlendir-6c6b7",
    "private_key_id": "14acf23135cc0f26d7ae91cd389a5ac07217b188",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCLX11Y5MBteRcr\nLeo0NsegQCUg5I+thWqodsiRtzM9zx3H9W+7Ge3sgXjMRHyLMMUgQg1R4CkwTBhd\nY1ZyI/8UH9kMTYsev6IYrAuW2aWahYNr7WF/SW3nZsr0Y2elO55bVBlJe3kfpODQ\nenkddsox7AbiNEz0PLKaWuV660ls86BKI2RDETMmu2+1as2vTBiX72QS8mGXqu5w\nsNBlczKXC/PbJt6UsKfIaH3C2xWU6Y93h0Ly2U17C9hfYyfe1jr+CpBS8cZc5DeA\nTktTm1FQmQABznCXnMhhzSV+TP8vk5p2jmvGcqz0RJHgYTSykvnM0xH9xaup+3To\nWvWGZ6JTAgMBAAECggEAFRBYf9RcFCTZGxCz6lNIerrnFvW5lJyVi5jJjw2fRB1W\n32nZNUUMdTz2IE0jfjfkkGUF3/90dNUIrlM9SpU6enSmbZpp8b+TBI6QASsAwSii\nPaq2nFxhLLgXlAr9VvbP4/attweJvVNtGiUVw/MNnluRM257HkNELQRFgCfU748Y\nv9nlyoxcCMNOxg+tu5gIE2i1Ox832s3oWk+wDfnGzvSAP/24+ViVYICXux8aCoEO\nFc3jG8DgB4iK/tZxcYvd/4olA6SVQlepxC7vUbUmyWz77sMzllosVC4T+8WR5Oyh\nG155QhEx2kB1ROOAdQzbCynf6b/RXQmuRRxchiOddQKBgQDAEMWAr2zdU3CAgtFd\nZlUeX7s7oQZkhQoW5OYDDQwKGT0ySk76bckXhrbQq6Ys3Sshs3jMnRnLQAx0OmGt\nd/vdHhN5fM5WO6/RnOWwFyubmGsgy3cRxkYZDbpcLL+v2VEWQQSFJQ4NGEq+6xQD\nB5+zuXtQ7Rhcd0KXCVZ6s+F4RQKBgQC5xEJZyN9DDcBzYsyMzr/kFpwNBKnjWv6Z\nNWNZNxVQWlSSl0izfsMaHMufrxlg/3Jbg3xA/VM8qOfdxkKmbAo9qzxYrQuN92wg\nsarLJYHn0eJ2G4o0ZP1pm8A/VLDeosEyAY5Y8RlUH5S1tFxg0W5gKqQHJuK4sTK/\nkV5WojkVtwKBgDTJZz7C+AysThND4P7mjSZX8UGmM/eUiP1Z082q3FA6N5OG0MYL\nPmV05PHc+0MBVkVg6iZyVxCBferD0Oy4OUTAa2HMZ3lT1jKqCIapF5cgAPF2ejcs\nYz+ngjyrH9PYymxvWiqt0HrQ3loyicF7au0eYUIQp81iCa8xJc97eNBxAoGAcpVD\n9+2XCN0qoAGI+jFs21u21bDSuZIfCJGNvjHjy7RsBh+akFzYKvsn/k8a8GGgQCJS\nOiQHe5sTqg/ofI6XooJErs3OGrtKzr/IAZYZEsy7Su6hyL+iL8oKQwYSMsFhOV8M\nVoAgh2sTZyDg+jc0Rc0HcAHkRtfF3bPk5LsbSvECgYBEN5BzKu9U7WXMdf+v6/pu\nuvGSgqSoDjrJWHHHeLYhWZyOG/9/oHfjPhNJfHjTtYEmKTbDUzqsP8fGv4OzY8GZ\naXE4jBZOynoCYTBDHmrgMoT8raqz2NuglxLyBGL+4qLG+F40t6hRO+9Sx1LFJafp\nF74nGeJXjcLomZ12RC6PLA==\n-----END PRIVATE KEY-----\n",
    "client_email": "elemanyonlendir-6c6b7@appspot.gserviceaccount.com",
    "client_id": "",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/elemanyonlendir-6c6b7%40appspot.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  // FCM erişim için kapsam
  final List<String> scopes = [
    "https://www.googleapis.com/auth/firebase.messaging",
  ];

  // Erişim token
  String? _accessToken;

  // Erişim token alma metodu
  Future<String> get token async {
    if (_accessToken == null) {
      final client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );

      _accessToken = credentials.accessToken.data;
      client.close();
    }
    debugPrint("Service Key = ${_accessToken}");
    return _accessToken!;
  }
}
