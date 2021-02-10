import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/page/profile_page_controller.dart';
import 'package:idea_tracker/view/dialog/confirm_logout_dialog.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BaseView<ProfilePageController>(
      onControllerReady: (controller) {
        controller.onLogoutSuccess = () {
          Navigator.of(context, rootNavigator: true)
              .popAndPushNamed("/landing");
        };
      },
      builder: (context, controller, child) {
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
                onSelected: (value) async {
                  switch (value) {
                    case "Change Password":
                      {
                        print('change password');
                      }
                      break;
                    case "Log Out":
                      {
                        bool confirmed = await showDialog<bool>(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => ConfirmLogoutDialog(),
                        );
                        if (confirmed) {
                          // Navigator.of(context, rootNavigator: true)
                          //     .popAndPushNamed("/landing");
                          controller.logout();
                        }
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
            ],
          ),
        );
      },
    );
  }
}
