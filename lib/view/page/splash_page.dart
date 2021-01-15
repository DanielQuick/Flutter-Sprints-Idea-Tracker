import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:idea_tracker/model/user.dart';
import 'package:idea_tracker/service/authentication_service.dart';
import 'package:idea_tracker/service/idea_service.dart';
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
    // Initialize all app dependencies
    
    /// initalize Firebase
    await Firebase.initializeApp();
    debugPrint('Firebase initalized...');
    /// Enable FirebaseCrashlytics
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    debugPrint('Firebase Crashlytics collection enabled...');
    /// Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    debugPrint('Firebase Crashlytics flutter errors enabled...');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // ensure the onComplete callback cannot be called in the same frame
      widget.onComplete();
    });

    AuthenticationService _authenticationService = new AuthenticationService();
    IdeaService _ideaService = new IdeaService();
    SprintService _sprintService = new SprintService();
    UserService _userService = new UserService();
    await _authenticationService.signUp("foobar@test.com", "123qweASD#\$%", "123qweASD#\$%");
    await _authenticationService.signOut();
    await _authenticationService.signIn("foobar@test.com", "123qweASD#\$%");
    await _ideaService.runIdeaServiceTest();
   //await _sprintService.runSprintServicesTest();
   //await _userService.runUserServiceTest();

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
