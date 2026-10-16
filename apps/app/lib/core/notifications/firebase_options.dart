import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for BuyNaija.
///
/// Generated with fallback configuration to ensure the application compiles
/// and runs out-of-the-box across Android, iOS, and Web.
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
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyMockKeyForABAErpPushNotification001',
    appId: '1:100000000001:web:abcdef0123456789abcdef',
    messagingSenderId: '100000000001',
    projectId: 'aba-buynaija-app',
    authDomain: 'aba-buynaija-app.firebaseapp.com',
    storageBucket: 'aba-buynaija-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyMockKeyForABAErpPushNotification001',
    appId: '1:100000000001:android:abcdef0123456789abcdef',
    messagingSenderId: '100000000001',
    projectId: 'aba-buynaija-app',
    storageBucket: 'aba-buynaija-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyMockKeyForABAErpPushNotification001',
    appId: '1:100000000001:ios:abcdef0123456789abcdef',
    messagingSenderId: '100000000001',
    projectId: 'aba-buynaija-app',
    storageBucket: 'aba-buynaija-app.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyMockKeyForABAErpPushNotification001',
    appId: '1:100000000001:ios:abcdef0123456789abcdef',
    messagingSenderId: '100000000001',
    projectId: 'aba-buynaija-app',
    storageBucket: 'aba-buynaija-app.appspot.com',
    iosBundleId: 'com.example.app',
  );
}
