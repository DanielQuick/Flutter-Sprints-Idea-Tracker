import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/user.dart';
import 'package:idea_tracker/service/authentication_service.dart';

class LandingController extends ChangeNotifier {
  Function(String) onRegistration;
  Function(String) onLogin;
  Function(String) onReset;
  Future<bool> Function() onSuccess;
  String email;
  String pwd;
  String pwdVerify;
  String userName;

  TabController tabController;
  User _user;

  final _auth = locator<AuthenticationService>();

  void signIn() async {
    await  _auth.signIn(email, pwd);
  }

  void signUp() async {
    await _auth.signUp(email, userName, pwd, pwdVerify);
    print(_user.toString());
  }

  void forgotPassword() async {
    await _auth.forgotPassword(email);
  }

  void resetPassword() async {
    _auth.changePassword(pwd, pwdVerify);
  }

}
