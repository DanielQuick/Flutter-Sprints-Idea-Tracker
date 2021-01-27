import 'package:flutter/material.dart';
import 'package:idea_tracker/view/page/create_idea_page.dart';

class NoIdeasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Ideas Available'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No ideas available now',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20.0),
            Text(
              'Tap the button below to create a new one!',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateIdeaPage('Create Idea'),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
