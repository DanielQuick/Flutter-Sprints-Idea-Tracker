import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'test_services.dart';

  setupFirebase() async{
    //WidgetsFlutterBinding.ensureInitialized();
    /// Enable FirebaseCrashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    debugPrint('Firebase Crashlytics collection enabled...');

    /// Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = await FirebaseCrashlytics.instance.recordFlutterError;
    debugPrint('Firebase Crashlytics flutter errors enabled...');

    TestServices testServices = new TestServices();
    testServices.testServices();
  }
