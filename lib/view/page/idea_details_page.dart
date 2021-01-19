import 'package:flutter/material.dart';
import 'package:idea_tracker/model/idea.dart';

class DetailsScreen extends StatelessWidget {
  final Idea idea;

  DetailsScreen({this.idea});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Idea Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.0, top: 25.0),
            child: Text(
              idea.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 5.0),
            child: Text(
              idea.description,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
