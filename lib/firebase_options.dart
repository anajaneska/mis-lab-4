// File generated by FlutterFire CLI.
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
        return windows;
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
    apiKey: 'AIzaSyBycW1Ss1aGuuZv6iLqvCmIOWNMQW2e4oE',
    appId: '1:512571514486:web:0662d56dba24f401470957',
    messagingSenderId: '512571514486',
    projectId: 'exam-schedule-a3384',
    authDomain: 'exam-schedule-a3384.firebaseapp.com',
    storageBucket: 'exam-schedule-a3384.firebasestorage.app',
    measurementId: 'G-1B9H5F1E2Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB12F9r2MjETB4QLxkJ7MGCiAtET_SxmUg',
    appId: '1:512571514486:android:b3f0d046ef18e88f470957',
    messagingSenderId: '512571514486',
    projectId: 'exam-schedule-a3384',
    storageBucket: 'exam-schedule-a3384.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDVNwDlIB0zILdMK49BxV0M0rbURZkPv4',
    appId: '1:512571514486:ios:7e5fefc2cb5b2014470957',
    messagingSenderId: '512571514486',
    projectId: 'exam-schedule-a3384',
    storageBucket: 'exam-schedule-a3384.firebasestorage.app',
    iosBundleId: 'mk.ukim.finki.examSchedule',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDVNwDlIB0zILdMK49BxV0M0rbURZkPv4',
    appId: '1:512571514486:ios:7e5fefc2cb5b2014470957',
    messagingSenderId: '512571514486',
    projectId: 'exam-schedule-a3384',
    storageBucket: 'exam-schedule-a3384.firebasestorage.app',
    iosBundleId: 'mk.ukim.finki.examSchedule',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBycW1Ss1aGuuZv6iLqvCmIOWNMQW2e4oE',
    appId: '1:512571514486:web:d6626ac871cd5af1470957',
    messagingSenderId: '512571514486',
    projectId: 'exam-schedule-a3384',
    authDomain: 'exam-schedule-a3384.firebaseapp.com',
    storageBucket: 'exam-schedule-a3384.firebasestorage.app',
    measurementId: 'G-W20TMJJ7XC',
  );
}