import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/user.dart';
import 'package:idea_tracker/service/authentication_service.dart';
import 'package:idea_tracker/view/dialog/show_auth_error.dart';

class LandingController extends ChangeNotifier {
  Function(String) onAuthorization;
  TextEditingController emailController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  User _user;

  final _auth = locator<AuthenticationService>();

  Future<bool> signIn(String email, String pwd) async {
    String signIn = await  _auth.signIn(email, pwd);
    if(signIn == 'Signed In') {
      _user = _auth.getAuthenticatedUser();
      print(_user.toString());
      if (onAuthorization != null) onAuthorization("Authenticated");
      return true;
    } else {
      print(signIn);
      ShowAuthError(signIn);
      return false;
    }
  }

  Future<bool> signUp(String userName, String email, String pwd, String pwdVerify) async {
    String signUp = await _auth.signUp(email, userName, pwd, pwdVerify);
    if(signUp == 'Signed Up') {
      _user = _auth.getAuthenticatedUser();
      print(_user.toString());
      if (onAuthorization != null) onAuthorization("Authenticated");
      return true;
    } else {
      print(signUp);
      ShowAuthError(signUp);
      return false;
    }
  }

  void forgotPassword(String email) async {
    await _auth.forgotPassword(email);
  }

  void resetPassword(String pwd, String pwdVerify) async {
    _auth.changePassword(pwd, pwdVerify);
  }

}
