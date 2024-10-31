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
    "private_key_id": "d190314a52ce6c4c06a1384f383cf0c7343ad67e",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCft0c8xb50ZrlF\nsb3GlAEVIsuOa0+BmsEh3bwHHMU4RaKe4ru/PdA6XVA/xX8cvfMH7saTOcopzkdw\np6ZhmqaCZX7nldq7SS8p9nopCji5Uv9D4ufmynoJFEWv8aw1UftWSnn2cEc5HUXu\nNPJiaHyWHGfrCOzAtY5i04h/5aXTJ1jX98piuuWRV+cZjimSpfZ/NAefcGj3mL4V\nw+dQ/RElgnHcxr+PopzAh688UH6FZoipKMIoE3f5NNxDhT9K8vZszVASSfceY9HQ\n8sFYHJjhEFbl2kJw4t7tCGa93xYvg/0nkyN3VWpuR5PLAU7FTfyAGQttoxetayz7\nfJkQtWeZAgMBAAECggEAA+lUKEvbdzRQ00EgGa3kPOVGQO2l29GzayXoBfCRb+hc\nrDF3UZ6s69D/NyCaFVUdj5Msb8yZg96WZ07jxz4nV8gujHNiEPYg3pE3uquSag97\nSulSrpdE19YUQtPTWNbyJdHbHMrxI5fw732CdiCC9JYrgVkNm0aW/xqZHDC+l+Yz\n1lbHVenn9mYuzb2X2vSQ7AdjHYnx/+6bLd8n88WS65WJeM3iGB/u/WziP3ZcuGTF\n0JQcjr/IUIs6zF1CGTA5NAsuuV5u7hiWFIJ6Z59ynzNfK+cV7Kd5C7B+cASrSjL7\naGJsTCBiqC+1kWcD2vtu0j2HbNpS/8qJRQZEkxKDhQKBgQDe2jbaOHDd0MKgaWL6\ng73j9EdOZaCHmeN67VK8kNefq+Ye4QtyGd+URXL029gu0tUPWZN4LgEjhyTsARBt\nLORh2vzHhp1M7SKi0/cfXCg8GAObp4LBTiduFuYDT0zHm0qpW5XiYh1Y/5hDwtxt\nWvp3NC1zIF1lOZbczkAJit2CTwKBgQC3ePM7qJNrtghnZe/p6BSXyoQ6HWk8JFmw\n0Z6nLF0ojsBc0Wg37RCIWALBqKB6AR+3TQr6ug6mskErf9r8yufCTc4tirE+IBsI\n2h9f7zfK5cLSpX+RIJhl9ufUwX7Mcl3Boou9aA0Jho037eSPbpY5RDVWhruXo0aB\nsTfW7N4FlwKBgCnN+Zg6GkIiFUCORHkGGasXegDk45ZMcfXvayPgb/KOBp8oTENd\nQynHVWdFjmpKNpmojhdvWdtWUMDM+k3gq/8HW3/6aquxmFu/M454dTvArXyXkdm9\nVXw7Y26fg6G2Ke1XNui+yw6U8/VSKpOBC5cs/JGqMpr4kKpfLngbyq3VAoGBAIFu\n6FlcEbRZFRCsz1X6jhyPmDzPZuAw3L1rBDv3hjkIjBhu+tEJgzJMtJUeeyfXByLv\nTSGYhKGA+4zOhBT2qA1himSChYvIZooWJzAsuPWApbKpYpdloV29k8t6PhPJUu85\n1s9mSlw/+fxM7YNqhrwbrG1AW7McUq9H8JbFP9Q9AoGAPWy0gpdENX70R+2Dcf5k\nk4QahUgrnUWwwIpJcutk+B4+kyU6hOfRR+7u04iK1Dufc4powuVhyzX9k1XIszm2\nFCdFyRNYqHBJTo5X+u3Y6/k5aNslZxXbIXcMil3Yl10pLm9+yFxbRKNvG9hz0cDy\nyLWbCXXY7ekVo6tOhtyzmRI=\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-yxo0j@elemanyonlendir-6c6b7.iam.gserviceaccount.com",
    "client_id": "107919437583373753398",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url":
        "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-yxo0j%40elemanyonlendir-6c6b7.iam.gserviceaccount.com",
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

    return _accessToken!;
  }
}
