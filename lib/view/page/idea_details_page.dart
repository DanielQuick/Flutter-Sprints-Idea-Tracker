import 'package:flutter/material.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/model/user.dart';
import 'package:idea_tracker/view/page/idea_edit_details_page.dart';

class IdeaDetailsPage extends StatelessWidget {
  final Idea idea;

  IdeaDetailsPage({this.idea});

  Widget getEditButton(String userId, BuildContext context) {
    if (userId == idea.creatorId) {
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IdeaEditDetailsPage('Edit Idea', idea),
            ),
          );
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Idea Details'),
        actions: [
          getEditButton(User().id, context),
        ],
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
