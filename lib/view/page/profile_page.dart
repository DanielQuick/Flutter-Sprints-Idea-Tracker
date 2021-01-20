import 'package:flutter/material.dart';
import 'package:idea_tracker/view/dialog/confirm_logout_dialog.dart';

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
              PopupMenuItem(
                child: Text("Change Password"),
                value: 'Change Password',
              ),
              PopupMenuItem(
                child: Text("Log Out"),
                value: 'Log Out',
              )
            ],
            onSelected: (value) {
              switch (value) {
                case "Change Password":
                  {
                    print('change password');
                  }
                  break;
                case "Log Out":
                  {
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Confim_Logout_Dialog();
                      },
                    );
                  }
                  break;
              }
            },
            icon: Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  child: Text('# of sprints joined'),
                ),
                Container(
                  width: 100,
                  child: Text('# of times user has been team lead'),
                )
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          Container(child: Text('Sprints Participant')),
          Container(child: Text('Team Lead')),
          Container(child: Text('Voted')),
        ],
      ),
    );
  }
}
