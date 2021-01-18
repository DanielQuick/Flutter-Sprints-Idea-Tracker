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
          title: Text('Idea Details'),
        ),
      ),
    );
  }
}
