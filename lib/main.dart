import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/view/page/main_page.dart';
import 'package:idea_tracker/view/page/splash_page.dart';
import 'package:idea_tracker/view/page/landing_page.dart';

void main() {
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
        "/landing": (context) => Landing(),
        "/main": (context) => MainPage(),
      },
    );
  }
}
