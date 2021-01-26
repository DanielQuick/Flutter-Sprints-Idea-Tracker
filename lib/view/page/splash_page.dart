import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:idea_tracker/service/services.dart';
import 'package:idea_tracker/locator.dart';
import 'test_services.dart';

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

    ///initialize Firebase and related services
    await setupFirebase().then((_){
      /// this is here to ensure initialization of each Firebase Service happens
      /// after Firebase.initializeApp()
      UserService _userService = locator<UserService>();
      IdeaService _ideaService = locator<IdeaService>();
      SprintService _sprintService = locator<SprintService>();
      AuthenticationService _authenticationService =
      locator<AuthenticationService>();
      _userService.initialize();
      _authenticationService.initialize();
      _ideaService.initialize();
      _sprintService.initialize();
      ///Test services is located under the Test File
      TestServices testServices = new TestServices();
      testServices.testServices();
    });

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
