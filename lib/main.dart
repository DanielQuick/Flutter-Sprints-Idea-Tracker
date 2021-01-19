import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/view/page/main_page.dart';
import 'package:idea_tracker/view/page/splash_page.dart';

void main() async{
  ///required here because setupLocator() implements firebase usage, otherwise app will not load
  WidgetsFlutterBinding.ensureInitialized();
  /// initalize Firebase
  await Firebase.initializeApp();
  debugPrint('Firebase initalized...');
  /// Enable FirebaseCrashlytics
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  debugPrint('Firebase Crashlytics collection enabled...');
  /// Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  debugPrint('Firebase Crashlytics flutter errors enabled...');

  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Idea Tracker",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => SplashPage(
              onComplete: () => Navigator.popAndPushNamed(context, "/landing"),
            ),
        "/landing": (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => Navigator.popAndPushNamed(context, "/main"),
                  child: Text("Fake sign in"),
                ),
              ),
            ),
        "/main": (context) => MainPage(),
      },
    );
  }
}
