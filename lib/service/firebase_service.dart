import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'services.dart';
import '../locator.dart';
import 'test_services.dart';

  setupFirebase() async{

    /// Enable FirebaseCrashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    debugPrint('Firebase Crashlytics collection enabled...');

    /// Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = await FirebaseCrashlytics.instance.recordFlutterError;
    debugPrint('Firebase Crashlytics flutter errors enabled...');

    locator<AuthenticationService>().initialize();
    locator<UserService>().initialize();
    locator<IdeaService>().initialize();
    locator<SprintService>().initialize();

    TestServices testServices = new TestServices();
    testServices.testServices();
  }
