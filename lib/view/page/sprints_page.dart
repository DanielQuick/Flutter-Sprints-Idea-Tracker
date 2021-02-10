import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idea_tracker/controller/page/sprints_page_controller.dart';
import 'package:idea_tracker/model/sprint.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class SprintsPage extends StatefulWidget {
  @override
  _SprintsPageState createState() => _SprintsPageState();
}

class _SprintsPageState extends State<SprintsPage> {
  @override
  Widget build(BuildContext context) {
    return BaseView<SprintsPageController>(
      onControllerReady: (controller){
        controller.initialize();
      },
      builder: (context, controller, child){
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
                                  style: TextStyle(
                                      fontSize: 25.0
                                  ),
                                ),
                                Divider(
                                  height: 20.0,

                                  color: Colors.grey,
                                ),
                                Column(
                                  children: _loadActiveSprintsOnCard(controller.sprints, context),
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
      }
    );
  }

  List<Widget> _loadActiveSprintsOnCard(List<Sprint> sprints, BuildContext ctx){
    return sprints
        .map((e) => _cardMaker(e.title, e.teamLeader, e.description, ctx)).toList();
  }


  Widget _cardMaker(String title, String teamLeader, String description, BuildContext ctx){
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text(title),
            subtitle: Text(
              'Team leader: $teamLeader',
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
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('DETAILS'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
