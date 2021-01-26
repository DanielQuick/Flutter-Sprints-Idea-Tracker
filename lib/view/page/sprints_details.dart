import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idea_tracker/model/sprint.dart';

class SprintsDetails extends StatefulWidget {

  final Sprint sprint;
  SprintsDetails(this.sprint);

  @override
  _SprintsDetailsState createState() => _SprintsDetailsState();
}

class _SprintsDetailsState extends State<SprintsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'go to the previous page',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'share this sprint',
            onPressed: () => null,
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed:  () => null,
            ),
          )
        ],
        backgroundColor: Colors.black87,
      ),
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    size: 15.0,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Text(
                                    _teamleader(widget.sprint),
                                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.sprint.title,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 15.0,),
                                  _createdAt(widget.sprint),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      width: 365,
                                      child: Text(
                                        widget.sprint.description,
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Row(
                                children: [
                                  Icon(Icons.star_border , size: 18.0, color: Colors.black.withOpacity(0.6),),
                                  SizedBox(width: 5.0,),
                                  Text(
                                    //TODO: make it work with button.
                                    '69 Stars',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(width: 25.0,),
                                  Icon(Icons.person_outline , size: 18.0, color: Colors.black.withOpacity(0.6),),
                                  SizedBox(width: 5.0,),
                                  Text(
                                    '${_numberOfContributers(widget.sprint.members, widget.sprint)} contributers',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ButtonBar(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      RaisedButton(
                                        child: Row(
                                          children: [
                                            Icon(Icons.star_border),
                                            SizedBox(width: 5.0,),
                                            Text('STAR')
                                          ],
                                        ),
                                        onPressed: () {},
                                        color: Colors.white,
                                      ),
                                      RaisedButton(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.hail,
                                              //color: Colors.lightGreen,
                                            ),
                                            SizedBox(width: 5.0,),
                                            Text('I\'M IN'),
                                          ],
                                        ),
                                        onPressed: () {},
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // NOT A USED FEATURE!! IGNORE !!

                        //Divider(
                          //height: 20.0,
                          //color: Colors.grey,
                        //),
                        //_latestTeamleaderPost(),
                        //SizedBox(height: 10.0,),

                        Divider(
                          height: 20.0,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Members', style: TextStyle(fontSize: 25.0),),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              _membersListTile(widget.sprint),
                            ],
                          ),
                        ),

                        // NOT A USED FEATURE!! IGNORE !!

                        //Divider(
                          //height: 20.0,
                          //color: Colors.grey,
                        //),
                        //_teamleaderPosts(),
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

  Widget _membersListTile(Sprint sprint){
    if(sprint.members == null){
      return Row(
        children: [
          Text(
            'There are no contributers',
            style: TextStyle(color: Colors.black.withOpacity(0.6),),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ListTile(
            leading: Icon(Icons.military_tech),
            title: Text(sprint.teamLeader),
            subtitle: Text("Teamleader"),
          ),
          Column(
            children: _loadMembersOnListTiles(sprint),
          ),
        ],
      );
    }
  }

  List<Widget> _loadMembersOnListTiles(Sprint sprint){
    List<String> members = sprint.members;
    return members.map((e) => _members(e)).toList();
  }
  
  Widget _members(String contributer){
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(contributer),
      subtitle: Text("Contributer"),
    );
  }

  String _numberOfContributers(List<String> members, Sprint sprint){
    if(sprint.members == null || sprint.members.length == 0){
      return '0';
    } else {
      return '${sprint.members.length}';
    }
  }

  String _teamleader(Sprint sprint){
    if(sprint.teamLeader == null){
      return 'There is no teamleader';
    } else {
      return sprint.teamLeader;
    }
  }

  Widget _createdAt(Sprint sprint){
    if(sprint.createdAt == null){
      return null;
    } else {
      return Text(
          '-   ${sprint.createdAt}',
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
      );
    }
  }

  Widget _teamleaderPost(String teamleader, String timeSincePosted, String post){
    return Padding(
      padding: const EdgeInsets.only(right:15.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              teamleader,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(width: 10.0,),
                            Text(
                              '-  ${timeSincePosted}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 280,
                          child: Text(
                            post,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NOT A USED FEATURE !! IGNORE !!
  Widget _latestTeamleaderPost(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Latest Teamleader Post', style: TextStyle(fontSize: 25.0),),
            ],
          ),
          SizedBox(height: 10.0,),
          _teamleaderPost(
              'DanielQuick',
              '3d',
              'sup'
          ),
        ],
      ),
    );
  }

  // NOT A USED FEATURE !! IGNORE !!
  Widget _teamleaderPosts(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Teamleader Post\'s', style: TextStyle(fontSize: 25.0),),
            ],
          ),
          SizedBox(height: 10.0,),
          _teamleaderPost('DanielQuick', '6d', 'hey'),
          _teamleaderPost('DanielQuick', '7d', 'heyyyy'),
          _teamleaderPost('DanielQuick', '8d', 'hallo'),
          _teamleaderPost('DanielQuick', '9d', 'bonjour'),
        ],
      ),
    );
  }

}
