import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:idea_tracker/service/sprint_service.dart';
import 'package:idea_tracker/service/test_services.dart';
import 'package:idea_tracker/service/user_service.dart';

import '../locator.dart';
import 'authentication_service.dart';
import 'idea_service.dart';

setupFirebase() async {
  ///initalize Firebase
  await Firebase.initializeApp();
  debugPrint('Firebase initialized...');

  /// Enable FirebaseCrashlytics
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  debugPrint('Firebase Crashlytics collection enabled...');

  /// Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = await FirebaseCrashlytics.instance.recordFlutterError;
  debugPrint('Firebase Crashlytics flutter errors enabled...');

  /// this is here to ensure initialization of each Firebase Service happens after Firebase.initializeApp()
  UserService _userService = locator<UserService>();
  IdeaService _ideaService = locator<IdeaService>();
  SprintService _sprintService = locator<SprintService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  _userService.initialize();
  _authenticationService.initialize();
  _ideaService.initialize();
  _sprintService.initialize();

  TestServices testServices = new TestServices();
  testServices.testServices();
}
