// File generated for FlutterFire CLI template.
// Running `flutterfire configure` will update this file with your project's live credentials.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyCA7_0oCFNbwQLlzEA9XgLxtAGZdK-msFQ',
    appId: '1:570831339769:web:594df89ce062124522e228',
    messagingSenderId: '570831339769',
    projectId: 'auratrade-p93c',
    authDomain: 'auratrade-p93c.firebaseapp.com',
    storageBucket: 'auratrade-p93c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCA7_0oCFNbwQLlzEA9XgLxtAGZdK-msFQ',
    appId: '1:570831339769:android:810bbf41bb58553722e228',
    messagingSenderId: '570831339769',
    projectId: 'auratrade-p93c',
    storageBucket: 'auratrade-p93c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAIGBC-BJ_Xn_pRDawtTcBppEzj0DttIc',
    appId: '1:570831339769:ios:da1081d0f84801b922e228',
    messagingSenderId: '570831339769',
    projectId: 'auratrade-p93c',
    storageBucket: 'auratrade-p93c.firebasestorage.app',
    iosBundleId: 'com.example.ipamMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBAIGBC-BJ_Xn_pRDawtTcBppEzj0DttIc',
    appId: '1:570831339769:ios:da1081d0f84801b922e228',
    messagingSenderId: '570831339769',
    projectId: 'auratrade-p93c',
    storageBucket: 'auratrade-p93c.firebasestorage.app',
    iosBundleId: 'com.example.ipamMobile',
  );
}
