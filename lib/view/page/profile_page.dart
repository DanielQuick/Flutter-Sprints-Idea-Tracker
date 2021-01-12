import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Change Password")),
              PopupMenuItem(child: Text("Log Out"))
            ],
            icon: Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.purple,
            ),
          ),
          Column(
            children: [
              Text('Sprints Participant'),
              Text('Team Lead'),
              Text('Voted'),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text('Idea'), Text('Sprints'), Text('Profile')],
          ),
        ),
      ),
    );
  }
}
