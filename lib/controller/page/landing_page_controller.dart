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
  TextEditingController pwdController = new TextEditingController();
  TextEditingController pwdVerifyController = new TextEditingController();

  User _user;

  final _auth = locator<AuthenticationService>();

  Future<bool> signIn() async {
    String signIn =
        await _auth.signIn(emailController.text, pwdController.text);
    if (signIn == 'Signed In') {
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

  Future<bool> signUp() async {
    String signUp = await _auth.signUp(emailController.text,
        userNameController.text, pwdController.text, pwdVerifyController.text);
    if (signUp == 'Signed Up') {
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

  void forgotPassword() async {
    await _auth.forgotPassword(emailController.text);
  }

  void resetPassword(String pwd, String pwdVerify) async {
    _auth.changePassword(pwdController.text, pwdVerifyController.text);
  }
}
