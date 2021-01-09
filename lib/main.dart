import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/test_screen.dart';
import 'test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  /// Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Idea Tracker",
      theme: ThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Color(0xFF56A0D2),
        accentColor: Color(0xFF00469C),
        secondaryHeaderColor: Colors.white,
        buttonTheme: ButtonThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Color(0xFF56A0D2),
                secondary: Colors.white,
              ),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 30),
      ),
      darkTheme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Color(0xFF00469C),
        accentColor: Color(0xFF56A0D2),
        secondaryHeaderColor: Colors.white70,
        buttonTheme: ButtonThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Color(0xFF00469C),
                secondary: Colors.white70,
              ),
        ),
        iconTheme: IconThemeData(color: Colors.white70, size: 30),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        // When navigating to the '/*' route, build the named widget.
        '/': (context) => LoginScreen(),
        //'/home': (context) => HomeScreen(),
      },
    );
  }
}
