import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idea_tracker/model/sprint.dart';

class SprintsPage extends StatefulWidget {
  @override
  _SprintsPageState createState() => _SprintsPageState();
}

class _SprintsPageState extends State<SprintsPage> {
  @override
  Widget build(BuildContext context) {
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
                            // SHOWCASE!! SHOWCASE!! SHOWCASE!!
                            _cardmaker('Idea tracker', 'DanielQuick_Plays', 'Create an idea - Describe the idea, maybe under predefined requirements '
                                'or templates - Resources for implementing the idea - Voting', context),
                            _cardmaker("Visual population tracker", "Zuko", "Full screen animation website that displays how many babies are born a second and how many people die, maybe how many people graduate from college a second and other cool life events. Then we could make animations for each thing. "
                                "and a number above the animation.It could be as simple as a 2d graphic in different quadrants, making a short animation "
                                "as the counter goes up or as complex as this graphic but I don't think it should be as complex as the photo, its just a "
                                "reference as an idea", context),
                            _cardmaker("Sprint 3", "X", "description3", context),
                            _cardmaker("Sprint 4", "Y", "description4", context),
                            _cardmaker("Sprint 5", "Z", "description5", context),
                            _cardmaker("Sprint 6", "Alpha", "description6", context),
                            // SHOWCASE!! SHOWCASE!! SHOWCASE!!
                          ],
                        ),

                        //_loadActiveSprintsOnCard(sprints, context),
                        //sprints is a list created by a builder from some DB

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

  List<Widget> _loadActiveSprintsOnCard(List<Sprint> sprints, BuildContext ctx){
    return sprints
        .map((e) => _cardmaker(e.title, e.teamLeader, e.description, ctx)).toList();
  }

  Widget _cardmaker(String title, String teamleader, String description, BuildContext ctx){
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text(title),
            subtitle: Text(
              'Team leader: ${teamleader}',
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
