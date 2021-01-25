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
                                    widget.sprint.teamLeader,
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
                                  Text(
                                    '-   ${widget.sprint.createdAt}',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
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
                                    '${widget.sprint.members.length} contributers',
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
                                            Icon(Icons.hail),
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
                              ListTile(
                                  leading: Icon(Icons.military_tech),
                                  title: Text(widget.sprint.teamLeader),
                                  subtitle: Text("Teamleader"),
                              ),
                              Column(
                                children: _loadMembersOnListTiles(widget.sprint),
                              ),
                            ],
                          ),
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
}
