import 'package:flutter/material.dart';

class IdeaDetailsPage extends StatelessWidget {
  final String title;
  final String description;

  IdeaDetailsPage({this.title, this.description});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('$title Idea'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
