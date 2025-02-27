// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = android;

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDsTrYxTpkHklKSDYIH1vGKZ9y0ddrnFJk",
    authDomain: "ustp-essentials-e06ea.firebaseapp.com",
    projectId: "ustp-essentials-e06ea",
    appId: "1:574949821815:web:9c12008dda7d499e0b6572",
    messagingSenderId: "574949821815",
    storageBucket: "ustp-essentials-e06ea.firebasestorage.app",
  );
}
