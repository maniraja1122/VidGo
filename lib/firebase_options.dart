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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAsFftrdUpShKo_OivgRh5S7H3RoJOkwPA',
    appId: '1:326216316701:web:ff3dcbee5062dccb7853f4',
    messagingSenderId: '326216316701',
    projectId: 'vidgo-f9466',
    authDomain: 'vidgo-f9466.firebaseapp.com',
    storageBucket: 'vidgo-f9466.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCj69eO-Dpb7nRYaj1NmqR70ywkc-He72M',
    appId: '1:326216316701:android:84cd00b96798e3f27853f4',
    messagingSenderId: '326216316701',
    projectId: 'vidgo-f9466',
    storageBucket: 'vidgo-f9466.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACRoHkljn5OjFgt_RgyZgZkSMxk--UbE4',
    appId: '1:326216316701:ios:00cba060d4f2e66e7853f4',
    messagingSenderId: '326216316701',
    projectId: 'vidgo-f9466',
    storageBucket: 'vidgo-f9466.appspot.com',
    iosClientId: '326216316701-865p3oofffh4vn0bu33t4ahg4ifquu3i.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialframe',
  );
}