import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idea_tracker/model/sprint.dart';

class SprintsDetails extends StatefulWidget {

  //final Sprint sprint;
  //SprintsDetails(this.sprint)

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
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'delete this sprint',
            onPressed: () => null,
          ),
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed:  () => null,
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
                                    'DanielQuick',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Idea tracker',
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 15.0,),
                                  Text(
                                    '-   24/01/2021',
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
                                        'Create an idea - Describe the idea, maybe under predefined requirements or templates - Resources for implementing the idea - Voting',
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
                                    '69 Stars',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(width: 25.0,),
                                  Icon(Icons.person_outline , size: 18.0, color: Colors.black.withOpacity(0.6),),
                                  SizedBox(width: 5.0,),
                                  Text(
                                    '7 contributers',
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
                                  title: Text("DanielQuick"),
                                  subtitle: Text("Teamleader"),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text("OsamaBinNaughty-hub"),
                                subtitle: Text("Contributer"),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text("labody"),
                                subtitle: Text("Contributer"),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text("xopherw"),
                                subtitle: Text("Contributer"),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text("Abdul-Aziz"),
                                subtitle: Text("Contributer"),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text("manuelvargastapia"),
                                subtitle: Text("Contributer"),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text("taracell"),
                                subtitle: Text("Contributer"),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text("DanielQuick"),
                                subtitle: Text("Contributer"),
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
  Widget _memberCards(String contributer){
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(contributer),
            subtitle: Text(
              'Team leader: }',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
