import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

setupFirebase() async {
  ///initalize Firebase
  await Firebase.initializeApp();
  debugPrint('Firebase initialized...');

  /// Enable FirebaseCrashlytics
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  debugPrint('Firebase Crashlytics collection enabled...');

  /// Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  debugPrint('Firebase Crashlytics flutter errors enabled...');
}
