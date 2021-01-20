import 'package:flutter/material.dart';
import 'package:idea_tracker/view/page/splash_page.dart';

class Confim_Logout_Dialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logging Out'),
      content: Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.popAndPushNamed(context, "/landing"),
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('No'),
        ),
      ],
    );
  }
}
