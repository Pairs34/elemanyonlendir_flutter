import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDo8M7-30gFnp-d6lMt5-oAsO2_w66tyCQ',
    appId: '1:542509130475:android:75fd77d7da0dba505914ae',
    messagingSenderId: '542509130475',
    projectId: 'elemanyonlendir-6c6b7',
    databaseURL: '',
    storageBucket: '',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDo8M7-30gFnp-d6lMt5-oAsO2_w66tyCQ',
    appId: '1:542509130475:android:75fd77d7da0dba505914ae',
    messagingSenderId: '542509130475',
    projectId: 'elemanyonlendir-6c6b7',
    databaseURL: '',
    storageBucket: '',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDo8M7-30gFnp-d6lMt5-oAsO2_w66tyCQ',
    appId: '1:542509130475:android:75fd77d7da0dba505914ae',
    messagingSenderId: '542509130475',
    projectId: 'elemanyonlendir-6c6b7',
    databaseURL: '',
    storageBucket: '',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDo8M7-30gFnp-d6lMt5-oAsO2_w66tyCQ',
    appId: '1:542509130475:android:75fd77d7da0dba505914ae',
    messagingSenderId: '542509130475',
    projectId: 'elemanyonlendir-6c6b7',
    databaseURL: '',
    storageBucket: '',
  );
}
