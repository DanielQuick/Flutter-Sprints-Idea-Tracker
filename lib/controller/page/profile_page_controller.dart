import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/service/authentication_service.dart';

class ProfilePageController extends ChangeNotifier {
  Function onLogoutSuccess;

  changePassword() {
    return print("change password");
  }

  logout() async {
    await locator<AuthenticationService>().signOut();
    if (onLogoutSuccess != null) onLogoutSuccess();
  }
}
