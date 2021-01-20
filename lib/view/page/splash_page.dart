import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:idea_tracker/service/services.dart';

class SplashPage extends StatefulWidget {
  final Function onComplete;
  SplashPage({Key key, this.onComplete}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() async {
    /// Initialize all app dependencies

    ///initalize Firebase
    await Firebase.initializeApp();
    debugPrint('Firebase initialized...');

    ///initialize Firebase related services
    setupFirebase();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      /// ensure the onComplete callback cannot be called in the same frame
      widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
