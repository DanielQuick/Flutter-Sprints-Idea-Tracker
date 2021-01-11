import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>  {
  @override
  Widget build(BuildContext context) {
    //FirebaseCrashlytics.instance.crash();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network('https://apod.nasa.gov/apod/image/2101/PhoenixAurora_Helgason_960_annotated.jpg', fit: BoxFit.contain,),
                Text(
                  'Idea Tracker',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .apply(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Login to Start',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .apply(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}