import 'package:flutter/material.dart';
import 'package:idea_tracker/view/page/splash_page.dart';

class Confim_Logout_Dialog extends StatelessWidget {
  const Confim_Logout_Dialog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logging Out'),
      content: Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, true), child: Text('Yes')),
        TextButton(
            onPressed: () => Navigator.pop(context, false), child: Text('No')),
      ],
    );
  }
}
