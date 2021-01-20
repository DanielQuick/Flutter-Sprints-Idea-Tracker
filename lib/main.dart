import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/service/firebase_service.dart';
import 'package:idea_tracker/view/page/main_page.dart';
import 'package:idea_tracker/view/page/splash_page.dart';

void main() async{
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
