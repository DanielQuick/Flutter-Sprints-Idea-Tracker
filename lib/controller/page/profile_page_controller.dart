import 'package:flutter/material.dart';
import 'package:idea_tracker/view/dialog/confirm_logout_dialog.dart';
import 'package:idea_tracker/view/page/splash_page.dart';

class ProfilePageController extends ChangeNotifier {
  int _tabs = 0;

  onTabSelected() {}
  _changePassword() {
    return print("change password");
  }

  _logout() {
    return Confim_Logout_Dialog();
  }
}
