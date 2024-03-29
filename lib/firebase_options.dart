// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyCmeROfo3p3dz4hsZIahupZZDgkFentp_0',
    appId: '1:198968535354:web:bfaae84fd8c36740bec803',
    messagingSenderId: '198968535354',
    projectId: 'good-game-duo-24361',
    authDomain: 'good-game-duo-24361.firebaseapp.com',
    storageBucket: 'good-game-duo-24361.appspot.com',
    measurementId: 'G-P0472KBJW7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrSi2g4P7Q0eklf4L0KH1mOya1vOIEXK4',
    appId: '1:198968535354:android:597ac7a3ed51bce8bec803',
    messagingSenderId: '198968535354',
    projectId: 'good-game-duo-24361',
    storageBucket: 'good-game-duo-24361.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtoo_9GyVlcuLqRtO-CHkg2hUj0mjQ87E',
    appId: '1:198968535354:ios:a8be623356320bedbec803',
    messagingSenderId: '198968535354',
    projectId: 'good-game-duo-24361',
    storageBucket: 'good-game-duo-24361.appspot.com',
    iosClientId: '198968535354-5f7rabm2l5roksi9mnm33biocnthc4rn.apps.googleusercontent.com',
    iosBundleId: 'com.goodbam.goodGameDuo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtoo_9GyVlcuLqRtO-CHkg2hUj0mjQ87E',
    appId: '1:198968535354:ios:a8be623356320bedbec803',
    messagingSenderId: '198968535354',
    projectId: 'good-game-duo-24361',
    storageBucket: 'good-game-duo-24361.appspot.com',
    iosClientId: '198968535354-5f7rabm2l5roksi9mnm33biocnthc4rn.apps.googleusercontent.com',
    iosBundleId: 'com.goodbam.goodGameDuo',
  );
}
