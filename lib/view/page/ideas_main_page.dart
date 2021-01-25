import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/page/ideas_main_page_controller.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/view/page/create_idea_page.dart';
import 'package:idea_tracker/view/page/idea_details_page.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class IdeasMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<IdeasMainPageController>(onControllerReady: (controller) {
      controller.initialize();
    }, builder: (context, controller, child) {
      return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          title: Text('Ideas'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateIdeaPage('Create Idea')));
          },
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: controller.ideas.length,
            itemBuilder: (context, index) {
              return IdeaCard(
                idea: controller.ideas[index],
              );
            }),
      );
    });
  }
}

class IdeaCard extends StatelessWidget {
  final Idea idea;

  IdeaCard({this.idea});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IdeaDetailsPage(idea: idea),
          ),
        );
      },
      child: Container(
        height: 180.0,
        width: 400.0,
        margin: EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 10.0),
                child: Text(
                  idea.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 5.0),
                child: Text(
                  idea.description,
                  style: TextStyle(fontSize: 17.0),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
