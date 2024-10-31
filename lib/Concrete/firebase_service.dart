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
    "private_key_id": "2d25d06a84978f915bbd1871c7d741e62f3a7249",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCxlexwsehr3v2k\nCOHPmOT2LUiq0hZKbziP4JDZo1OgSbWeyMiKbMjRzRCkTw7FNBtL1Pqxf72oiRrm\nvsRFPKr7ABZbViQDabehZY/EvuXK4pGtHvJaSD6XQp+rUkiFvlDNANJ7fK9CU87+\n/6MNVU0eXU8sygdmBzssiHb8BepkoUk5hElBu+UszQnJD/VmW/uv2fGCvlCrIC2J\nQQWfXc9uD3BI0MfHuebpHKrRYy4Em8gwEspIjvvZ6ppjX7+m4+3K9VpzRIWyWfvK\nTtBnLauI1nxwR9Stv9NPN7K3APcLzZyDyiFMDCydBBwBvNcM5I0o57dt/bmo3KME\nx0kZO9lVAgMBAAECggEAEnqSyWFB2aOxCfYgpSz4OkOZCallx2YOYS5RdEwiAg5Z\nd0XWVE0gknA/uJE/bLbQ1lG5qmmr7xMhOPyFyNyYwBiQuv1aLv67rHA4hxUELVnp\nJbYQKuPUm4HDwpyDzmLw3nwk6tOdGw5EflVUfqkvJqc3+2WkYnIDLs2eb/gfnUvc\nnCdslo1spjOtG9LZPJNYUNYj/ckkeR3hhATs0ZERCwDxCGkfMLjfd2stC73dsPvg\nzHZBo+xaRTOT43+kAgF0Ed7adgjQvaLKWGvl86o6zmI4DiCKgRez/efDb66Mk1MV\n+NzvoQlIMVSPRW4YQSKQBK88X0MIU59IEA8bBlL1UQKBgQDodCgpRUGuUvSTKBwD\nklQRQGnF//ZC7TxT8Tzc58/m8AlCC4z+xSwLwik1hm+6TFWPuJL/kkQBhGtbWgiS\nZ3RKHkauge1suIQgK0nrRme8naXd+o8Y41lmzpYEuOSWd76+cUAuU2SjNziEKD8C\nkmhpVDNDQNfrJrc7tzzX8udISQKBgQDDkvZArxblbFmDIR0yvJpvp+YprJhoDUXJ\nCu01tLlzJDYxMRPTJsb75PONqLCw0iLndnb8Kdu0K7itmx+sq3nY5KzbeMpyIkOf\ns0gAYRcTZxtHtkkpWCjuXbEKCpMRNL1NTbki7c8TbQMcMfVK0BTmnRSqShzoESEx\nMiF1u3AArQKBgCKz9Kr0o/GagNjXTBdcaSCKNUBSDjm/oRoHEccI9IjNnRQ3FT2T\nwhefTPeoslVlwABM1eVBuNVhJ4Xj0xPIThwimPrEeuWYRmFnFQoC4MnP30tcdLCK\ngHZQsSTTVY0BI4Da93HzETssq0tPltiTcvMGlwCbVaDNjt1jZbn3kX/BAoGBALkW\ncXT//zQ62W/vO9nTgnjfNkUEcewve3brn1jvY37jq2Hcp31yumiT4ieTmTyOcrgJ\ndkvpNWMK6alrIIvicNtid3DxnO5tHQCbxC2PtS4Iq1mv2weExp/oDW+KWGq1Nd5e\nCzNSSmKBDat2YEVgLheeW3tZzoeWBoqvfdkU/ce1AoGBAJba9+R7kblO0h5HP6pa\nINsaOkS+CxxpQnOIt3qxYjnK/TaeHCJTKhYMJry+Ah0aw9ZBMiChiqYrcHW80ajn\npN73hwlMma9Tppm8CZQe4rLYM2zelWD7aR/V8Mz9CcYE/ti+XKSbCLbSCZJs8ACx\nMTnBwcJnVv1c5hg/cQTJ4ZC5\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-yxo0j@elemanyonlendir-6c6b7.iam.gserviceaccount.com",
    "client_id": "107919437583373753398",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
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
    debugPrint("Service Key = ${_accessToken}");
    return _accessToken!;
  }
}
