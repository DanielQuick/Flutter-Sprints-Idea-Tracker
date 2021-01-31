import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idea_tracker/controller/page/sprints_page_controller.dart';
import 'package:idea_tracker/model/sprint.dart';
import 'package:idea_tracker/view/page/sprints_details_page.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class SprintsPage extends StatefulWidget {
  @override
  _SprintsPageState createState() => _SprintsPageState();
}

class _SprintsPageState extends State<SprintsPage> {
  @override
  Widget build(BuildContext context) {
    return BaseView<SprintsPageController>(onControllerReady: (controller) {
      controller.initialize();
    }, builder: (context, controller, child) {
      return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(0, 15.0, 0, 30.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Active Sprints',
                                style: TextStyle(fontSize: 25.0),
                              ),
                              Divider(
                                height: 20.0,
                                color: Colors.grey,
                              ),
                              Column(
                                children: _loadActiveSprintsOnCard(
                                    controller.sprints, context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _loadActiveSprintsOnCard(
      List<Sprint> sprints, BuildContext ctx) {
    if (sprints.isNotEmpty) {
      return sprints
          .map((e) => _cardmaker(
              e.title, e.teamLeader, e.description, e.members, ctx, e))
          .toList();
    } else {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              SizedBox(
                width: 15.0,
              ),
              Text(
                'There are no active sprints',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ],
          ),
        )
      ];
    }
  }

  String _numberOfContributers(List<String> members, Sprint sprint) {
    if (sprint.members == null || sprint.members.length == 0) {
      return '0';
    } else {
      return '${sprint.members.length}';
    }
  }

  Widget _cardmaker(String title, String teamleader, String description,
      List<String> members, BuildContext ctx, Sprint sprint) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text(title),
            subtitle: Text(
              'Team leader: ${_teamleader(sprint)}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 18.0,
                  color: Colors.black.withOpacity(0.6),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  '${_numberOfContributers(members, sprint)} contributers',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (context) =>
                            SprintsDetailsPage(sprint: sprint)),
                  );
                },
                child: const Text('DETAILS'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _teamleader(Sprint sprint) {
    if (sprint.teamLeader == null) {
      return '';
    } else {
      return sprint.teamLeader;
    }
  }
}
